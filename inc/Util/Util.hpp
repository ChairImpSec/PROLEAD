/**
 * @file Util.hpp
 * @author Felix Uhle
 * @author Nicolai Müller
 */

#pragma once

#include <time.h>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>
#include <boost/math/tools/roots.hpp>
#include <cmath>
#include <chrono>
#include <ctime>
#include <fstream>
#include <iostream>
#include <memory>
#include <numeric>
#include <utility>
#include <vector>

#include "boost/generator_iterator.hpp"
#include "boost/random.hpp"
#include <sys/resource.h>

#include "Util/Simulator.hpp"

/**
 * @brief Represents an observation set made by a set of probes.
 *
 * The `Key` type is used to identify a particular observation in the
 * contingency table. To minimize memory overhead, dynamically allocated arrays
 * are used instead of vectors. Specifically, there is no need to store the size
 * of the array since the size is determined by the maximum number of
 * probe-extensions.
 */
using Key = std::unique_ptr<uint8_t[]>;

/**
 * @brief Stores a counter for each group, counting the occurrences of a
 * particular key.
 *
 * The `Data` type is used to maintain a count of the number of times a specific
 * key appears in each group. To minimize memory overhead, dynamically allocated
 * arrays are used instead of vectors. Specifically, there is no need to store
 * the size of the array since the size is determined by the number of groups.
 */
using Data = std::unique_ptr<uint32_t[]>;

/**
 * @brief Represents an entry in a contingency table, containing a key and
 * associated data.
 *
 * The `TableEntry` class is used to store an observation set (key) and its
 * corresponding counters (data) in a table. Each entry consists of a key that
 * identifies a particular observation and data that counts the occurrences of
 * that observation for each group.
 */
class TableEntry {
 public:
  Key key_;    ///< The key representing the observation set.
  Data data_;  ///< The data representing the counters for each group.
};

/**
 * @brief Stores the contingency table as a sorted list of TableEntry instances.
 *
 * The `TableBucketVector` type is used to maintain the contingency table as a
 * sorted list of `TableEntry` objects. A `std::vector` is chosen for its
 * relatively low memory overhead, ease of sorting, and ability to dynamically
 * extend.
 *
 * @details `TableBucketVector` is the currently implemented data type used for
 * the `BucketContainer` template. Users are encouraged to implement and
 * experiment with other data structures that might offer better performance or
 * characteristics.
 */
using TableBucketVector = std::vector<TableEntry>;

/**
 * @brief Sorts the elements in a bucket and merges duplicates.
 *
 * Sorts the entries in the `TableBucketVector` based on their keys and merges
 * duplicate entries by summing their counters. This ensures that each key in
 * the vector is unique, with the corresponding counter representing the total
 * count of occurrences.
 *
 * @param observations The bucket (vector) to sort and merge.
 * @param key_size_in_bytes The size of the keys in bytes, used for comparing
 * keys.
 * @param number_of_groups The number of groups, used to determine the length of
 * the `Data` array.
 */
template <typename BucketContainer>
void SortAndMergeDuplicates(BucketContainer& observations,
                            uint64_t key_size_in_bytes,
                            uint64_t number_of_groups);

/**
 * @brief Merges elements from `observations` into `bucket`, updating existing
 * entries and removing merged ones.
 *
 * @details Iterates through the `observations` and `bucket` vectors. If an
 * element in `observations` is already present in `bucket`, it updates the
 * corresponding element in `bucket` and removes the element from
 * `observations`. If the element is not present in `bucket`, it is retained in
 * `observations`.
 *
 * @param bucket The vector representing the bucket where data is merged.
 * @param observations The vector containing observations to merge into the
 * bucket. Elements that are merged will be removed.
 * @param key_size_in_bytes The size of the key in bytes used for comparison.
 * @param number_of_groups The number of groups of data associated with each
 * key.
 */
template <typename BucketContainer>
void UpdateBucketWithBucket(BucketContainer& bucket,
                            BucketContainer& observations,
                            uint64_t key_size_in_bytes,
                            uint64_t number_of_groups);

/**
 * @brief Computes the required sample size for a chi-squared test.
 *
 * This function calculates the sample size needed to achieve sufficient
 * statistical power in a chi-squared test based on specified parameters.
 *
 * @param number_of_groups The number of groups in the dataset.
 * @param number_of_entries The number of entries in the dataset.
 * @param beta_threshold The desired probability of a Type II error
 * (false-negative rate).
 * @param effect_size The desired effect size to detect.
 * @return The computed required sample size to achieve the desired statistical
 * power.
 */
uint64_t ComputeRequiredSampleSize(uint64_t number_of_groups,
                                   uint64_t number_of_entries,
                                   double beta_threshold,
                                   double effect_size);

template <typename BucketContainer>
class ContingencyTable {
 public:
  /**
   * @brief Default constructor for ContingencyTable.
   *
   * Initializes a ContingencyTable instance with all possible observations.
   * In compact mode, this constructor ensures that every possible observation
   * is accessible by index, reflecting the small number of possible
   * observations. This initialization is crucial for efficient access and
   * manipulation of observations within the table and allows a great
   * performance improvement compared to the normal mode.
   */
  ContingencyTable() = default;

