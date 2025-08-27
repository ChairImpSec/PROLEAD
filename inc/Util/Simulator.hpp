/**
 * @file Simulator.hpp
 * @brief Declaration of the Simulator class.
 *
 * @version 0.0.1
 * @date 2025-25-08
 *
 * @author Nicolai Müller
 */
#pragma once

#include <vector>
#include <cstdint>

class Simulator {
 public:
  Simulator(const std::vector<uint64_t>& input_share_indices,
            const std::vector<uint64_t>& output_share_indices);

  /**
  * @brief Returns the number of tables the simulator uses.
  * @return The number of tables the simulator uses.
  */          
  uint64_t GetNumberOfTables() const;

  /**
   * @brief Returns the group index if only certain input shares 
   * are avaiable for simulation.
   * @param grp_idx The group index depending on all input variables.
   * @return The group index dependending on input variables of the simulator.
   */
  uint64_t GetGrpIdx(uint64_t grp_idx) const;

  /**
   * @brief Returns the key of an entry for O-PINI.
   * @param key The original key with all shared outputs enabled.
    * @param key_size_in_bytes The size of the key in bytes.
   * @return The compressed key with only some shared outputs enabled.
   */
  std::vector<uint8_t> GetKeyIdx(const uint8_t* key, uint64_t key_size_in_bytes) const;

  private:
  /**
   * The index set of input shares which are used to simulate the observation.
   * The indices refer to the n-th bit of the group index, i.e. the n-th bit of
   * the unshared input X or the shared input Sh(X).
   */
  std::vector<uint64_t> enabled_input_share_indices_;

  /**
   * The index set of output shares which which are not part of the
   * observation. To evaluate O-PINI, all output shares with index in the
   * set of input shares must be part of the observation.
   */
  std::vector<uint64_t> disabled_output_share_indices_;
};