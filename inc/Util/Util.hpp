#pragma once

#include <cmath>
#include <memory>
#include <numeric>
#include <time.h>
#include <utility>
#include <vector>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>

namespace hardware{
/**
* The stats namespace encompasses everything which is related to the statistical evaluation performed by PROLEAD. 
* In particular, all functions required for updating and evaluating the contingency tables in the hardware version are stored here.
* For the future, we plan to use this statistic functions also for the software version of PROLEAD.
*/
namespace stats{
	/**
	* We define "key" as the multibit value recorded by a probing set. This key is used to identify a probed value in the contingency table.
	* Further, we define data as the counters which count the number of occurrences of a specific key for multiple groups.
	* We decided to use dynamic allocated arrays instead of vectors due to the smaller overhead in RAM.
	* We use smart pointers as the ownership of the pointer may change multiple times.
	* Note that vectors always store their size which would be stored redundantly.
	* It it enough to store the key size (size_of_key_in_bytes) together with each contingency table.
	* The number of different groups (number_of_groups) is stored only once for all contingency tables.
	* For the key, we used unigned char, i.e. bytes to reduce the number of unused bites per key.
	* However, if you want to change the datatypes for the key and data, you can change it here.
	*/
	using Key = std::unique_ptr<unsigned char[]>;
	using Data = std::unique_ptr<unsigned int[]>;

	/**
	* This class defines the distributions related to one key, i.e. the data sorted in one column of the contingency table.
	* In order to allow more advanced data structures, we removed the key from this class.
	* However, one key needs to be connected to every TableData instance.
	*
	* @brief Defines the distributions of one contingency table entry.
	* @author Nicolai Müller and Felix Uhle
	*/
	class TableData{
	public:
		/**
		* The constructor of an empty data set of one entry.
		* Here, we allocate and zero-initialize counters for every group.
		* Finally, all counters are zero.
		*
		* @brief Constructs an empty data set of one entry.
		* @param number_of_groups The total number of groups.
		* @author Nicolai Müller and Felix Uhle
		*/
		TableData(size_t number_of_groups);

		/**
		* To read and update the distributions we return a reference to the counters.
		* As the TableData instance still owns Data (smart pointer), we don't have to delete the returned pointer. 
		*
		* @brief Returns a pointer to all counters of the entry.
		* @return A pointer thats points on the counter array.
		* @author Nicolai Müller and Felix Uhle
		*/	
		unsigned int* GetCounters();

		/**
		* If a key is already part of the contingency table, we increment its corresponding counter.
		* For this, we take the index of the group in which the key was observed and increment the associated counter.
		*
		* @brief Increments an existing counter.
		* @param group_index The index of the group to increment.
		* @author Nicolai Müller and Felix Uhle
		*/	
		void Increment(size_t group_index);

	private:
		/**
		* This counters count store the distibutions by counting how often the connected key was probed for each group.
		* There is always one counter per group so, number_of_groups in total.
		* We use unsigned int for the counters as no negative numbers are possible and the maximum number of counted elements is assumed to be at most 100 million.
		*/	
		Data counters_;
	};	

	/**
	* This struct connects key and data to define an entry of the contingency table.
	* We use this structure as a helper to define a list of multiple entries.
	* We refer to such a list as bucket.
	*
	* @brief Defines a full table entry with key.
	* @author Nicolai Müller and Felix Uhle
	*/ 
	class TableEntry{
	public:
		/**
		* The constructor of an empty entry with key.
		* It works similar to the TableData constructor
		* but also moves the key pointer to the TableEntry object.
		*
		* @brief Constructs a new entry with key.
		* @param key The key belonging to this entry.
		* @param number_of_groups The total number of groups.
		* @author Nicolai Müller and Felix Uhle
		*/	
		TableEntry(Key key, size_t number_of_groups); 

		/**
		* @brief Returns all counters of the entry.
		* @return A pointer thats points on the counter array.
		* @author Nicolai Müller and Felix Uhle
		*/	
		unsigned int* GetCounters();

