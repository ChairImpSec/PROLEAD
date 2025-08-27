#include "Util/Util.hpp"

template <>
void SortAndMergeDuplicates(TableBucketVector& observations, 
  uint64_t key_size_in_bytes, uint64_t number_of_groups) {
  std::sort(observations.begin(), observations.end(),
    [key_size_in_bytes](const TableEntry& lhs, const TableEntry& rhs) {
      return std::memcmp(lhs.key_.get(), rhs.key_.get(), key_size_in_bytes) < 0;
    });

  auto it = std::unique(observations.begin(), observations.end(),
    [key_size_in_bytes, number_of_groups](TableEntry& lhs, TableEntry& rhs) {
      if (std::memcmp(lhs.key_.get(), rhs.key_.get(), key_size_in_bytes) == 0) {
        for (uint64_t idx = 0; idx < number_of_groups; ++idx) {
          lhs.data_[idx] += rhs.data_[idx];
        }
        return true;
      }
      return false;
    });

  observations.erase(it, observations.end());
}

template <>
void UpdateBucketWithBucket(TableBucketVector& bucket, TableBucketVector& observations,
  uint64_t key_size_in_bytes, uint64_t number_of_groups) {
  TableBucketVector::iterator bucket_it = bucket.begin();
  TableBucketVector::iterator obs_it = observations.begin();
  TableBucketVector::iterator remaining_it = observations.begin();

  while (bucket_it != bucket.end() && obs_it != observations.end()) {
    int64_t cmp = std::memcmp(bucket_it->key_.get(), obs_it->key_.get(), key_size_in_bytes);
    if (cmp < 0) {
      ++bucket_it;
    } else if (cmp > 0) {
      *remaining_it++ = std::move(*obs_it++);
    } else {
      for (uint64_t idx = 0; idx < number_of_groups; ++idx) {
        bucket_it->data_[idx] += obs_it->data_[idx];
      }

      ++bucket_it;
      ++obs_it;
    }
  }

  remaining_it = std::move(obs_it, observations.end(), remaining_it);
  observations.resize(remaining_it - observations.begin());
}

uint64_t ComputeRequiredSampleSize(uint64_t number_of_groups, uint64_t number_of_entries,
  double beta_threshold, double effect_size) {
  uint64_t degrees_of_freedom = (number_of_groups - 1) * (number_of_entries - 1);

  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double critical_value = boost::math::quantile(
        boost::math::complement(distribution, beta_threshold));

    auto finder = [&](double ncp) {
      boost::math::non_central_chi_squared_distribution<> dist(
          degrees_of_freedom, ncp);
      return boost::math::cdf(dist, critical_value) - beta_threshold;
    };

    boost::uintmax_t number_of_iterations = 50;
    boost::math::tools::eps_tolerance<double> tolerance(30);
    std::pair<double, double> bound =
        boost::math::tools::bracket_and_solve_root(
            finder, 10.0, 2.0, false, tolerance, number_of_iterations);
    return std::ceil(bound.first / (effect_size * effect_size));
  } else {
    return 0;
  }
}

template <>
void ContingencyTable<TableBucketVector>::Initialize(uint64_t number_of_probes,
  uint64_t number_of_groups, bool is_in_compact_mode) {

  log_10_p_value_ = 0.0;
  if (is_in_compact_mode) {
    if (number_of_probes) {
      bucket_.resize(number_of_probes + 1);
      uint64_t number_of_bits =
          static_cast<uint64_t>(std::log2(number_of_probes)) + 1;
      key_size_in_bytes_ = number_of_bits >> 3;

      if (number_of_bits & 0b111) {
        ++key_size_in_bytes_;
      }

      for (TableEntry& entry : bucket_) {
        entry.data_ = std::make_unique<uint32_t[]>(number_of_groups);
      }
    } else {
      key_size_in_bytes_ = 0;
    }
  } else {
    key_size_in_bytes_ = number_of_probes >> 3;

    if (number_of_probes & 0b111) {
      ++key_size_in_bytes_;
    }
  }
}

template <>
void ContingencyTable<TableBucketVector>::Deconstruct() {
  bucket_.shrink_to_fit();
  bucket_.clear();
  log_10_p_value_ = 0.0;
}

template <>
uint64_t ContingencyTable<TableBucketVector>::GetSizeOfKeyInBytes() const {
  return key_size_in_bytes_;
}

template <>
uint64_t ContingencyTable<TableBucketVector>::GetNumberOfEntries() const {
  return bucket_.size();
}

template <>
double ContingencyTable<TableBucketVector>::GetLog10pValue() const {
  return log_10_p_value_;
}

template <>
void ContingencyTable<TableBucketVector>::IncrementSpecificCounter(
    uint64_t key_index, uint64_t group_index) {
  ++bucket_[key_index].data_[group_index];
}

