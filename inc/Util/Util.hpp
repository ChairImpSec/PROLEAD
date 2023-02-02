#pragma once

#include <time.h>
#include <vector>
#include <cmath>
#include <numeric>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>

/**
* Generic functions required for hard- and software evaluations, e.g. all statistical procedures.	
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
