#include "Util/Simulator.hpp"

uint64_t Simulator::GetNumberOfTables() const {
  return 1 << enabled_input_share_indices_.size();
}

Simulator::Simulator(const std::vector<uint64_t>& input_share_indices,
                     const std::vector<uint64_t>& output_share_indices)
    : enabled_input_share_indices_(input_share_indices),
      disabled_output_share_indices_(output_share_indices) {}

uint64_t Simulator::GetGrpIdx(uint64_t grp_idx) const {
  uint64_t result = 0;

  for (uint64_t idx : enabled_input_share_indices_) {
    result <<= 1;
    result |= (grp_idx >> idx) & 1;
  }

  return result;
}

std::vector<uint8_t> Simulator::GetKeyIdx(const uint8_t* key, uint64_t key_size_in_bytes) const {
  std::vector<uint8_t> result(key, key + key_size_in_bytes);

  for (uint64_t idx : disabled_output_share_indices_) {
    result[idx >> 3] &= ~(1 << (idx & 0b111));
  }

  return result;
}      