		/**
		* @brief Returns a specific byte of the key.
		* @param byte_index The index of the byte to return.
		* @return The specific byte of the key.
		* @author Nicolai Müller and Felix Uhle
		*/	
		unsigned char GetKeyByte(size_t byte_index) const;

		/**
		* @brief Increments one counter of the entry.
		* @param group_index The index of the group to increment.
		* @author Nicolai Müller and Felix Uhle
		*/	
		void Increment(size_t group_index);

	private:
		Key key_;
        TableData table_data_;
	};

	/**
	* Here, we just define a bucket as a vector of entries.
	* This vector must be sorted based on the keys.
	* As we are not sure that std::vector is the best data structure here
	* we use BucketContainer as a template which allows to use other data
	* types within the contingency table as long as all required functions
	* are defined for your data structure. 
	* Feel free, to try other data structures if you think they fit better.
	* The only requirement is that your new data structure must be iterable.
	*/ 
	using TableBucketVector = std::vector<TableEntry>;

	/**
	* This class defines the bucket, i.e. a list of entries.
	* We repeat that the data type of a bucket (BucketContainer) can be exchanged. 
	*
	* @brief Defines one bucket.
	* @author Nicolai Müller and Felix Uhle
	*/
	template <typename BucketContainer>
	class TableBucket {
	public:
		/**
		* In the compact mode we pre-initialize the contingency table with empty buckets.
		* Therefore, we need the default contructor. 
		*
		* @brief Constructs an empty bucket.
		* @author Nicolai Müller and Felix Uhle
		*/
		TableBucket() = default;

		/**
		* In the normal mode, we dynamically create buckets if they have to store an entry.
		* So if a bucket is created, there is already an entry to store in this bucket.
		* Therefore, we need the another constructor that place an entry in the newly created bucket. 
		*
		* @brief Constructs a bucket with one entry.
		* @author Nicolai Müller and Felix Uhle
		*/
		TableBucket(Key key, size_t number_of_groups);

		/**
		* This functions returns a reference to the full bucket.
		* We need this function to use omp atomic in the compact mode.
		* Omp atomic can only be used for specific operators but not function calls. 
		*
		* @brief Returns a reference to the bucket.
		* @return A reference to the bucket.
		* @author Nicolai Müller and Felix Uhle
		*/
		TableBucketVector& GetBucket();
		
		/**
		* @brief Returns the number of entries stored in the bucket.
		* @return The number of entries in the bucket.
		* @author Nicolai Müller and Felix Uhle
		*/		
		size_t GetNumberOfEntries();

		/**
		* @brief Returns the counters of a specific entry.
		* @param entry_index The index of the entry, i.e.e the bucket column.
		* @return A pointer thats points on the counter array.
		* @author Nicolai Müller and Felix Uhle
		*/		
		unsigned int* GetCounters(size_t entry_index);

		/**
		* For every simulated key we either increment the counter of an existing entry or create a new entry. 
		* This depends on whether the key is already present in the bucket, i.e. is associated with an entry, or not. 
		* However, if a new entry is created, it stil has to be incremented.
		*
		* @brief Increments one entry of the bucket.
		* @param key The simulated key.
		* @param number_of_groups The number of groups, i.e. the number of counter a new entry must encompass.
		* @param group_index The index of the group, i.e. the counter we need to update.
		* @param size_of_key_in_bytes The byte-size of the key which is required to compare the key with the entry-keys.
		* @author Nicolai Müller and Felix Uhle
		*/	
		void Increment(Key key, size_t number_of_groups, size_t group_index, size_t size_of_key_in_bytes);

	private:
		/**
		* We define a bucket as a sorted list of TableEntry instances.
		**/
		BucketContainer bucket_;