template <>
void ContingencyTable<TableBucketVector>::UpdateBucket(
    TableEntry& observation, uint64_t number_of_groups) {
  TableBucketVector::iterator it =
    std::lower_bound(bucket_.begin(), bucket_.end(), observation,
      [this](const TableEntry& lhs, const TableEntry& rhs) {
        return std::memcmp(lhs.key_.get(), rhs.key_.get(), key_size_in_bytes_) < 0;
      });

  if (it != bucket_.end() && 
    std::memcmp(it->key_.get(), observation.key_.get(), key_size_in_bytes_) == 0) {
    for (uint64_t index = 0; index < number_of_groups; ++index) {
      it->data_[index] += observation.data_[index];
    }
  } else {
    bucket_.insert(it, std::move(observation));
  }
}

template <>
void ContingencyTable<TableBucketVector>::SortBucket(uint64_t number_of_entries) {
  std::inplace_merge(bucket_.begin(), bucket_.begin() + number_of_entries, bucket_.end(),
    [this](const TableEntry& lhs, const TableEntry& rhs) {
      return std::memcmp(lhs.key_.get(), rhs.key_.get(), key_size_in_bytes_) < 0;
    });
}

template <>
void ContingencyTable<TableBucketVector>::UpdateBucket(
    TableBucketVector& observations, uint64_t number_of_groups) {
  uint64_t number_of_entries = bucket_.size();
  SortAndMergeDuplicates(observations, key_size_in_bytes_, number_of_groups);
  UpdateBucketWithBucket<TableBucketVector>(
      bucket_, observations, key_size_in_bytes_, number_of_groups);
  bucket_.reserve(number_of_entries + observations.size());
  std::move(observations.begin(), observations.end(),
            std::back_inserter(bucket_));
  SortBucket(number_of_entries);
}

template <>
uint64_t ContingencyTable<TableBucketVector>::SumUpCounters(
  uint32_t* counters, uint64_t number_of_groups) const {
  uint64_t sum = 0;
  for (uint64_t idx = 0; idx < number_of_groups; ++idx) {
    sum += counters[idx];
  }

  return sum;
}

template <>
void ContingencyTable<TableBucketVector>::SetExpectedFrequenciesOfAnEntry(
    const std::vector<double>& group_simulation_ratio,
    uint64_t number_of_simulations_per_entry,
    std::vector<double>& expected_frequencies) const {
  for (uint64_t idx = 0; idx < expected_frequencies.size(); ++idx) {
    expected_frequencies[idx] =
      group_simulation_ratio[idx] * number_of_simulations_per_entry;
  }
}

template <>
bool ContingencyTable<TableBucketVector>::AreExpectedFrequenciesHighEnoughForEvaluation(
  const std::vector<double>& expected_frequencies, double pooling_factor) const {
  for (double frequency : expected_frequencies) {
    if ((frequency < 5.0) || ((frequency < 5.0 * pooling_factor) && frequency < 20.0)) {
      return false;
    }
  }

  return true;
}

template <>
void ContingencyTable<TableBucketVector>::UpdateGTestStatistic(
  uint32_t* counters, const std::vector<double>& expected_frequencies,
    double& g_test_statistic) const {
  double portion = 0.0, product = 0.0;

  for (uint64_t idx = 0; idx < expected_frequencies.size(); ++idx) {
    if (counters[idx]) {
      portion = counters[idx] / expected_frequencies[idx];
      product = counters[idx] * std::log(portion);
      g_test_statistic += product;
    }
  }
}

