#include "Hardware/gds/GDSScanner.hpp"
#include "Util/Settings.hpp"
#include <iostream>
#include <regex>

// TODO: add secondary_rectangles to the constructor of the GDSScanner through settings
GDSScanner::GDSScanner(const std::string& path, const std::string& top_level_name,
                         const std::vector<std::string>& ignore_gate_types,
                         FaultInjectionSettings & settings,
                         const Coordinate& init_center_probe, size_t max_size_combination)
    : path(path), top_level_name(top_level_name), ignore_gate_types(ignore_gate_types),
      settings_(settings),
      init_center_probe(init_center_probe), max_size_combination(max_size_combination) {
    initializeBlacklist();
    gdstk::Library lib = util::ParseGDS(path);
    gates = blacklist.FilterGates(lib, top_level_name);
    top_module_bb = BoundingBox::extract_top_module_bounding_box(lib, top_level_name);
    lib.clear();
    initializeProbe();
}

void GDSScanner::initializeBlacklist() {
    for (const std::string& gate_type : ignore_gate_types) {
        if (gate_type == "physical") {
            BlacklistSkyPhysical blacklist_physical;
            blacklist += blacklist_physical;
        } else if (gate_type == "combinatorial") {
            BlacklistSkyCombinatorial blacklist_combinatorial;
            blacklist += blacklist_combinatorial;
        } else if (gate_type == "buffer") {
            BlacklistSkyBuffer blacklist_buffer;
            blacklist += blacklist_buffer;
        } else if (gate_type == "clk_buffer") {
            BlacklistSkyClkBuffer blacklist_clk_buffer;
            blacklist += blacklist_clk_buffer;
        } else if (gate_type == "sequential") {
            BlacklistSkySequential blacklist_sequential;
            blacklist += blacklist_sequential;
        }
    }
    std::cout << "--------------------------------------------------------------------------------\n";
    std::cout << "Blacklist:\n" << blacklist;
    std::cout << "--------------------------------------------------------------------------------\n";
    std::cout << std::endl;
}

void GDSScanner::initializeProbe() {

  GDSRectangle primary_rectangle{init_center_probe, settings_.probe.include.radius, Coordinate(0,0)};

  const Coordinate top_module_size = top_module_bb.get_size();
  const Coordinate step_size{
    ((top_module_size.x - init_center_probe.x) / settings_.resolution.x),
    ((top_module_size.y - init_center_probe.y) / settings_.resolution.y)};
  // TODO: considere to automatically determine the smallest shape in the design and set the
  // step width to that shape.
  //

  std::vector<GDSRectangle> secondary_rectangles;
  for (const RectangleConfig& rect : settings_.probe.exclude) {
    secondary_rectangles.emplace_back(init_center_probe, rect.radius, rect.offset);
  }

  probe = GDSProbe{
    primary_rectangle,
    secondary_rectangles,
    step_size,
    settings_.resolution.x,
    settings_.resolution.y
  };
  std::cout << "Start Position: " << probe << std::endl;
}

std::set<AttackedSurface> GDSScanner::ComputeAttackedGateSet(const Gates & gates,
                                                 GDSProbe probe){

  std::set<AttackedSurface> attacked_gates_set;

  for (size_t iy{0}; iy < probe.number_of_probe_positions_y_; ++iy) {
    for (size_t ix{0}; ix < probe.number_of_probe_positions_x_; ++ix) {

      AttackedSurface attacked_surface{probe, gates};
      if (attacked_surface.attacked_gates_.size() != 0) {
        attacked_gates_set.insert(attacked_surface);
      }
      // if ( attacked_surface.attacked_gates_.size() == 4){
      //   std::cout << "[" << ix << "," << iy << "]" << probe << ":";
      //   std::cout << "\n\t" << attacked_surface.attacked_gates_.size() << std::endl;
      // }
      probe.StepX();
    }
    probe.StepY();
    probe.ResetX();
  }

  return attacked_gates_set;
}

std::map<size_t, size_t> GDSScanner::GroupByHitCount(std::set<AttackedSurface> attacked_surfaces){
  std::map<size_t, size_t> count_hits;
  for(const auto& attacked_surface : attacked_surfaces){
    ++count_hits[attacked_surface.attacked_gates_.size()];
  }
  return count_hits;
}

void Report(size_t number_of_positions_with_hit,
            double average,
            const std::map<size_t, size_t> &counter){
  std::cout << "Total Fault Locations:\t" << number_of_positions_with_hit;
  std::cout << "\nAverage Hits per Location:\t" << average;
  std::cout << std::setw(16) << "\n#Faulted Gates" << std::setw(16) << "#Hits" << std::endl;
  for (const auto & count : counter) {
    std::cout << std::setw(16) << count.first << std::setw(16) << count.second << std::endl;
  }

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

void GDSScanner::scan() {
  std::set<AttackedSurface> attacked_gates_set{ComputeAttackedGateSet(gates, probe)};


  // TODO: move this to unittests
  for (const auto & it : attacked_gates_set) {
    if(it.attacked_gates_.size() == 0){
      throw std::runtime_error("There should be NO AttackedSurface with zero sized vector");
    }
  }

  double average_size{0};
  std::map<size_t, size_t> counter{GroupByHitCount(attacked_gates_set)};

  for (const auto & count  : counter) {
    average_size += count.first * count.second;
  }
  average_size = average_size / attacked_gates_set.size();


  Report(attacked_gates_set.size(), average_size, counter);

  for (const auto & area : attacked_gates_set) {
    if(area.attacked_gates_.size() > max_size_combination){
      std::cout << area << std::endl;
    }
  }

  // Root JSON object
  boost::property_tree::ptree root;
  boost::property_tree::ptree &fault_properties = root.put_child("fault_properties", boost::property_tree::ptree());

  if(settings_.fault_adversaries.empty()){
  throw std::runtime_error("At least one adversary must be configured to be chosen as template for the automatically derived once.");
  }

  // TODO: Here we consider only one fault type and one fault probability
  const FaultProperties template_property = settings_.fault_adversaries[0][0];

  for (auto & prop : settings_.fault_adversaries) {
    prop.clear();
  }
  settings_.fault_adversaries.clear();

  for (const auto &attack : attacked_gates_set) {
      if(attack.attacked_gates_.size() <= max_size_combination){
      std::string signals = CreateRegexFromGateNamesAsString(attack.attacked_gates_);
      WriteFaultProperty(fault_properties, "StuckAt0",  0.125, true, true, signals, ".*");

      // NOTE:

      std::vector<FaultProperties> property(1,template_property);
      property[0].locations.included_elements = std::regex(signals);

      settings_.fault_adversaries.push_back(property);
    }
  }
  WriteJsonObjectToFile(root);


}
