#pragma once

#include <iostream>
#include <cinttypes>
#include <vector>
#include <omp.h>

#include "Hardware/Operators.hpp"

namespace Hardware
{
    namespace GenerateProbingSets
    {
		/**
		* @brief Checks whether a probing set can be removed 
		* @param ProbingSet The The probing set to remove.
		* @author Nicolai Müller
		*/
        bool Remove(Hardware::ProbingSetStruct&);
		
		/**
		* @brief Checks whether a probing set satisfies a specific distance. 
		* @param Settings The general settings.
		* @param Test The test settings.
		* @param ProbingSet The The probing set to check.
		* @author Nicolai Müller
		*/		
        bool InDistance(Hardware::SettingsStruct&, Hardware::TestStruct&, std::vector<unsigned int>&);
		
		/**
		* @brief Generates lists of standard and extended probes. 
		* @param Settings The general settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/			
        void GenerateProbes(Hardware::SimulationStruct&, Hardware::TestStruct&);
        
		/**
		* @brief Initializes the multivariate probing set. 
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param Combination The probing set to initialize.
		* @param CombinationBitmask The Bitmask to iterate through probing sets.
		* @author Nicolai Müller
		*/		
		void InitializeMultivariateProbeCombinations(Hardware::SimulationStruct&, Hardware::TestStruct&, std::vector<unsigned int>&, std::vector<bool>&);
  
  		/**
		* @brief Initializes the univariate probing set. 
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param Combination The probing set to initialize.
		* @param CombinationBitmask The Bitmask to iterate through probing sets.
		* @author Nicolai Müller
		*/	
		void InitializeUnivariateProbeCombinations(Hardware::SimulationStruct&, std::vector<unsigned int>&, std::vector<bool>&);
        
	    /**
		* @brief Extends all standard probes in all probing sets. 
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/		
		void Extend(Hardware::SimulationStruct&, Hardware::TestStruct&);
		
	    /**
		* @brief Removes duplicated extended probes in all probing sets. 
		* @param Test The test settings.
		* @author Nicolai Müller
		*/			
        void RemoveDuplicatedProbes(Hardware::TestStruct&);
		
	    /**
		* @brief Checks for one probing set if it is covered by another probing set. 
		* @param Test The test settings.
		* @param SetIndex the index of the probing set to cover other probing sets.
		* @param Start The index of the first probing set to cover.
		* @param End The index of the last probing set to cover.
		* @author Nicolai Müller
		*/			
        void CoverWithOneProbingSet(Hardware::TestStruct&, unsigned int, unsigned int, unsigned int);
        
		/**
		* @brief Checks for all probing sets if they are covered by another probing set. 
		* @param Test The test settings.
		* @param SetIndex the index of the probing set to cover other probing sets.
		* @param Start The index of the first probing set to cover.
		* @param End The index of the last probing set to cover.
		* @author Nicolai Müller
		*/	
		void RemoveCoveredProbingSets(Hardware::TestStruct&, unsigned int, unsigned int);
        
		/**
		* @brief Removes all duplicated probing sets. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/	
		void RemoveDuplicatedProbingSets(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
                
		/**
		* @brief Initializes the contingency tables in the compact mode. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/			
		void InitializeCompactDistributions(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        
		/**
		* @brief Generates the probing sets. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/			
		void All(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
    }
}