#include "Util/Util.hpp"

template <>
void SortAndMergeDuplicates(TableBucketVector& observations,
                            uint64_t size_of_key_in_bytes,
                            uint64_t number_of_groups) {
  std::sort(
      observations.begin(), observations.end(),
      [size_of_key_in_bytes](const TableEntry& lhs, const TableEntry& rhs) {
        return std::memcmp(lhs.key_.get(), rhs.key_.get(),
                           size_of_key_in_bytes) < 0;
      });

  auto it = std::unique(
      observations.begin(), observations.end(),
      [size_of_key_in_bytes, number_of_groups](TableEntry& lhs,
                                               TableEntry& rhs) {
        if (std::memcmp(lhs.key_.get(), rhs.key_.get(), size_of_key_in_bytes) ==
            0) {
          for (uint64_t index = 0; index < number_of_groups; ++index) {
            lhs.data_[index] += rhs.data_[index];
          }
          return true;
        }
        return false;
      });

  observations.erase(it, observations.end());
}

template <>
void UpdateBucketWithBucket(TableBucketVector& bucket,
                            TableBucketVector& observations,
                            uint64_t size_of_key_in_bytes,
                            uint64_t number_of_groups) {
  uint64_t index;
  int64_t comparison;
  TableBucketVector::iterator bucket_it = bucket.begin();
  TableBucketVector::iterator observations_it = observations.begin();
  TableBucketVector::iterator remaining_it = observations.begin();

  while (bucket_it != bucket.end() && observations_it != observations.end()) {
    comparison = std::memcmp(bucket_it->key_.get(), observations_it->key_.get(),
                             size_of_key_in_bytes);
    if (comparison < 0) {
      ++bucket_it;
    } else if (comparison > 0) {
      *remaining_it++ = std::move(*observations_it++);
    } else {
      for (index = 0; index < number_of_groups; ++index) {
        bucket_it->data_[index] += observations_it->data_[index];
      }

      ++bucket_it;
      ++observations_it;
    }
  }

  remaining_it = std::move(observations_it, observations.end(), remaining_it);
  observations.resize(remaining_it - observations.begin());
}

bool IsSampleSizeSufficient(uint64_t number_of_samples,
                            uint64_t number_of_groups,
                            uint64_t number_of_entries, double_t beta_threshold,
                            double_t effect_size) {
  uint64_t degrees_of_freedom =
      (number_of_groups - 1) * (number_of_entries - 1);

  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double_t critical_value = boost::math::quantile(
        boost::math::complement(distribution, beta_threshold));
    double_t non_centrality_parameter =
        number_of_samples * effect_size * effect_size;
    boost::math::non_central_chi_squared_distribution<> dist(
        degrees_of_freedom, non_centrality_parameter);
    return boost::math::cdf(dist, critical_value) <= beta_threshold;
  } else {
    return false;
  }
}

uint64_t ComputeRequiredSampleSize(uint64_t number_of_groups,
                                   uint64_t number_of_entries,
                                   double_t beta_threshold,
                                   double_t effect_size) {
  uint64_t degrees_of_freedom =
      (number_of_groups - 1) * (number_of_entries - 1);

  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double_t critical_value = boost::math::quantile(
        boost::math::complement(distribution, beta_threshold));

    auto finder = [&](double_t ncp) {
      boost::math::non_central_chi_squared_distribution<> dist(
          degrees_of_freedom, ncp);
      return boost::math::cdf(dist, critical_value) - beta_threshold;
    };

    boost::uintmax_t number_of_iterations = 50;
    boost::math::tools::eps_tolerance<double_t> tolerance(30);
    std::pair<double_t, double_t> bound =
        boost::math::tools::bracket_and_solve_root(
            finder, 10.0, 2.0, false, tolerance, number_of_iterations);
    return std::ceil(bound.first / (effect_size * effect_size));
  } else {
    return 0;
  }
}

template <>
void ContingencyTable<TableBucketVector>::Initialize(uint64_t number_of_probes,
                                                     uint64_t number_of_groups,
                                                     bool is_in_compact_mode) {
  log_10_p_value_ = 0.0;
  if (is_in_compact_mode) {
    if (number_of_probes) {
      bucket_.resize(number_of_probes + 1);
      uint64_t number_of_bits =
          static_cast<uint64_t>(std::log2(number_of_probes)) + 1;
      size_of_key_in_bytes_ = number_of_bits >> 3;

      if (number_of_bits & 0b111) {
        ++size_of_key_in_bytes_;
      }

      for (TableEntry& entry : bucket_) {
        entry.data_ = std::make_unique<uint32_t[]>(number_of_groups);
      }
    } else {
      size_of_key_in_bytes_ = 0;
    }
  } else {
    size_of_key_in_bytes_ = number_of_probes >> 3;

    if (number_of_probes & 0b111) {
      ++size_of_key_in_bytes_;
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
  return size_of_key_in_bytes_;
}

template <>
uint64_t ContingencyTable<TableBucketVector>::GetNumberOfEntries() const {
  return bucket_.size();
}

template <>
double_t ContingencyTable<TableBucketVector>::GetLog10pValue() const {
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
                         return std::memcmp(lhs.key_.get(), rhs.key_.get(),
                                            size_of_key_in_bytes_) < 0;
                       });

  if (it != bucket_.end() && std::memcmp(it->key_.get(), observation.key_.get(),
                                         size_of_key_in_bytes_) == 0) {
    for (uint64_t index = 0; index < number_of_groups; ++index) {
      it->data_[index] += observation.data_[index];
    }
  } else {
    bucket_.insert(it, std::move(observation));
  }
}

