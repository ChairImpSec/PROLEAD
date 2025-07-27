#pragma once

#include <map>
#include <string>
#include <vector>
#include "Blacklist.hpp"
#include "BlacklistSkyBuffer.hpp"
#include "BlacklistSkyClkBuffer.hpp"
#include "BlacklistSkyCombinatorial.hpp"
#include "BlacklistSkyPhysical.hpp"
#include "BlacklistSkySequential.hpp"
#include "BoundingBox.hpp"
#include "GDSProbe.hpp"
#include "Gate.hpp"
#include "Util/Settings.hpp"
#include "utils/gdstk/gdstk_utils.hpp"
#include "AttackedSurface.hpp"

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

using Gates = std::vector<Gate>;
class GDSScanner {
public:
  GDSScanner(const std::string& path, const std::string& top_level_name,
              const std::vector<std::string>& ignore_gate_types,
              FaultInjectionSettings & settings,
              const Coordinate& init_center_probe,
              size_t max_size_combination);

  // void scan();

private:
  std::string path;
  std::string top_level_name;
  std::vector<std::string> ignore_gate_types;
  Blacklist blacklist;
  FaultInjectionSettings & settings_;
  Coordinate init_center_probe;
  size_t max_size_combination;


  void WriteJsonObjectToFile(boost::property_tree::ptree root);
  void WriteFaultProperty(boost::property_tree::ptree &fault_properties_array,
                        const std::string &type,
                        double probability,
                        bool fault_logic_gates,
                        bool fault_storage_gates,
                        const std::string &include_signals,
                        const std::string &exclude_signals);

  std::string CreateRegexFromGateNamesAsString(const std::vector<const Gate *>& gates);
  std::regex CreateRegexFromGateNames(const std::vector<const Gate *>& gates);

  std::map<size_t, size_t> GroupByHitCount(std::set<AttackedSurface> attacked_surfaces);

  std::set<AttackedSurface> ComputeAttackedGateSet(const Gates & gates,GDSProbe probe);

  void initializeBlacklist();
  void initializeProbe();
  void scan();


  GDSProbe probe;
  Gates gates;
  BoundingBox top_module_bb;
};