		/**
		* To check if there is already an entry connected to this key, we have to search the key in the bucket.
		*
		* @brief Searches for an entry with the simulated key.
		* @param key A reference to the simulated key.
		* @param size_of_key_in_bytes The byte-size of the key which is required to compare the key with the entry-keys.
		* @return An iterator to the entry with the same key or to the end of the bucket. 
		* @author Nicolai Müller and Felix Uhle
		*/	
		TableBucketVector::iterator FindEntry(const unsigned char* key, size_t size_of_key_in_bytes);

		/**
		* @brief Returns whether a key is already part of an entry.
		* @param key A reference to the simulated key.
		* @param it The iterator returned by Find Entry.
		* @param size_of_key_in_bytes The byte-size of the key which is required to compare the key with the entry-keys.
		* @return An iterator to the entry with the same key or to the end of the bucket. 
		* @author Nicolai Müller and Felix Uhle
		*/	
		bool IsEntryInBucket(const unsigned char* key, const TableBucketVector::iterator it, size_t size_of_key_in_bytes);
	};

	/**
	* This class defines the contingency table and is therefore instantiated in every probing set.
	*
	* @brief Defines the contingency table.
	* @author Nicolai Müller and Felix Uhle
	*/
	template <typename BucketContainer>
	class ContingencyTable {
	public:
		/**
		* To initialize a contingency table, we set the key and layer sizes
		* Further, depending on the mode of PROLEAD we pre-allocate the hash table.
		* Normal mode: Only the first layer is preallocated while the second layer is allocated during evaluation.
		* Compact mode. The whole table is pre-allocated. 
		* The exact sizes of the table depend on the size of the key, i.e. the number of probe-extensions of the probing set. 
		*
		* @brief Initializes the contingency table.
		* @param number_of_groups The number of groups.
		* @param number_of_probes The number of probe-extensions of the probing set.
		* @param is_in_compact_mode decision whether PROLEAD operates in compact mode or not.
		* @author Nicolai Müller and Felix Uhle
		*/			
		void Initialize(size_t number_of_groups, size_t number_of_probes, bool is_in_compact_mode);

		/**
		* @brief Returns -log10(p).
		* @return -log10(p)
		* @author Nicolai Müller and Felix Uhle
		*/	
		double GetGValue() const;

		/**
		* @brief Sets -log10(p) = 0.0.
		* @author Nicolai Müller and Felix Uhle
		*/	
		void ResetGValue();

		/**
		* @brief Returns the number of required traces.
		* @return The number of required traces.
		* @author Nicolai Müller and Felix Uhle
		*/	
		size_t GetNumberOfRequiredTraces() const;

		/**
		* Returns the size of the key after considering one or two bytes as indices for the hash table.
		* Only a key of this size is stored in a table entry.
		*
		* @brief Returns the size of the key in a table entry.
		* @return The number of required traces.
		* @author Nicolai Müller and Felix Uhle
		*/	
		size_t GetKeySizeExcludingHashValues();

		/**
		* If the probing set encompasses only a small number of probes using to layers tend to be an overkill.
		* For such probing sets we only use the first layer of the hash table and only one hash value.
		* Hence, we need the information how many layers are in use. 
		*
		* @brief Returns the number of used layers of the hash table.
		* @return The number of layers.
		* @author Nicolai Müller and Felix Uhle
		*/			
		size_t GetNumberOfLayers();

		/**
		* This is again required for using omp atomic in the compact mode.
		* In compact mode we only use the first layer for indexing so the first layer index corresponds to the key.
		*
		* @brief Returns a pointer to all counters of the entry.
		* @param index first-layer index of the hash table.
		* @return A pointer thats points on the counter array.
		* @author Nicolai Müller and Felix Uhle
		*/
		unsigned int* GetCounters(size_t index);