template <>
void ContingencyTable<TableBucketVector>::UpdateBucket(
    TableBucketVector& observations, uint64_t number_of_groups) {
  uint64_t number_of_entries = bucket_.size();
  SortAndMergeDuplicates(observations, size_of_key_in_bytes_, number_of_groups);
  UpdateBucketWithBucket<TableBucketVector>(
      bucket_, observations, size_of_key_in_bytes_, number_of_groups);
  bucket_.reserve(number_of_entries + observations.size());
  std::move(observations.begin(), observations.end(),
            std::back_inserter(bucket_));
  SortBucket(number_of_entries);
}

template <class BucketContainer>
void ContingencyTable<BucketContainer>::SortBucket(uint64_t number_of_entries) {
  std::inplace_merge(bucket_.begin(), bucket_.begin() + number_of_entries,
                     bucket_.end(),
                     [this](const TableEntry& lhs, const TableEntry& rhs) {
                       return std::memcmp(lhs.key_.get(), rhs.key_.get(),
                                          size_of_key_in_bytes_) < 0;
                     });
}

template <>
uint64_t ContingencyTable<TableBucketVector>::SumUpCounters(
    uint32_t* counters, uint64_t number_of_groups) const {
  uint64_t sum = 0;
  for (uint64_t index = 0; index < number_of_groups; ++index) {
    sum += counters[index];
  }

  return sum;
}

template <>
void ContingencyTable<TableBucketVector>::SetExpectedFrequenciesOfAnEntry(
    const std::vector<double_t>& group_simulation_ratio,
    uint64_t number_of_simulations_per_entry,
    std::vector<double_t>& expected_frequencies) const {
  for (uint64_t index = 0; index < expected_frequencies.size(); ++index) {
    expected_frequencies[index] =
        group_simulation_ratio[index] * number_of_simulations_per_entry;
  }
}

template <>
bool ContingencyTable<TableBucketVector>::
    AreExpectedFrequenciesHighEnoughForEvaluation(
        const std::vector<double_t>& expected_frequencies,
        double_t pooling_factor) const {
  for (double_t frequency : expected_frequencies) {
    if ((frequency < 5.0) ||
        ((frequency < 5.0 * pooling_factor) && frequency < 20.0)) {
      return false;
    }
  }

  return true;
}

template <>
void ContingencyTable<TableBucketVector>::UpdateGTestStatistic(
    uint32_t* counters, const std::vector<double_t>& expected_frequencies,
    double_t& g_test_statistic) const {
  double_t portion = 0.0, product = 0.0;

  for (uint64_t index = 0; index < expected_frequencies.size(); ++index) {
    if (counters[index]) {
      portion = counters[index] / expected_frequencies[index];
      product = counters[index] * std::log(portion);
      g_test_statistic += product;
    }
  }
}

