/**
 * @file FaultSet.hpp
 * @brief Declaration of the Fault class.
 *
 * @version 0.0.1
 * @date 2024-07-31
 *
 * @author Aykan Yüce
 * @author Felix Uhle
 */

#pragma once

#include <cstdint>
#include <vector>

#include "Hardware/Target.hpp"

class FaultSet {
 public:
  /**
   * @brief Constructor of a FaultSet.
   *
   * @param faults Vector of pointer of faults which are part of this FaultSet.
   */
  FaultSet(std::vector<Fault const *> &faults);

  FaultSet() = default;

  /**
   * @brief Accessor of the cardinality of the FaultSet.
   *
   * @return The number of Faults in the FaultSet.
   */
  uint64_t GetNumberOfFaultsInSet() const;

  /**
   * @brief Accessor of the number of simulations for which the FaultSet was
   * effective.
   *
   * @return Returns the number of simulations for which the FaultSet was
   * effective.
   */
  uint64_t GetNumberOfEffectiveSimulations() const;

  /**
   * @brief Accessor function for a Fault of this FaultSet.
   *
   * @param index The index of the Fault, which is accessed.
   * @return Returns the Fault which is accessed.
   */
  Fault const *GetFault(uint64_t index) const;

  /**
   * @brief Increments the number of simulations for which the FaultSet was
   * effective by one.
   */
  void FaultSetWasEffective();

  /**
   * @brief Increments the number of simulations for which the FaultSet was
   * effective.
   *
   * @param number The number by which the counter of effective simulations
   * should be increased.
   */
  void FaultSetWasEffective(uint64_t number);

  void TryToInduceFaults(uint64_t &value, const SignalStruct* signal, uint64_t cycle);

 private:
  const std::vector<Fault const *> faults_;
  uint64_t number_of_effective_simulations_{0};

  // FIXME: Add a variable input_causing_effective_faults,
  // which stores which input causes a faultset to be active.
  // Either global input or input to faulted gates,
};