		/**
		* This function is called by the probing set to update the contingency table with a new simulation.
		* For this, the key and the hash values must be already separated.
		*
		* @brief Updates the contingency table with a new simulation.
		* @param key The simulated key.
		* @param hash_value0 The first hash value belonging to the key, i.e. the first-layer index.
		* @param hash_value1 The second hash value belonging to the key, i.e. the second-layer index.
		* @param number_of_groups The number of groups. In case we have to build a new entry.
		* @param group_index The group index to update the entry.
		* @author Nicolai Müller and Felix Uhle
		*/
		void UpdateTable(Key key, unsigned char hash_value0, unsigned char hash_value1, size_t number_of_groups, size_t group_index);

		/**
		* @brief Performs the full g-test procedure.
		* @param number_of_groups The number of groups.
		* @param number_of_simulations The number of already performed simulations.
		* @param frequencies The pre-computed frequencies.
		* @author Nicolai Müller and Felix Uhle
		*/
		void ComputeGTest(size_t number_of_groups, size_t number_of_simulations, std::vector<double> frequencies);

		/**
		* @brief Computes the number of required traces.
		* @param number_of_groups The number of groups.
		* @param beta_threshold The desired false-negative probability to achieve.
		* @param effect_size The desired effect size to achieve.
		* @author Nicolai Müller and Felix Uhle
		*/
		void ComputeNumberOfRequiredTraces(size_t number_of_groups, double beta_threshold, double effect_size);

		/**
		* Before we start with the evaluation, we remove all probing sets that are strictly less informative than other probing sets.
		* This function just encodes the information wether a probing set is strictly less informative in an unused variable.
		* Later, all probing sets which are marked in this way are removed.
		*
		* @brief Marks a probing set as removable.
		* @author Nicolai Müller and Felix Uhle
		*/		
		void MarkAsRemovable(){number_of_required_traces_ = 1;}

		/**
		* On the other hand, this function checks if a probing set is marked and can be removed.
		*
		* @brief Checks if a probing set can be removed.
		* @return The decision whether a probing set can be removed.
		* @author Nicolai Müller and Felix Uhle
		*/			
		bool IsRemovable(){return number_of_required_traces_ == 1;}

	private:
		/**
		* The contingency table is split into multiple buckets which are organized as an hash table with two layers.
		* In particular, at most, the first two bytes of the key are used as indices to address the required bucket.
		* The rest of the key is then moved to an entry of the bucket.
		* This is faster as having all table entries in one bucket as the time for searching keys in a bucket is reduced.
		* Further, this saves RAM as, at most, the first two bytes of the key must not be stored.
		* We decided to use a dynamic 2d-array based on smart-pointers due to a lower memory overhead compared to, e.g., std::vector.
		* In particular, every vector stores its size which would lead to multiple vectors storing the same size.
		*/	
		std::unique_ptr<std::unique_ptr<TableBucket<BucketContainer>[]>[]> hash_table_;

		size_t size_of_key_in_bytes_;

		/**
		* We store the dimensions of the 2D hash_table_ array separately to avoid additional area overhead.
		*/
		size_t number_of_indices_in_layer_0_;
		size_t number_of_indices_in_layer_1_;

		/**
		* Every time we evaluate the contingency table, i.e. perform the g-test, store the -log10(p) value.
		* We remark that -log10(p) > 5.0 indicates leakage.
		* We store -log10(p) in the class instead of returning it to allow sorting of contingency tables based on -log10(p).
		*/
		double g_;

		/**
		* Every time we evaluate the contingency table, i.e. perform the g-test, we also compute the number of traces required to achieve a reliable result.
		* Hence, if the required number of traces is reached we can assume that PROLEAD detects all leakages  w.r.t. a predefined error-probability and effect size.
		* We store the number of required traces in the class instead of returning it to allow sorting of contingency tables based on the number of traces.
		*/
		size_t number_of_required_traces_;
		
		/**
		* This function calculates the number of entries in the contingency table, i.e. the sum of all entry counts of the buckets.
		* This size of the contingency table is required to compute the g-test and the number of required traces.
		*
		* @brief Returns the number of entries in a contingency table.
		* @return The number of entries. 
		* @author Nicolai Müller and Felix Uhle
		*/			
		size_t GetNumberOfEntries();