template <>
double_t ContingencyTable<TableBucketVector>::SetGTestStatistic(
    uint64_t number_of_groups, uint64_t number_of_simulations,
    std::vector<double_t>& group_simulation_ratio,
    uint64_t& degrees_of_freedom) const {
  uint32_t* counters;
  uint32_t* counters_of_pooled_entry = new uint32_t[number_of_groups]();
  uint64_t index, group_index;
  uint64_t number_of_entries = bucket_.size();
  uint64_t number_entries_in_pooled_table = 0;
  uint64_t number_of_simulations_per_entry;
  double_t g_test_statistic = 0.0;
  double_t pooling_factor = (double_t)number_of_simulations / number_of_entries;
  std::vector<double_t> expected_frequencies(number_of_groups, 0.0);

  for (index = 0; index < number_of_entries; ++index) {
    counters = bucket_[index].data_.get();
    number_of_simulations_per_entry = SumUpCounters(counters, number_of_groups);
    SetExpectedFrequenciesOfAnEntry(group_simulation_ratio,
                                    number_of_simulations_per_entry,
                                    expected_frequencies);

    if (AreExpectedFrequenciesHighEnoughForEvaluation(expected_frequencies,
                                                      pooling_factor)) {
      UpdateGTestStatistic(counters, expected_frequencies, g_test_statistic);
      ++number_entries_in_pooled_table;
    } else {
      for (group_index = 0; group_index < number_of_groups; ++group_index) {
        counters_of_pooled_entry[group_index] += counters[group_index];
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
double_t ContingencyTable<TableBucketVector>::ComputeLog10pValue(
    double_t g_test_statistic, uint64_t degrees_of_freedom) const {
  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double_t p_value = boost::math::cdf(
        boost::math::complement(distribution, g_test_statistic));
    return -std::log10(p_value);
  } else {
    return 0.0;
  }
}

template <>
void ContingencyTable<TableBucketVector>::SetLog10pValue(
    uint64_t number_of_groups) {
  uint64_t number_of_entries = bucket_.size();
  uint64_t number_of_simulations;
  uint64_t degrees_of_freedom;
  uint64_t index;

  std::vector<uint64_t> number_of_simulations_per_group(number_of_groups, 0);
  std::vector<double_t> group_simulation_ratio(number_of_groups, 0.0);

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
                   return static_cast<double_t>(x) /
                          static_cast<double_t>(number_of_simulations);
                 });

  if (number_of_entries != 1) {
    double_t g_test_statistic =
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
    std::vector<double_t>& group_simulation_ratio) {
  uint64_t degrees_of_freedom;
  uint64_t number_of_entries = bucket_.size();

  if (number_of_entries != 1) {
    double_t g_test_statistic =
        SetGTestStatistic(number_of_groups, number_of_simulations,
                          group_simulation_ratio, degrees_of_freedom);
    log_10_p_value_ = ComputeLog10pValue(g_test_statistic, degrees_of_freedom);
  } else {
    log_10_p_value_ = 0.0;
  }
}

void StartClock(timespec& start) { clock_gettime(CLOCK_REALTIME, &start); }

double_t EndClock(timespec& start) {
  struct timespec end;
  clock_gettime(CLOCK_REALTIME, &end);
  int64_t time_in_seconds = end.tv_sec - start.tv_sec;
  int64_t time_in_nanoseconds = end.tv_nsec - start.tv_nsec;
  double_t elapsed_time_period = time_in_seconds + time_in_nanoseconds * 1e-9;
  return elapsed_time_period;
}

void GenerateThreadRng(std::vector<boost::mt19937>& thread_rng,
                       uint64_t number_of_threads) {
  uint64_t seed;

  for (uint64_t index = 0; index < number_of_threads; ++index) {
    seed = rand();
    boost::mt19937 rng(seed);
    thread_rng[index] = rng;
  }
}

void ExtractCombinationFromBitmask(std::vector<uint64_t>& combination,
                                   std::vector<bool>& bitmask) {
  uint64_t combination_index = 0, index = 0;

  while (combination_index != combination.size()) {
    if (bitmask[index]) {
      combination[combination_index] = index;
      ++combination_index;
    }

    ++index;
  }
}

uint64_t Util::PrintMemoryConsumption() {
  std::ifstream status("/proc/self/status");
  std::string line, number;
  uint64_t ram = 0;

  if (status.is_open()) {
    while (getline(status, line)) {
      if (line.find("VmSize") != std::string::npos) {
        number = line.substr(7, line.length());
        ram = std::stoll(number.substr(0, number.length() - 2));
        break;
      }
    }
    status.close();
  } else {
    throw std::logic_error("Status file not found!");
  }

  return ram;
}

void Util::PrintHorizontalLine(unsigned int width) {
  std::cout.width(width);
  std::cout.fill('-');
  std::cout << '-' << std::endl;
  std::cout.fill(' ');
}

void Util::PrintRow(std::vector<unsigned int>& width,
                    std::vector<std::string>& elements) {
  std::cout << '|';

  for (uint64_t index = 0; index < elements.size(); ++index) {
    std::cout.width(width[index]);
    std::cout << (elements[index] + " |");
  }

  std::cout << std::endl;
}

void Util::GenerateThreadRng(std::vector<boost::mt19937>& thread_rng,
                             unsigned int number_of_threads) {
  unsigned int seed;

  for (unsigned int thread_index = 0; thread_index < number_of_threads;
       ++thread_index) {
    seed = rand();
    boost::mt19937 rng(seed);
    thread_rng[thread_index] = rng;
  }
}

void Util::ExtractCombinationFromBitmask(std::vector<unsigned int>& combination,
                                         std::vector<bool>& bitmask) {
  unsigned int combination_index = 0, index = 0;

  while (combination_index != combination.size()) {
    if (bitmask.at(index)) {
      combination.at(combination_index) = index;
      ++combination_index;
    }

    ++index;
  }
}
