#include "Software/Operators.hpp"

//***************************************************************************************
bool operator==(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand){
	return (firstOperand.StandardProbe == secondOperand.StandardProbe);
}

//***************************************************************************************
bool ProbingSetCompare(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand){
    return (firstOperand.StandardProbe < secondOperand.StandardProbe);
}

bool ProbeInfoEquality(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand){
    return (firstOperand == secondOperand);
}

//***************************************************************************************
bool operator<(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand){
    return (firstOperand.StandardProbe < secondOperand.StandardProbe);
}

//***************************************************************************************
bool operator==(const std::vector<::Software::ProbesStruct>& firstOperand, const std::vector<::Software::ProbesStruct>& secondOperand){
    if (firstOperand.size() != secondOperand.size()){
        return false;
    }else{
        unsigned int Index = 0;

        for (Index = 0; Index < firstOperand.size(); Index++){
            if(!(firstOperand.at(Index) == secondOperand.at(Index))){
                return false;
            }
        }
        return true;
    }
}

bool operator==(const std::vector<::Software::ProbingSetStruct>& firstOperand, const std::vector<::Software::ProbingSetStruct>& secondOperand){
    if (firstOperand.size() != secondOperand.size()){
        return false;
    }else{
        unsigned int Index = 0;

        for (Index = 0; Index < firstOperand.size(); Index++){
            if(!(firstOperand.at(Index) == secondOperand.at(Index))){
                return false;
            }
        }
        return true;
    }
}

//***************************************************************************************
//firstOperand/secondOperand is vector of all standard probes of current ProbingSet
bool operator<(const std::vector<::Software::ProbesStruct>& firstOperand, const std::vector<::Software::ProbesStruct>& secondOperand){
    if (firstOperand.size() != secondOperand.size()){
        return (firstOperand.size() < secondOperand.size());
    }else{
        unsigned int Index = 0;

        for (Index = 0; Index < firstOperand.size(); Index++){

            if(firstOperand.at(Index) < secondOperand.at(Index)){
                return true;
            }

            if(firstOperand.at(Index) > secondOperand.at(Index)){
                return false;
            }
        }

        return false;
    }
}

//***************************************************************************************
bool operator<(const std::vector<::Software::ProbingSetStruct>& firstOperand, const std::vector<::Software::ProbingSetStruct>& secondOperand){
    if (firstOperand.size() != secondOperand.size()){
        return (firstOperand.size() < secondOperand.size());
    }else{
        unsigned int Index = 0;

        for (Index = 0; Index < firstOperand.size(); Index++){
            if(!(firstOperand.at(Index) == secondOperand.at(Index))){
                return (firstOperand[Index] < secondOperand[Index]);
            }
        }

        return false;
    }
}


//***************************************************************************************
bool TableEntryCompare(const Util::TableEntryStruct& firstOperand, const Util::TableEntryStruct& secondOperand){
	return (firstOperand.Key < secondOperand.Key);
}


//***************************************************************************************
bool operator==(const ::Software::ProbesStruct& firstOperand, const ::Software::ProbesStruct& secondOperand){

    return (firstOperand.ProbeInfo) == (secondOperand.ProbeInfo);
}

//***************************************************************************************
bool operator<(const ::Software::ProbesStruct& firstOperand, const ::Software::ProbesStruct& secondOperand){

    return (firstOperand.ProbeInfo) < (secondOperand.ProbeInfo);
}

//***************************************************************************************
bool operator>(const Software::ProbesStruct& firstOperand, const ::Software::ProbesStruct& secondOperand){


    return (firstOperand.ProbeInfo) > (secondOperand.ProbeInfo);

}

//***************************************************************************************
bool ProbabilityCompare(const Software::ProbingSetStruct& firstOperand, const  Software::ProbingSetStruct& secondOperand){
    return (firstOperand.ContingencyTable.Probability < secondOperand.ContingencyTable.Probability);
}

//***************************************************************************************
bool SoftwareProbabilityCompare(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand){
    return (firstOperand.ContingencyTable.Probability < secondOperand.ContingencyTable.Probability);
}

//***************************************************************************************
void Software::Operators::GenerateThreadRng(std::vector<boost::mt19937>& ThreadRng, unsigned int NumberOfThreads){
	unsigned int seed;
    srand(time(0));
	for(unsigned int ThreadIndex = 0; ThreadIndex < NumberOfThreads; ThreadIndex++){
		seed = rand();
		boost::mt19937 rng(seed);
		ThreadRng[ThreadIndex] = rng;
	}
}

//***************************************************************************************
unsigned int Software::Operators::BinomialCoefficient(int n, int k)
{
    int i = 0, j = 0;
    std::vector<unsigned int> C(k + 1, 0);
    C[0] = 1;

    for (i = 0; i <= n; i++)
        for (j = std::min(i,k); j > 0; j--)
            C[j] += C[j-1];

    return C[k];
}
//***************************************************************************************
void SwapEndian(uint32_t &val) {
    union U {
        uint32_t val;
        std::array<std::uint8_t, sizeof(uint32_t)> raw;
    } src, dst;

    src.val = val;
    std::reverse_copy(src.raw.begin(), src.raw.end(), dst.raw.begin());
    val = dst.val;
}

void Software::Operators::ComputeBinomCoeffOrderOverTwo(std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, uint32_t TestOrder){
    std::string bitmask(2, 1); // K leading 1's
    bitmask.resize(TestOrder, 0); // N-K trailing 0's
 
    //permute bitmask
    do {
        std::vector<uint32_t> Comb;
        for (uint32_t i = 0; i <TestOrder ; ++i) // [0..N-1] integers
        {
            if (bitmask[i])
            { 
                Comb.emplace_back(i);
            }
        }
        OrderOverTwoCombination.push_back(std::make_tuple(Comb.at(0), Comb.at(1)));
    } while (std::prev_permutation(bitmask.begin(), bitmask.end()));
}
