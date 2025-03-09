/**
 * @file Probes.hpp
 * @brief Declaration of the Probe class.
 *
 * @version 0.0.1
 * @date 2025-02-24
 *
 * @author Nicolai Müller
 */
#pragma once

#include <algorithm>
#include <cassert>
#include <cinttypes>
#include <optional>
#include <vector>

class Probe {
 public:
  Probe(const std::vector<uint64_t>& signal_indices, uint64_t clock_cycle);

  uint64_t GetCycle() const;
  const std::vector<uint64_t>& GetSignalIndices() const;

  bool operator<(const Probe& other) const;
  bool operator==(const Probe& other) const;
  bool operator!=(const Probe& other) const;

 private:
  std::vector<uint64_t> signal_indices_;  ///< A single probe can record a field
                                          ///< element of multiple signals.
  uint64_t clock_cycle_;  ///< The clock cycle during which the probe records.
};

std::optional<uint64_t> SearchProbe(const Probe& probe,
                                    const std::vector<Probe>& probes);

class UniqueProbe : public Probe {
 public:
  UniqueProbe(const std::vector<uint64_t>& signal_indices, uint64_t clock_cycle,
              const std::vector<uint64_t>& probing_set_indices);

  const std::vector<uint64_t>& GetProbingSetIndices() const;

 private:
  std::vector<uint64_t> probing_set_indices_;  ///< The indices of the probing
                                               ///< sets that contain the probe.
};

using RobustProbe = uint64_t;

struct RelaxedProbe {
  uint64_t enable_index_;
  uint64_t number_of_enable_indices_;
  uint64_t number_of_signal_indices_;
  std::vector<uint64_t> signal_indices_;
  std::vector<uint64_t> propagation_indices_;
};