template <>
double ContingencyTable<TableBucketVector>::SetGTestStatistic(
    uint64_t number_of_groups, uint64_t number_of_simulations,
    std::vector<double>& group_simulation_ratio,
    uint64_t& degrees_of_freedom) const {
  uint32_t* counters;
  uint32_t* counters_of_pooled_entry = new uint32_t[number_of_groups]();
  uint64_t number_of_entries = bucket_.size();
  uint64_t number_entries_in_pooled_table = 0;
  uint64_t number_of_simulations_per_entry;
  double g_test_statistic = 0.0;
  double pooling_factor = (double)number_of_simulations / number_of_entries;
  std::vector<double> expected_frequencies(number_of_groups, 0.0);

  for (uint64_t idx = 0; idx < number_of_entries; ++idx) {
    counters = bucket_[idx].data_.get();
    number_of_simulations_per_entry = SumUpCounters(counters, number_of_groups);
    SetExpectedFrequenciesOfAnEntry(group_simulation_ratio,
                                    number_of_simulations_per_entry,
                                    expected_frequencies);

    if (AreExpectedFrequenciesHighEnoughForEvaluation(expected_frequencies,
                                                      pooling_factor)) {
      UpdateGTestStatistic(counters, expected_frequencies, g_test_statistic);
      ++number_entries_in_pooled_table;
    } else {
      for (uint64_t grp_idx = 0; grp_idx < number_of_groups; ++grp_idx) {
        counters_of_pooled_entry[grp_idx] += counters[grp_idx];
      }
    }
  }

  number_of_simulations_per_entry =
      SumUpCounters(counters_of_pooled_entry, number_of_groups);

  if (number_of_simulations_per_entry) {
    SetExpectedFrequenciesOfAnEntry(group_simulation_ratio,
                                    number_of_simulations_per_entry,
                                    expected_frequencies);
    UpdateGTestStatistic(counters_of_pooled_entry, expected_frequencies,
                         g_test_statistic);
    ++number_entries_in_pooled_table;
  }

  g_test_statistic *= 2;

  if (number_entries_in_pooled_table) {
    degrees_of_freedom =
        (number_of_groups - 1) * (number_entries_in_pooled_table - 1);
  } else {
    degrees_of_freedom = 0;
  }

  if (g_test_statistic < 0.0) {
    g_test_statistic = 0.0;
  }

  delete[] counters_of_pooled_entry;
  return g_test_statistic;
}

template <>
double ContingencyTable<TableBucketVector>::ComputeLog10pValue(
    double g_test_statistic, uint64_t degrees_of_freedom) const {
  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double p_value = boost::math::cdf(
        boost::math::complement(distribution, g_test_statistic));
    return -std::log10(p_value);
  } else {
    return 0.0;
  }
}

template <>
double ContingencyTable<TableBucketVector>::SetGTestStatistic(
  uint64_t number_of_groups, uint64_t number_of_simulations, const Simulator& simulator, 
    std::vector<double>& group_simulation_ratio, uint64_t& degrees_of_freedom) const {
  uint64_t number_of_tables = simulator.GetNumberOfTables();
  uint64_t number_of_groups_per_table = number_of_groups / number_of_tables;

  std::vector<std::vector<uint64_t>> groups_per_table(number_of_tables);
  for (std::vector<uint64_t>& table : groups_per_table) {
    table.reserve(number_of_groups_per_table);
  }

  std::vector<double> number_of_sims_per_table(number_of_tables, 0.0);
  for (uint64_t grp_idx = 0; grp_idx < number_of_groups; ++grp_idx) {
    uint64_t idx = simulator.GetGrpIdx(grp_idx);
    groups_per_table[idx].push_back(grp_idx);
    number_of_sims_per_table[idx] += group_simulation_ratio[grp_idx];
  }

  TableBucketVector sim_bucket(bucket_.size());
  std::vector<uint8_t> sim_key(key_size_in_bytes_);
  for (uint64_t idx = 0; idx < bucket_.size(); ++idx) {
    sim_bucket[idx].key_ = std::make_unique_for_overwrite<uint8_t[]>(key_size_in_bytes_);
    sim_bucket[idx].data_ = std::make_unique_for_overwrite<uint32_t[]>(number_of_groups);
    sim_key = simulator.GetKeyIdx(bucket_[idx].key_.get(), key_size_in_bytes_);

    std::copy(sim_key.begin(), sim_key.end(), sim_bucket[idx].key_.get());
    std::copy(bucket_[idx].data_.get(), bucket_[idx].data_.get() 
      + number_of_groups, sim_bucket[idx].data_.get());
  }

  std::vector<double> g_test_statistic(number_of_tables, 0.0);
  std::vector<uint64_t> number_of_sims_per_entry(number_of_tables);
  std::vector<uint64_t> number_of_entries_per_table(number_of_tables, 0.0);
  std::vector<std::vector<double>> expected_frequencies(
      number_of_tables, std::vector<double>(number_of_groups_per_table, 0.0));

  for (const TableEntry& entry : sim_bucket) {
    std::fill(number_of_sims_per_entry.begin(), number_of_sims_per_entry.end(), 0);
    for (uint64_t idx = 0; idx < number_of_tables; ++idx) {
      for (uint64_t grp_idx : groups_per_table[idx]) {
        number_of_sims_per_entry[idx] += entry.data_[grp_idx];
      }
    }

    for (uint64_t idx = 0; idx < number_of_tables; ++idx) {
      bool non_empty_entry = false;
      for (uint64_t grp_idx = 0; grp_idx < number_of_groups_per_table; ++grp_idx) {
        uint64_t global_grp_idx = groups_per_table[idx][grp_idx];

        expected_frequencies[idx][grp_idx] = number_of_sims_per_entry[idx] * 
          (group_simulation_ratio[global_grp_idx] / number_of_sims_per_table[idx]);

        if (entry.data_[global_grp_idx]) {
          double portion = entry.data_[global_grp_idx] / expected_frequencies[idx][grp_idx];
          double product = entry.data_[global_grp_idx] * std::log(portion);
          g_test_statistic[idx] += product;
          non_empty_entry = true;
        }
      }

      if (non_empty_entry) {
        ++number_of_entries_per_table[idx];
      }
    }
  }

  SortAndMergeDuplicates(sim_bucket, key_size_in_bytes_, number_of_groups);

  double max_log_10_p_value = 0.0;
  double log_10_p_value = 0.0;

  for (uint64_t idx = 0; idx < number_of_tables; ++idx) {
    g_test_statistic[idx] *= 2;

    if (g_test_statistic[idx] < 0.0) {
      g_test_statistic[idx] = 0.0;
    }

    if (number_of_entries_per_table[idx]) {
      degrees_of_freedom = (number_of_groups_per_table - 1) *
                           (number_of_entries_per_table[idx] - 1);
    } else {
      degrees_of_freedom = 0;
    }

    log_10_p_value =
        ComputeLog10pValue(g_test_statistic[idx], degrees_of_freedom);

    if (log_10_p_value > max_log_10_p_value) {
      max_log_10_p_value = log_10_p_value;
    }
  }

  return max_log_10_p_value;
}