  /**
   * @brief Initializes the ContingencyTable for a specific type of bucket
   * container.
   *
   * Sets up the ContingencyTable instance, adjusting the size of keys based on
   * the number of probes and whether the table is in compact mode.
   *
   * @param number_of_probes The number of probes used in observations.
   * @param number_of_groups The number of groups in the contingency table.
   * @param is_in_compact_mode Flag indicating if the table operates in compact
   * mode.
   */
  void Initialize(uint64_t number_of_probes, uint64_t number_of_groups, bool is_in_compact_mode);

  void Deconstruct();

  uint64_t GetSizeOfKeyInBytes() const;
  uint64_t GetNumberOfEntries() const;
  double GetLog10pValue() const;

  void IncrementSpecificCounter(uint64_t key_index, uint64_t group_index);

  /**
   * @brief Updates the bucket with a single observation.
   *
   * This function updates the existing entries in the bucket with data from the
   * provided observation. If the observation's key matches an existing key in
   * the bucket, the corresponding data is added to the existing entry. If no
   * match is found, the observation is inserted into the bucket in a sorted
   * order.
   *
   * @param observation The TableEntry containing the key and data to be updated
   * or inserted into the bucket.
   * @param number_of_groups The number of groups associated with each key,
   * used to iterate over the data arrays.
   *
   * @details The function uses a binary search to find the appropriate position
   * for the observation in the sorted bucket. If a match is found, the data
   * arrays of the existing entry and the observation are combined by adding
   * corresponding elements. If no match is found, the observation is inserted
   * into the correct position to maintain the bucket's sorted order.
   */
  void UpdateBucket(TableEntry& observation, uint64_t number_of_groups);

  /**
   * @brief Updates the bucket with multiple observations.
   *
   * This function updates the bucket with data from a vector of observations.
   * It sorts and merges duplicate entries in the observations vector, then
   * updates the bucket by merging the processed observations into it. The
   * function ensures that the bucket remains sorted.
   *
   * @param observations The vector of TableEntry objects containing the keys
   * and data to be updated or inserted into the bucket.
   * @param number_of_groups The number of groups associated with each key,
   * used to iterate over the data arrays.
   *
   * @details The function first sorts and merges duplicates in the observations
   * vector using `SortAndMergeDuplicates`. It then updates the bucket with the
   * processed observations using `UpdateBucketWithBucket`. After reserving
   * enough space for new entries, it moves the remaining observations into the
   * bucket and ensures that the bucket remains sorted by calling `SortBucket`.
   */
  void UpdateBucket(TableBucketVector& observations, uint64_t number_of_groups);

  /**
   * @brief Calculates and sets the log base 10 p-value for PROLEAD_SW.
   *
   * This function calculates the log base 10 p-value for the contingency table
   * based on the observed data. It first computes the number of simulations per
   * group and their ratios, then calculates the G-test statistic and uses it to
   * compute the log base 10 p-value.
   *
   * @param number_of_groups The number of groups in the contingency table.
   */
  void SetLog10pValue(uint64_t number_of_groups);

  /**
   * @brief Calculates and sets the log base 10 p-value for PROLEAD.
   *
   * This function calculates the log base 10 p-value for the contingency table
   * based on pre-determined numbers of simulations and group simulation ratios.
   * It calculates the G-test statistic and uses it to compute the log base 10
   * p-value.
   *
   * @param number_of_groups The number of groups in the contingency table.
   * @param number_of_simulations The total number of simulations.
   * @param group_simulation_ratio A vector containing the ratio of simulations
   * for each group.
   */
  void SetLog10pValue(uint64_t number_of_groups, uint64_t number_of_simulations,
                      std::vector<double>& group_simulation_ratio);

 //private:
  /**
   * @brief The size of the key in bytes.
   *
   * This variable stores the size of the key used in the contingency table,
   * measured in bytes. It is used to perform comparisons of the keys within the
   * table.
   */
  uint64_t key_size_in_bytes_;

  /**
   * @brief The logarithm base 10 of the p-value.
   *
   * This variable stores the log base 10 of the p-value calculated from the
   * contingency table. It is used to assess the statistical significance of the
   * observations in the table.
   */
  double log_10_p_value_;

  /**
   * @brief The container holding the table entries.
   *
   * This variable holds the entries of the contingency table. It uses a
   * container, typically a vector, to store `TableEntry` objects, which consist
   * of keys and associated data. The type of container is defined by the
   * `BucketContainer` template parameter.
   */
  BucketContainer bucket_;

