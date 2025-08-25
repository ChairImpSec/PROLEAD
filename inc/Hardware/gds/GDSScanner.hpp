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
#include "Util/Logger.hpp"

#include <iostream>
#include <regex>
#include <format>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

using Gates = std::vector<Gate>;
class GDSScanner {
public:
  GDSScanner(const std::string& path, const std::string& top_level_name,
              const std::vector<std::string>& ignore_gate_types,
              FaultInjectionSettings & settings,
              const Coordinate& init_center_probe,
              size_t max_size_combination,
             Logger& logger);

  // void scan();

private:
  std::string path_;
  std::string top_level_name_;
  std::vector<std::string> ignore_gate_types_;
  Blacklist blacklist_;
  FaultInjectionSettings & settings_;
  Coordinate init_center_probe_;
  size_t max_size_combination_;


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
  void ConvertToFIESTAInput();

  void ComputeAndSetAttackedGateCombinations();
  void ComputeAndSetPositionsToHitMap();
  void ComputeAndSetAverageHitsPerLocation();

  void initializeBlacklist();
  void initializeProbe();

  void PrintDetailsOfAnalyis();
  void Report();




  GDSProbe probe_;
  Gates gates_;
  BoundingBox top_module_bb_;
  Logger& logger_;
  std::set<AttackedSurface> attacked_gate_combinations_;
  double average_hits_per_location_;
  std::map<size_t, size_t> postions_to_hits_map_;
};