		/**
		* @brief Returns the sum over all counters of one table entry.
		* @param counters A pointer thats points on the counter array.
		* @param number_of_groups The number of groups, i.e. the number of elements in the counter array.
		* @return The sum over all counters. 
		* @author Nicolai Müller and Felix Uhle
		*/	
		inline unsigned int ComputeSumOverAllGroupCountersOfAnEntry(unsigned int* counters, size_t number_of_groups);

		/**
		* Computing the expected frequencies of every table entry is part of the g-test.
		* 
		* @brief Computes the expected frequency of a table entry.
		* @param frequencies The precomputed frequencies.
		* @param sum The sum over all counters of an entry.
		* @param expected_frequencies The expected frequencies. (return value)
		* @author Nicolai Müller and Felix Uhle
		*/	
		void ComputeExpectedFrequenciesOfAnEntry(const std::vector<double>& frequencies, unsigned int sum, std::vector<double>& expected_frequencies);

		/**
		* Unfortunately, the g-test overestimates statistical outliers.
		* This leads to the fact that PROLEAD reports leakage if entries of the contingency table are sparsely filled.
		* For example, if a probing set contains many probes, each key will be simulated only once.
		* To avoid such false-positives we use pooling to combine sprsely-filled entries.
		* This function, checks if the expected frequency of an entry is high enough or has to be pooled.
		* This check is done based on a pooling factor which depends on the size of the contingency table.
		* The larger a table is the more aggresively the pooling is. Hence, the pooling factor increases.
		* 
		* @brief Checks if an entry has to be pooled.
		* @param expected_frequencies The precomputed frequencies.
		* @param pooling_factor The pooling factor.
		* @return The decision whether pooling is necessary or not.
		* @author Nicolai Müller and Felix Uhle
		*/	
		bool AreExpectedFrequenciesHighEnoughForEvaluation(const std::vector<double>& expected_frequencies, double pooling_factor);

		/**
		* If we decided that an entry need to be pooled, we just add its counters to a so-called pooling entry.
		* Hence, the table size decreases and the pooling entry becomes filled.
		* 
		* @brief Updates the pooling entry.
		* @param counters The counters to add to the pooling entry.
		* @param pooled_counters The counters of the pooling entry to update.
		* @param number_of_groups The number of groups, i.e. the number of counters to update.
		* @author Nicolai Müller and Felix Uhle
		*/	
		inline void UpdatePooledCounters(unsigned int* counters, unsigned int* pooled_counters, size_t number_of_groups);

		/**
		* @brief Updates the g-value with an entry.
		* @param counters A pointer thats points on the counter array of an entry.
		* @param expected_frequencies The expected frequencies of the same entry.
		* @return The updated g-value.
		* @author Nicolai Müller and Felix Uhle
		*/	
		inline void UpdateGValue(unsigned int* counters, const std::vector<double>& expected_frequencies, double& g);

		/**
		* @brief Transforms the g-value into -log10(p).
		* @param number_of_groups The number of groups.
		* @param number_of_simulations The number of already processed simulations.
		* @param frequencies The precomputed frequencies.
		* @param size_of_table The number of entries in the table (before pooling).
		* @param degree_of_freedom The degree of freedom.
		* @return The updated g-value.
		* @author Nicolai Müller and Felix Uhle
		*/	
		double ComputeGValue(size_t number_of_groups, size_t number_of_simulations, std::vector<double> frequencies, size_t size_of_table, size_t& degree_of_freedom);
	};
}
}

/**
* Generic functions required for software evaluations, e.g. all statistical procedures.	
*/	
namespace Util{
	/**
	* Defines one entry, i.e. one column, of a contingency table. 
	*
	* @brief Defines one entry of a contingency table.
	* @author Nicolai Müller
	*/
    struct TableEntryStruct{
        std::vector<unsigned char> Key; ///< The probed state of the cell, i.e. a byte-wise n-bit value recorded by n probes of a probing set.
        std::vector<unsigned int> Count; ///< Counts how often state state was probed for each user-defined group.
        
