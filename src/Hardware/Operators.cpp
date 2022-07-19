#include "Hardware/Operators.hpp"

bool operator==(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    return ((FirstOperand.Probe == SecondOperand.Probe) && (FirstOperand.Cycle == SecondOperand.Cycle));
}

bool operator!=(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    return ((FirstOperand.Probe != SecondOperand.Probe) || (FirstOperand.Cycle != SecondOperand.Cycle));
}

bool operator<(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    if (FirstOperand.Cycle == SecondOperand.Cycle){
        return (FirstOperand.Probe < SecondOperand.Probe);
    }else{
        return (FirstOperand.Cycle < SecondOperand.Cycle);
    }   
}

bool operator<=(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    if (FirstOperand.Cycle == SecondOperand.Cycle){
        return (FirstOperand.Probe <= SecondOperand.Probe);
    }else{
        return (FirstOperand.Cycle < SecondOperand.Cycle);
    }     
}

bool operator>(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    if (FirstOperand.Cycle == SecondOperand.Cycle){
        return (FirstOperand.Probe > SecondOperand.Probe);
    }else{
        return (FirstOperand.Cycle > SecondOperand.Cycle);
    } 
}

bool operator>=(const Hardware::ProbePositionStruct& FirstOperand, const Hardware::ProbePositionStruct& SecondOperand){
    if (FirstOperand.Cycle == SecondOperand.Cycle){
        return (FirstOperand.Probe >= SecondOperand.Probe);
    }else{
        return (FirstOperand.Cycle > SecondOperand.Cycle);
    } 
}

bool operator==(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    if(FirstOperand.size() != SecondOperand.size()){
        return false;
    }

    for(size_t Index = 0; Index < FirstOperand.size(); ++Index){
        if(FirstOperand.at(Index) != SecondOperand.at(Index)){
            return false;
        }
    }
    return true;
}

bool operator!=(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    if(FirstOperand.size() != SecondOperand.size()){
        return true;
    }

    for(size_t Index = 0; Index < FirstOperand.size(); ++Index){
        if(FirstOperand.at(Index) != SecondOperand.at(Index)){
            return true;
        }
    }
    return false;
}

bool operator<(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    for (size_t Index = 0; Index < std::min(FirstOperand.size(), SecondOperand.size()); Index++){
        if (FirstOperand.at(Index) != SecondOperand.at(Index)){
            return FirstOperand.at(Index) < SecondOperand.at(Index);
        }
    }
    
    return FirstOperand.size() < SecondOperand.size();
}

bool operator<=(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    for (size_t Index = 0; Index < std::min(FirstOperand.size(), SecondOperand.size()); Index++){
        if (FirstOperand.at(Index) != SecondOperand.at(Index)){
            return FirstOperand.at(Index) < SecondOperand.at(Index);
        }
    }
    
    return FirstOperand.size() <= SecondOperand.size();
}

bool operator>(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    for (size_t Index = 0; Index < std::min(FirstOperand.size(), SecondOperand.size()); Index++){
        if (FirstOperand.at(Index) != SecondOperand.at(Index)){
            return FirstOperand.at(Index) > SecondOperand.at(Index);
        }
    }
    
    return FirstOperand.size() > SecondOperand.size();
}

bool operator>=(const std::vector<Hardware::ProbePositionStruct>& FirstOperand, const std::vector<Hardware::ProbePositionStruct>& SecondOperand){
    for (size_t Index = 0; Index < std::min(FirstOperand.size(), SecondOperand.size()); Index++){
        if (FirstOperand.at(Index) != SecondOperand.at(Index)){
            return FirstOperand.at(Index) > SecondOperand.at(Index);
        }
    }
    
    return FirstOperand.size() >= SecondOperand.size();
}

bool operator==(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
	return (FirstOperand.Extension == SecondOperand.Extension);
}

bool operator!=(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
	return (FirstOperand.Extension != SecondOperand.Extension);
}

bool operator<(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
    return (FirstOperand.Extension < SecondOperand.Extension);
}

bool operator<=(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
    return (FirstOperand.Extension <= SecondOperand.Extension);
}

bool operator>(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
    return (FirstOperand.Extension > SecondOperand.Extension);
}

bool operator>=(const Hardware::ProbingSetStruct& FirstOperand, const Hardware::ProbingSetStruct& SecondOperand){
    return (FirstOperand.Extension >= SecondOperand.Extension);
}

void Hardware::Operators::GenerateThreadRng(std::vector<boost::mt19937>& ThreadRng, unsigned int NumberOfThreads){
	unsigned int seed;

	for(unsigned int ThreadIndex = 0; ThreadIndex < NumberOfThreads; ThreadIndex++){
		seed = rand();
		boost::mt19937 rng(seed);
		ThreadRng[ThreadIndex] = rng;
	}
}