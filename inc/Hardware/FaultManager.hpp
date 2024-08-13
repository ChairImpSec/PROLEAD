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
#include "Hardware/Fault.hpp"
#include "Hardware/StuckAtOneFault.hpp"
#include "Hardware/StuckAtZeroFault.hpp"
#include "Hardware/ToggleFault.hpp"
#include <memory>
#include <vector>

class FaultManager {
public:
  /**
   * @brief Add a new StuckAtZero fault to the manager.
   *
   * @param signal_index The index of the signal/the position, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddStuckAtZeroFault(uint64_t signal_index, uint64_t clock_cycle,
                           double fault_probability);

  /**
   * @brief Add a new StuckAtOne fault to the manager.
   *
   * @param signal_index The index of the signal/the position, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddStuckAtOneFault(uint64_t signal_index, uint64_t clock_cycle,
                          double fault_probability);

  /**
   * @brief Add a new Toggle fault to the manager.
   *
   * @param signal_index The index of the signal/the position, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with which the fault is induced.
   */
  void AddToggleFault(uint64_t signal_index, uint64_t clock_cycle,
                      double fault_probability);

  /**
   * @brief Add a new FaultSet to the manager.
   *
   * @param faults A vector of pointer to the faults which should be added to a set.
   */
  // TODO: We might remove this, I think it is not required if we gnerate all faults with the
  // manager.
  void AddFaultSet(std::vector<Fault const *> &faults);

  // TODO: add a function to generate all FaultSets!
  void GenerateFaultSets();

  const Fault* GetFault(uint64_t index) const;

  /**
   * @brief Get the list of all faults.
   *
   * @return A constant reference to the vector of faults.
   */
  const std::vector<std::unique_ptr<const Fault>> &GetFaults() const;
  
  uint64_t GetNumberOfFaults() const;

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

  /**
   * @brief Get the list of all Fault Sets (Fault Combination).
   *
   * @return A constant reference to the vector of Fault Sets.
   */
  // TODO: We should disscuss whether a multidimensional vector makes more sense,
  // where we have a vector for each stage.
  // This would allow to simulate the circuit up to a stage where a fault is injected only once.
  const std::vector<FaultSet const *> &GetFaultSets() const;

private:
  std::vector<std::unique_ptr<const Fault>> faults_;
  std::vector<StuckAtZeroFault const *> stuck_at_zero_faults_;
  std::vector<StuckAtOneFault const *> stuck_at_one_faults_;
  std::vector<ToggleFault const *> toggle_faults_;
  // TODO: Should we place this here?
  // I am actually not sure if this makes sense
  std::vector<FaultSet const *> fault_sets_;
};