		/**
		* Initializes a new entry without a predefined state but with a specified number of groups. 
		* All counters are set to zero. 
		*
		* @brief Initializes a new entry without fixed state and zero counts. 
		* @param GroupSize Number of user-defined groups.
		* @author Nicolai Müller
		*/
		TableEntryStruct(unsigned int);
        
		/**
		* Initializes a new entry with a predefined state and predefined counts. 
		* All counters are set to zero. 
		*
		* @brief Initializes a new entry with fixed state and counts. 
		* @details While initializing the entry, all counts are set to zero but the user can define up to two counts to increment, i.e. two group counters can be set to one.
		* @param GroupSize Number of user-defined groups.
		* @param NewKey The fixed state of the entry.
		* @param GroupIndex1 The index of the first group.
		* @param GroupIndex2 The index of the second group.
		* @author Nicolai Müller
		*/		
		TableEntryStruct(unsigned int, std::vector<unsigned char>&, unsigned int, unsigned int);
    };

	/**
	* Defines the contingency table related to a probing set.
	* Every contingency table encompasses a list of contingency table entries.
	*
	* @brief Defines a contingency table.
	* @author Nicolai Müller
	*/
    struct ContingencyTableStruct{
        std::vector<TableEntryStruct> Entries; ///< Different entries of a contingency table, i.e. one entry per sample.
		
		/**
		* Temporary storage for all samples that occurred only once.
		* To save memory, we create a new entry in the table only if the sample occurres multiple times. 
		* Hence, only the sample itself must be stored without corresponding counters.
		* The structure is as follows:
		* 1. Dimension: The underlying group in which the sample occurred once.
		* 2. Dimension: The last byte of the sample vector. This only accelerates searching for samples.
		* 3. Dimension: The particular sample vector.
		* 4. Dimension: The specific byte of a particular sample vector.
		*/
        std::vector<std::vector<std::vector<std::vector<unsigned char>>>> OnlyOneEntry; ///< Stores all entires that occurred only once. 
        double Probability; ///< The false-positive probability computed with the G-test.
        unsigned int Traces; ///< The number of traces required to achieve a desired confidence level computed via statistical power analysis.

		/**
		* Computes the number of traces required to achieve a pre-defined confidence level, i.e. false-negative probability.
		*
		* @brief Computes the required number of traces. 
		* @param NumberOfGroups Number of user-defined groups.
		* @param BetaThreshold The pre-defined false-negative probability to achieve.
		* @param EffectSize The statistical effect size for which the false-negative probability should be achieved.
		* @return Traces Number of traces required to satisfy the effect size and false-negative probability.
		* @author Nicolai Müller
		*/	
        void CalculateTraces(int, double, double);
    };
 
	/**
	* Compute the statistical G-value from a given contingency table.
	*
	* @brief Computes the G-value. 
	* @param NumberOfGroups Number of user-defined groups.
	* @param NumberOfSimulations The number of simulated executions so far.
	* @param Table The contingency table.
	* @param Frequency Precomputed number of simulations per group.
	* @return gValue The G-value.
	* @author Nicolai Müller
	*/
    double GetGValue(unsigned int, unsigned int, ContingencyTableStruct&, std::vector<double>, unsigned int, unsigned int&);
	
	/**
	* Compute the false-positive probability from a given contingency table.
	*
	* @brief Computes the p-value. 
	* @param NumberOfGroups Number of user-defined groups.
	* @param NumberOfSimulations The number of simulated executions so far.
	* @param Table The contingency table.
	* @param Frequency Precomputed number of simulations per group.
	* @param TableSize The number of entries in a contingency table.
	* @param df The degree of freedom.
	* @return gValue The G-value.
	* @author Nicolai Müller
	*/	
    void GTest(unsigned int, unsigned int, ContingencyTableStruct&, std::vector<double>);

    void StartClock(timespec&);
    double EndClock(timespec&);
}
