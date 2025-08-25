#include "Hardware/gds/GDSScanner.hpp"
#include <string>

// TODO: add secondary_rectangles to the constructor of the GDSScanner through settings
GDSScanner::GDSScanner(const std::string& path, const std::string& top_level_name,
                         const std::vector<std::string>& ignore_gate_types,
                         FaultInjectionSettings & settings,
                         const Coordinate& init_center_probe,
                         size_t max_size_combination,
                         Logger& logger)
    : path_(path), top_level_name_(top_level_name), ignore_gate_types_(ignore_gate_types),
      settings_(settings), init_center_probe_(init_center_probe),
      max_size_combination_(max_size_combination), logger_(logger) {
    initializeBlacklist();
    gdstk::Library lib = util::ParseGDS(path);
    util::print_all_cells(lib);
    BOOST_LOG_TRIVIAL(info) << "GDS file is parsed!";
    gates_ = blacklist_.FilterGates(lib, top_level_name);
    BOOST_LOG_TRIVIAL(info) << "Parsed cells are filtered using the blacklist!";
    // TODO: how much cells are removed?
    top_module_bb_ = BoundingBox::extract_top_module_bounding_box(lib, top_level_name);
    BOOST_LOG_TRIVIAL(info) << "Toplevel Bounding Box is extracted!";
    // TODO: what is the name of the toplevel bounding box? what are its characteristics?
    lib.clear();

    GDSScanner::initializeProbe();
    BOOST_LOG_TRIVIAL(info) << "Probe is initilized!";

    BOOST_LOG_TRIVIAL(info) << "Compute attackable gate combinations ...";
    GDSScanner::ComputeAndSetAttackedGateCombinations();
    // TODO: move this to unittests
    for (const auto & it : this->attacked_gate_combinations_) {
      if(it.attacked_gates_.size() == 0){
        throw std::runtime_error("There should be NO AttackedSurface with zero sized vector");
      }
    }
    GDSScanner::ComputeAndSetPositionsToHitMap();
    GDSScanner::ComputeAndSetAverageHitsPerLocation();
    GDSScanner::PrintDetailsOfAnalyis();

    GDSScanner::Report();
    logger_.PrintFinalMessage("Forward results of the GDS scanning process to FIESTA!");
    GDSScanner::ConvertToFIESTAInput();
}

void GDSScanner::initializeBlacklist() {
  for (const std::string& gate_type : ignore_gate_types_) {
    if (gate_type == "physical") {
        BlacklistSkyPhysical blacklist_physical;
        blacklist_ += blacklist_physical;
    } else if (gate_type == "combinatorial") {
        BlacklistSkyCombinatorial blacklist_combinatorial;
        blacklist_ += blacklist_combinatorial;
    } else if (gate_type == "buffer") {
        BlacklistSkyBuffer blacklist_buffer;
        blacklist_ += blacklist_buffer;
    } else if (gate_type == "clk_buffer") {
        BlacklistSkyClkBuffer blacklist_clk_buffer;
        blacklist_ += blacklist_clk_buffer;
    } else if (gate_type == "sequential") {
        BlacklistSkySequential blacklist_sequential;
        blacklist_ += blacklist_sequential;
    }
  }

  BOOST_LOG_TRIVIAL(trace) << "Blacklist Elements: " << blacklist_;
  BOOST_LOG_TRIVIAL(info) << "Blacklist is constructed!";

}

void GDSScanner::initializeProbe() {

  GDSRectangle primary_rectangle{init_center_probe_, settings_.probe.include.radius, Coordinate(0,0)};

  const Coordinate top_module_size = top_module_bb_.get_size();
  const Coordinate step_size{
    ((top_module_size.x - init_center_probe_.x) / settings_.resolution.x),
    ((top_module_size.y - init_center_probe_.y) / settings_.resolution.y)};
  // TODO: considere to automatically determine the smallest shape in the design and set the
  // step width to that shape.
  //

  std::vector<GDSRectangle> secondary_rectangles;
  for (const RectangleConfig& rect : settings_.probe.exclude) {
    secondary_rectangles.emplace_back(init_center_probe_, rect.radius, rect.offset);
  }

  probe_ = GDSProbe{
    primary_rectangle,
    secondary_rectangles,
    step_size,
    settings_.resolution.x,
    settings_.resolution.y
  };
  BOOST_LOG_TRIVIAL(info) << "Start Position: " << probe_ << std::endl;

}

void GDSScanner::PrintDetailsOfAnalyis() {
  std::vector<TableCell> table_cells_header{
    {"Toplevel Module", 15},
    {"Top-Module Size", 15},
    {"Scanner Resolution", 18},
    {"#Positions with hits",20},
    {"Average hits per position",25}
  };


  std::string topmodule_size_x = std::format("{:.3f}", this->top_module_bb_.get_size().x);
  std::string topmodule_size_y = std::format("{:.3f}", this->top_module_bb_.get_size().y);
  std::vector<TableCell> table_cells_row{
    {this->top_level_name_,15},
    {topmodule_size_x +" / " + topmodule_size_y, 15},
    {
      std::to_string(this->settings_.resolution.x) +
      " / " +
      std::to_string(this->settings_.resolution.y),
      18
    },
    {std::to_string(this->attacked_gate_combinations_.size()), 20},
    {std::to_string(this->average_hits_per_location_), 25},
  };

  this->logger_.PrintInfoMessage("Properties of the GDS scan:");
  this->logger_.PrintHeader(table_cells_header);
  this->logger_.PrintRowWithSeparation(table_cells_row, true);
}