template <>
void ContingencyTable<TableBucketVector>::SetLog10pValue(uint64_t number_of_groups) {
  uint64_t number_of_entries = bucket_.size();
  uint64_t number_of_simulations;
  uint64_t degrees_of_freedom;
  uint64_t index;

  std::vector<uint64_t> number_of_simulations_per_group(number_of_groups, 0);
  std::vector<double> group_simulation_ratio(number_of_groups, 0.0);

  for (const TableEntry& entry : bucket_) {
    for (index = 0; index < number_of_groups; ++index) {
      number_of_simulations_per_group[index] += entry.data_[index];
    }
  }

  number_of_simulations =
      std::accumulate(number_of_simulations_per_group.begin(),
                      number_of_simulations_per_group.end(), 0);
  std::transform(number_of_simulations_per_group.begin(),
                 number_of_simulations_per_group.end(),
                 group_simulation_ratio.begin(),
                 [number_of_simulations](uint64_t x) {
                   return static_cast<double>(x) /
                          static_cast<double>(number_of_simulations);
                 });

  if (number_of_entries != 1) {
    double g_test_statistic =
        SetGTestStatistic(number_of_groups, number_of_simulations,
                          group_simulation_ratio, degrees_of_freedom);
    log_10_p_value_ = ComputeLog10pValue(g_test_statistic, degrees_of_freedom);
  } else {
    log_10_p_value_ = 0.0;
  }
}

template <>
void ContingencyTable<TableBucketVector>::SetLog10pValue(
    uint64_t number_of_groups, uint64_t number_of_simulations,
    std::vector<double>& group_simulation_ratio) {
  uint64_t degrees_of_freedom;
  uint64_t number_of_entries = bucket_.size();

  if (number_of_entries != 1) {
    double g_test_statistic =
        SetGTestStatistic(number_of_groups, number_of_simulations,
                          group_simulation_ratio, degrees_of_freedom);
    log_10_p_value_ = ComputeLog10pValue(g_test_statistic, degrees_of_freedom);
  } else {
    log_10_p_value_ = 0.0;
  }
}

void StartClock(timespec& start) { clock_gettime(CLOCK_REALTIME, &start); }

double EndClock(timespec& start) {
  struct timespec end;
  clock_gettime(CLOCK_REALTIME, &end);
  int64_t time_in_seconds = end.tv_sec - start.tv_sec;
  int64_t time_in_nanoseconds = end.tv_nsec - start.tv_nsec;
  double elapsed_time_period = time_in_seconds + time_in_nanoseconds * 1e-9;
  return elapsed_time_period;
}

std::string GetTimestamp() {
  auto now = std::chrono::system_clock::now();
  std::time_t timestamp = std::chrono::system_clock::to_time_t(now);
  std::string result = std::ctime(&timestamp);
  result.pop_back(); // Remove the newline character
  return result;
}

void GenerateThreadRng(std::vector<boost::mt19937>& thread_rng,
                       uint64_t number_of_threads) {
  uint64_t seed;

  for (uint64_t idx = 0; idx < number_of_threads; ++idx) {
    seed = rand();
    boost::mt19937 rng(seed);
    thread_rng[idx] = rng;
  }
}

uint64_t GetUsedMemory() {
  struct rusage ru { };
  if (getrusage(RUSAGE_SELF, &ru) != 0) return 0;
#if defined(__APPLE__)
  return ru.ru_maxrss / 1024;
#else
  return ru.ru_maxrss;
#endif
}