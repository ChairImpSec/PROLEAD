#include "Util/Util.hpp"

Util::TableEntryStruct::TableEntryStruct(unsigned int GroupSize){
	Count.resize(GroupSize, 0);
}

Util::TableEntryStruct::TableEntryStruct(unsigned int GroupSize, std::vector<unsigned char>& NewKey, unsigned int GroupIndex1, unsigned int GroupIndex2){
	Key = NewKey;	
	Count.resize(GroupSize, 0);
	Count.at(GroupIndex1)++;
	Count.at(GroupIndex2)++;
}

void Util::ContingencyTableStruct::CalculateTraces(int NumberOfGroups, double BetaThreshold, double EffectSize){
    bool TooSmall = true;
    size_t BitIndex, GroupIndex;
    unsigned int Factor = 1;
    unsigned int TableSize = Entries.size();
    double NoncentralityParameter, Beta;

    Traces = 1;

    for (GroupIndex = 0; GroupIndex < OnlyOneEntry.size(); GroupIndex++){
        for (BitIndex = 0; BitIndex < OnlyOneEntry.at(GroupIndex).size(); BitIndex++){
            TableSize += OnlyOneEntry.at(GroupIndex).at(BitIndex).size();
        }
    }

    if (TableSize > 1){
        // Compute degree of freedom
        unsigned int Df = (NumberOfGroups - 1) * (TableSize - 1); 

        // Compute critical g value
        boost::math::chi_squared_distribution<> Distribution1(Df);
        double CriticalValue = boost::math::quantile(boost::math::complement(Distribution1, BetaThreshold));

        while (true){
            // Get non-centrality parameter
            NoncentralityParameter = EffectSize * EffectSize * Traces;

            // Get type II error rate
            boost::math::non_central_chi_squared_distribution<> Distribution2(Df, NoncentralityParameter);
            Beta = boost::math::cdf(Distribution2, CriticalValue);

            if (Beta > BetaThreshold){
                if (TooSmall){
                    Traces += Factor;
                    Factor <<= 1;
                }else{
                    if (Factor == 1){
                        break;
                    }else{
                        TooSmall = true;
                        Factor = 1;
                        Traces += Factor;
                    }
                }
            }else{
                if (!TooSmall){
                    Traces -= Factor;
                    Factor <<= 1;
                }else{
                    if (Factor == 1){
                        break;
                    }else{
                        TooSmall = false;
                        Factor = 1;
                        Traces -= Factor;
                    }
                }
            }
        }
    }
}