void GDSScanner::ComputeAndSetAttackedGateCombinations(){

  for (size_t iy{0}; iy < this->probe_.number_of_probe_positions_y_; ++iy) {
    for (size_t ix{0}; ix < this->probe_.number_of_probe_positions_x_; ++ix) {
      BOOST_LOG_TRIVIAL(trace) << "Analyize position (" << ix << ", " << iy << ")";

      AttackedSurface attacked_surface{this->probe_, this->gates_};
      if (attacked_surface.attacked_gates_.size() != 0) {
        this->attacked_gate_combinations_.insert(attacked_surface);
      }
      this->probe_.StepX();
    }
    this->probe_.StepY();
    this->probe_.ResetX();
  }
}

 void GDSScanner::ComputeAndSetPositionsToHitMap(){
  for(const auto& attacked_surface : this->attacked_gate_combinations_){
    ++this->postions_to_hits_map_[attacked_surface.attacked_gates_.size()];
  }
}

void GDSScanner::Report(){

  std::vector<TableCell> table_cells_header{
    {"#Faulted Gates", 14},
    {"Occurance", 11},
  };


  this->logger_.PrintInfoMessage("Result summary of the GDS scan:");
  this->logger_.PrintHeader(table_cells_header);

  size_t idx{0};
  for (const auto & count : this->postions_to_hits_map_) {
    TableCell num_faulted_gates{std::to_string(count.first), 14};
    TableCell occurance{std::to_string(count.second), 11};
    std::vector<TableCell> table_cells_row{num_faulted_gates, occurance};
    if(idx < this->postions_to_hits_map_.size()-1){
      this->logger_.PrintRow(table_cells_row);
    } else {
      this->logger_.PrintRowWithSeparation(table_cells_row, false);
    }
    ++idx;
  }
  this->logger_.PrintInfoMessage("The GDS analysis is completed!");
}

std::string GDSScanner::CreateRegexFromGateNamesAsString(const std::vector<const Gate *>& gates) {
    std::string pattern = "^(";  // Start the pattern with ^ and a group (

    // Iterate over the strings to build the pattern
    for (size_t i = 0; i < gates.size(); ++i) {
      // std::string str = gates[i]->name;
      // bool bug = (str.find("input") != std::string::npos || str.find("output") != std::string::npos);
      // if(!bug){
      //   continue;
      // }
        pattern += gates[i]->name;    // Add the string
        if (i < gates.size() - 1) {
            pattern += "|";       // Add '|' between each string except the last
        }
    }

    pattern += ")$";  // Close the group and add $ for end of string
    return pattern;
}

std::regex GDSScanner::CreateRegexFromGateNames(const std::vector<const Gate *>& gates) {
    return std::regex(CreateRegexFromGateNamesAsString(gates));
}


void GDSScanner::WriteFaultProperty(boost::property_tree::ptree &fault_properties_array,
                        const std::string &type,
                        double probability,
                        bool fault_logic_gates,
                        bool fault_storage_gates,
                        const std::string &include_signals,
                        const std::string &exclude_signals) {
    // Validate the regex strings
    try {
        std::regex include_regex(include_signals);
        std::regex exclude_regex(exclude_signals);
    } catch (const std::regex_error &e) {
        std::cerr << "Invalid regex pattern: " << e.what() << std::endl;
        return;
    }

    // Create a new property tree for the fault_property
    boost::property_tree::ptree fault_property;

    // Set the fault_property fields
    fault_property.put("type", type);
    fault_property.put<double>("probability", probability);
    fault_property.put("fault_logic_gates", fault_logic_gates);
    fault_property.put("fault_storage_gates", fault_storage_gates);

    // Define fault locations with include and exclude signals
    boost::property_tree::ptree fault_locations;

    boost::property_tree::ptree exclude;
    exclude.put("signals", exclude_signals);
    fault_locations.add_child("exclude", exclude);

    boost::property_tree::ptree include;
    include.put("signals", include_signals);
    fault_locations.add_child("include", include);

    // Add fault_locations to fault_property
    fault_property.add_child("fault_locations", fault_locations);

    // Wrap the fault property into an array
    boost::property_tree::ptree fault_property_wrapper;
    fault_property_wrapper.push_back(std::make_pair("", fault_property));

    // Add the array-wrapped fault property to the parent array
    fault_properties_array.push_back(std::make_pair("", fault_property_wrapper));
}

void GDSScanner::WriteJsonObjectToFile(boost::property_tree::ptree root){

  // Write the JSON structure to a file
  std::ofstream file("fault_properties.json");
  boost::property_tree::write_json(file, root);
  file.close();
}

void GDSScanner::ComputeAndSetAverageHitsPerLocation(){

  for (const auto & count  : this->postions_to_hits_map_) {
    average_hits_per_location_ += count.first * count.second;
  }
  average_hits_per_location_ =
    average_hits_per_location_ / this->attacked_gate_combinations_.size();
}

void GDSScanner::ConvertToFIESTAInput() {
  if(settings_.fault_adversaries.empty()){
  throw std::runtime_error(
      "At least one adversary must be configured to be chosen as template for the automatically derived once."
    );
  }

  // NOTE: Here we consider only one fault type and one fault probability
  const FaultProperties template_property = settings_.fault_adversaries[0][0];

  for (auto & prop : settings_.fault_adversaries) {
    prop.clear();
  }
  settings_.fault_adversaries.clear();

  for (const auto &attack : this->attacked_gate_combinations_) {
      if(attack.attacked_gates_.size() <= max_size_combination_){

      std::string signals = CreateRegexFromGateNamesAsString(attack.attacked_gates_);
      std::vector<FaultProperties> property(1,template_property);
      property[0].locations.included_elements = std::regex(signals);

      settings_.fault_adversaries.push_back(property);
    }
  }
}
