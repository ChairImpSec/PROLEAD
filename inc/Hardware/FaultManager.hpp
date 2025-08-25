/**
 * @file FaultManager.hpp
 * @brief Declaration of the FaultManager class.
 *
 * @version 0.0.1
 * @date 2024-08-02
 *
 * @author Felix Uhle
 */

#pragma once

#include "Hardware/FaultSet.hpp"
#include "Util/Settings.hpp"
#include <memory>
#include <vector>

/**
 * @class FaultManager
 * @brief Manages all Faults and the FaultSets which the adversary is allowed to
 * chose.
 *
 */
class FaultManager {
public:
  /**
   * @brief Constructor of a FaultManager object.
   *
   * @param fault_injection_settings A pointer to the settings which should be
   * used to instatntiat a object of the FaultManager class.
   * @param circuit_to_be_faulted A pointer to the circuit which should be
   * faulted by this FaultManager.
   */
  // FaultManager(const FaultInjectionSettings *const fault_injection_settings,
  //              const CircuitStruct *const circuit_to_be_faulted);
  FaultManager(const FaultInjectionSettings &fault_injection_settings,
               const CircuitStruct &circuit_to_be_faulted);
  /**
   * @brief Add a new FaultSet to the manager.
   *
   * @param faults A vector of pointer to the faults which should be added to a
   * set.
   */
  // TODO: We might remove this, I think it is not required if we gnerate all
  // faults with the manager.
  void AddFaultSet(std::vector<Fault const *> &faults);

  bool RedundantFaultLocation() const;
  /**
   * @brief This function porcesses the corresponding fault_injection_settings_
   * and wraps ComputeAllFaults to compute all possible faults based on
   * fault_injection_settings_->fault_properties.
   *
   * @param clock_signal_index This parameter is to be removed, currently it is
   * required to give the this function the name of the clock signal, since we
   * assume that this is not faulted.
   */
  void SelectStrategyAndComputeAllFaults(uint64_t clock_signal_index, uint64_t idx_adversary);



  /**
   * @brief Get the list of all faults.
   *
   * @return A constant reference to the vector of faults.
   */
  const std::vector<std::unique_ptr<Fault>> &GetFaults();

  /**
   * @brief Get the list of all Fault Sets (Fault Combination).
   *
   * @return A constant reference to the vector of Fault Sets.
   */
  const std::vector<std::unique_ptr<FaultSet>> &GetFaultSets() const;

  // TODO: documentation
  const Fault *GetFault(uint64_t index) const;

  const std::map<uint64_t, std::vector<Fault const *>>& GetCycleToFaultMap() const;

  const std::vector<Fault const *>& GetFaultInCycle(uint64_t clock_cycle) const;


  /**
   * @brief Get the number of individual faults.
   *
   * @return The number of faults.
   */
  uint64_t GetNumberOfFaults() const;

  /**
   * @brief Get the number of individual faults per clock cycle.
   *
   * @return The number of faults.
   */
  uint64_t GetNumberOfFaultsPerClockCycle() const;

  /**
   * @brief Get the list of StuckAtZero faults.
   *
   * @return A constant reference to the vector of StuckAtZero faults.
   */
  const std::vector<StuckAtZeroFault const *> &GetStuckAtZeroFaults() const;

  /**
   * @brief Get the list of StuckAtOne faults.
   *
   * @return A constant reference to the vector of StuckAtOne faults.
   */
  const std::vector<StuckAtOneFault const *> &GetStuckAtOneFaults() const;

  /**
   * @brief Get the list of Toggle faults.
   *
   * @return A constant reference to the vector of Toggle faults.
   */
  const std::vector<ToggleFault const *> &GetToggleFaults() const;


  double GetMaxProbability() const;
  double GetMinProbability() const;