  /**
   * @brief Sorts the bucket in the contingency table.
   *
   * This function sorts the `bucket_` container, which holds the table entries.
   * It uses an in-place merge algorithm to efficiently sort the elements.
   *
   * @param number_of_entries The number of entries in the bucket before the
   * merge.
   *
   * @details The function assumes that the first `number_of_entries` elements
   * in the `bucket_` are already sorted. It merges these sorted elements with
   * the remaining, but also sorted, elements in the bucket to produce a fully
   * sorted container.
   *
   * The sorting is based on the comparison of keys using `std::memcmp` to
   * ensure that the keys are compared correctly according to their byte size
   * defined by `key_size_in_bytes_`.
   */
  void SortBucket(uint64_t number_of_entries);

  /**
   * @brief Sums up the counters for one entry.
   * @param counters A pointer to the array of counters.
   * @param number_of_groups The number of groups for which the counters are
   * summed.
   * @return The total sum of the counters.
   */
  uint64_t SumUpCounters(uint32_t* counters, uint64_t number_of_groups) const;

  /**
   * @brief Calculates the expected frequencies for one entry of the contingency
   * table.
   *
   * @param group_simulation_ratio A vector containing the ratio of the number
   * of simulations per group to the total number of simulations.
   * @param number_of_simulations_per_entry The total number of simulations for
   * the table entry.
   * @param expected_frequencies A vector to be filled with the calculated
   * expected frequencies for each group.
   */
  void SetExpectedFrequenciesOfAnEntry(
      const std::vector<double>& group_simulation_ratio,
      uint64_t number_of_simulations_per_entry,
      std::vector<double>& expected_frequencies) const;

  /**
   * @brief Checks if an entry's expected frequency is high enough for direct
   * evaluation or if pooling is necessary.
   *
   * The G-test can overestimate statistical outliers, especially when the
   * contingency table is sparsely filled. For instance, a probing set with many
   * probes might simulate each key only once, leading to potential false
   * positives. To mitigate this issue, pooling combines sparsely-filled entries
   * based on a pooling factor, which dynamically adjusts according to the size
   * of the contingency table.
   *
   * @param expected_frequencies The precomputed expected frequencies of entries
   * in the contingency table.
   * @param pooling_factor The factor that determines the threshold for pooling.
   * Larger tables use a higher pooling factor to be more aggressive in pooling.
   * @return True if the expected frequency is high enough for direct
   * evaluation, false if pooling is recommended.
   *
   * @details This function evaluates whether the expected frequency of an entry
   * in the contingency table is sufficient for direct statistical evaluation or
   * if pooling should be considered. The decision is based on comparing the
   * entry's expected frequency with a threshold determined by the pooling
   * factor. If the expected frequency meets or exceeds the threshold, direct
   * evaluation is recommended. Otherwise, pooling is suggested to improve
   * statistical reliability, especially in sparsely-populated tables.
   */
  bool AreExpectedFrequenciesHighEnoughForEvaluation(
      const std::vector<double>& expected_frequencies,
      double pooling_factor) const;

  /**
   * @brief Updates the G-test statistic based on observed counters and expected
   * frequencies.
   * @param counters Array of observed counts for each group.
   * @param expected_frequencies Precomputed expected frequencies for each
   * group.
   * @param g_test_statistic Reference to the current G-test statistic, updated
   * by adding contributions from each non-zero counter.
   */
  void UpdateGTestStatistic(uint32_t* counters,
                            const std::vector<double>& expected_frequencies,
                            double& g_test_statistic) const;

  /**
   * @brief Computes the G-test statistic for the contingency table.
   * @param number_of_groups Number of groups in the contingency table.
   * @param number_of_simulations Total number of simulations performed.
   * @param group_simulation_ratio Ratio of simulations per group relative to
   * total simulations.
   * @param degrees_of_freedom Reference to store the degrees of freedom for the
   * G-test.
   * @return Computed G-test statistic for the contingency table.
   */
  double SetGTestStatistic(uint64_t number_of_groups, uint64_t number_of_simulations,
                             std::vector<double>& group_simulation_ratio,
                             uint64_t& degrees_of_freedom) const;
  double SetGTestStatistic(uint64_t number_of_groups, uint64_t number_of_simulations, 
    const Simulator& simulator, std::vector<double>& group_simulation_ratio, 
    uint64_t& degrees_of_freedom) const;

  /**
   * @brief Computes the negative log base 10 of the p-value for a given G-test
   * statistic.
   *
   * The function calculates the negative log base 10 of the p-value associated
   * with the G-test statistic. It utilizes the chi-squared distribution with
   * given degrees of freedom to determine the p-value, which is then
   * transformed into its negative logarithmic form.
   *
   * @param g_test_statistic The computed G-test statistic from observed and
   * expected frequencies.
   * @param degrees_of_freedom The degrees of freedom for the chi-squared
   * distribution, determining the shape of the distribution.
   * @return The negative log base 10 of the p-value corresponding to the
   * provided G-test statistic. Returns 0.0 if degrees of freedom are zero.
   */
  double ComputeLog10pValue(double g_test_statistic, uint64_t degrees_of_freedom) const;
};

void StartClock(timespec& start);
double EndClock(timespec& start);
std::string GetTimestamp();
void GenerateThreadRng(std::vector<boost::mt19937>& rng,
                       uint64_t number_of_threads);
uint64_t GetUsedMemory();