double Util::GetGValue(unsigned int NumberOfGroups, unsigned int NumberOfSimulations, Util::ContingencyTableStruct& Table, std::vector<double> Frequency, unsigned int TableSize, unsigned int& Df){
    unsigned int SumOverBin = 0, BinIndex = 0, BitIndex = 0, SanitisedTableSize = 0;
    unsigned int GroupIndex = 0, GroupIndex2 = 0;
    double       gValue = 0.0, portion = 0.0, product = 0.0;
    std::vector<double> ExpectedFrequency(NumberOfGroups, 0.0);
    std::vector<unsigned int> PooledCount(NumberOfGroups, 0);
    bool Valid = true;
    Df = 0;

    double PoolingFactor = (double)NumberOfSimulations / TableSize;
    std::transform(Frequency.begin(), Frequency.end(), Frequency.begin(), [NumberOfSimulations](double x){return x / NumberOfSimulations;});

    for (BinIndex = 0; BinIndex < Table.Entries.size(); BinIndex++){
        SumOverBin = std::accumulate(Table.Entries.at(BinIndex).Count.begin(), Table.Entries.at(BinIndex).Count.end(), 0);

        Valid = true;
        for (GroupIndex = 0; GroupIndex < NumberOfGroups; GroupIndex++){
            ExpectedFrequency.at(GroupIndex) = Frequency.at(GroupIndex) * SumOverBin;

            if ((ExpectedFrequency.at(GroupIndex) < 5.0) || ((ExpectedFrequency.at(GroupIndex) < 5.0 * PoolingFactor) && ExpectedFrequency.at(GroupIndex) < 20.0)){
                Valid = false;
            }
        }

        if (Valid){
            for (GroupIndex = 0; GroupIndex < NumberOfGroups; GroupIndex++){
                if (Table.Entries.at(BinIndex).Count.at(GroupIndex)){
                    portion = Table.Entries.at(BinIndex).Count.at(GroupIndex) / ExpectedFrequency.at(GroupIndex);
                    product = Table.Entries.at(BinIndex).Count.at(GroupIndex) * std::log(portion);
                    gValue += product;
                }          
            }

            SanitisedTableSize++;
        }else{
            for (GroupIndex = 0; GroupIndex < NumberOfGroups; GroupIndex++){
                PooledCount.at(GroupIndex) += Table.Entries.at(BinIndex).Count.at(GroupIndex); 
            }
        }
    }

    for (GroupIndex = 0; GroupIndex < (unsigned int)Table.OnlyOneEntry.size(); GroupIndex++){
        for (BitIndex = 0; BitIndex < Table.OnlyOneEntry.at(GroupIndex).size(); BitIndex++){
            for (BinIndex = 0; BinIndex < Table.OnlyOneEntry.at(GroupIndex).at(BitIndex).size(); BinIndex++){
                SumOverBin = 1;

                Valid = true;
                for (GroupIndex2 = 0; GroupIndex2 < NumberOfGroups; GroupIndex2++){
                    ExpectedFrequency.at(GroupIndex2) = Frequency.at(GroupIndex2) * SumOverBin;

                    if ((ExpectedFrequency.at(GroupIndex2) < 5.0) || ((ExpectedFrequency.at(GroupIndex2) < 5.0 * PoolingFactor) && ExpectedFrequency.at(GroupIndex2) < 20.0)){
                        Valid = false;
                    }
                }

                if (Valid){
                    for (GroupIndex2 = 0; GroupIndex2 < NumberOfGroups; GroupIndex2++){
                        portion = 1.0 / ExpectedFrequency.at(GroupIndex);
                        product = std::log(portion);
                        gValue += product;        
                    }

                    SanitisedTableSize++;
                }else{
                    PooledCount.at(GroupIndex) += 1; 
                }
            }
        }
    }

    SumOverBin = std::accumulate(PooledCount.begin(), PooledCount.end(), 0);

    if (SumOverBin){
        for (GroupIndex = 0; GroupIndex < NumberOfGroups; GroupIndex++){
            ExpectedFrequency.at(GroupIndex) = Frequency.at(GroupIndex) * SumOverBin;

            if (PooledCount.at(GroupIndex)){
                portion = PooledCount.at(GroupIndex) / ExpectedFrequency.at(GroupIndex);
                product = PooledCount.at(GroupIndex) * std::log(portion);
                gValue += product;
            }  
        }    

        SanitisedTableSize++;
    }

    gValue *= 2;
    Df = (NumberOfGroups - 1) * (SanitisedTableSize - 1);

    if (gValue < 0.0){
        gValue = 0.0;
    }    

    return gValue;
}

void Util::GTest(unsigned int NumberOfGroups, unsigned int NumberOfSimulations, Util::ContingencyTableStruct& Table, std::vector<double> Frequency){
    unsigned int Df = 0, TableSize = Table.Entries.size(); 

    for (size_t GroupIndex = 0; GroupIndex < Table.OnlyOneEntry.size(); GroupIndex++){
        TableSize += Table.OnlyOneEntry.at(GroupIndex).size();
    }

    if (NumberOfGroups != 1 && TableSize != 1){
        double gValue = GetGValue(NumberOfGroups, NumberOfSimulations, Table, Frequency, TableSize, Df);

        if (Df){
            boost::math::chi_squared_distribution<> Distribution(Df);
            // -3.321928094887362 = -log2(10)
            Table.Probability = log2(boost::math::cdf(boost::math::complement(Distribution, gValue))) / -3.321928094887362;
        }else{
            Table.Probability = 0.0;
        }
    }else{
        Table.Probability = 0.0;
    }
}

void Util::StartClock(timespec& Begin){
    clock_gettime(CLOCK_REALTIME, &Begin);
}

double Util::EndClock(timespec& Begin){
    struct timespec End;
    clock_gettime(CLOCK_REALTIME, &End);
    long TimeInSeconds = End.tv_sec - Begin.tv_sec;
    long TimeInNanoseconds = End.tv_nsec - Begin.tv_nsec;
    double ElapsedTimePeriod = TimeInSeconds + TimeInNanoseconds*1e-9;
    return ElapsedTimePeriod;
}