  /**
   * @brief Add a new StuckAtZero fault to the manager.
   *
   * @param signal A pointer to the signal, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddStuckAtZeroFault(const SignalStruct& signal, uint64_t clock_cycle, double fault_probability);

  /**
   * @brief Add a new StuckAtOne fault to the manager.
   *
   * @param signal A pointer to the signal, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddStuckAtOneFault(const SignalStruct& signal, uint64_t clock_cycle, double fault_probability);

  /**
   * @brief Add a new Toggle fault to the manager.
   *
   * @param signal A pointer to the signal, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddToggleFault(const SignalStruct& signal, uint64_t clock_cycle, double fault_probability);


  FaultSet SampleRandomFault(std::mt19937 &gen);
  void SampleRandomFaultVector(std::mt19937 &gen, std::vector<FaultSet> &fault_sets);

private:

  /**
   * @brief Selets the function object which corresponds to the FaultType
   * defined by the input.
   *
   * @param fault_property Contains the settings which corresponds to injected
   * FaultType.
   */
  const std::function<void(const SignalStruct&, uint64_t)>
  ChoseAddFaultFunction(const FaultProperties &fault_property);

  /**
   * @brief Returns a function object which is used to include and excluded
   * signals from beeing faulted in the correct order.
   *
   * @param first_include Boolean value, defining if the first step is an
   * include (true) or exclude (false).
   */
  const std::function<bool(const std::string &, const std::regex &,
                           const std::regex &)>
  DetermineIncludeStrategy(bool first_include);

  /**
   * @brief This function computes all possible faults for the given inputs.
   *
   * @param AddFaultFunction A function object which determins the type of the
   * faults which are added.
   * @param IncludeStrategy A function objecet used to determin if faults are
   * first excluded or first included. If first excluded the default case is
   * that all possible locations are faulted, while for first include no faults
   * are added if no concret poision is specified.
   * @param elements The elements which should be faulted, either a pointer to
   * the array of all registers or a pointer to an array of all logic gates.
   * @param number_of_elements Number of elements in the elements array,
   * required since plain c arrays are used.
   * @param clock_signal_index The index of the clock signal, which must not be
   * faulted.
   * @param include_element A regex identifing all elemnts, which should be
   * added.
   * @param exclude_elements A regex identifing all elements, which should not
   * be added.
   */
  uint64_t ComputeAllFaults(
      const std::function<void(const SignalStruct&, uint64_t)> AddFaultFunction,
      const std::function<bool(const std::string &, const std::regex &, const std::regex &)> IncludeStrategy,
      const std::vector<uint64_t>& elements, const uint64_t number_of_elements,
      const uint64_t clock_signal_index, const std::regex &include_element,
      const std::regex &exclude_elements);

  /**
   * @brief The configuration used to setup a instance of the FaultManager
   * class.
   */
  const FaultInjectionSettings &fault_injection_settings_;
  // const FaultInjectionSettings *const fault_injection_settings_;

  /**
   * @brief A pointer to the CircuitStruct to which the faults are applied.
   */
  // const CircuitStruct *const circuit_to_be_faulted_;
  const CircuitStruct &circuit_to_be_faulted_;

  /**
   * @brief List of all faults managed by an instatntiation of the FaultManager
   * class.
   */
  std::vector<std::unique_ptr<Fault>> faults_;

  /**
   * @brief Pointer to all StuckAtZeroFaults.
   */
  std::vector<StuckAtZeroFault const *> stuck_at_zero_faults_;

  /**
   * @brief Pointer to all StuckAtOneFaults.
   */
  std::vector<StuckAtOneFault const *> stuck_at_one_faults_;

  /**
   * @brief Pointer to all ToggleFaults.
   */
  std::vector<ToggleFault const *> toggle_faults_;

  /**
   * @brief Map between clock cycle and all faults of a cycle
   */
  std::map<uint64_t, std::vector<Fault const *>> faults_at_cycle_;


  uint64_t size_of_fault_sets_;
  std::vector<std::unique_ptr<FaultSet>> fault_sets_;

  std::vector<bool> combination_generation_state_;

  uint64_t max_order_of_fault_set_to_be_evaluated;

  double probability_of_non_evaluated_fault_sets_;

  double probability_of_no_fault_to_occur_;

  double min_fault_probability_{1};
  double max_fault_probability_{0};
};
