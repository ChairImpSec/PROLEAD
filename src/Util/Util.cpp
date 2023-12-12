#include "Util/Util.hpp"

namespace hardware{
namespace stats{
TableData::TableData(size_t number_of_groups) {
  counters_ = std::make_unique<unsigned int[]>(number_of_groups);
}

unsigned int* TableData::GetCounters() {
  return counters_.get();
}

void TableData::Increment(size_t group_index) {
  ++counters_[group_index];
}

TableEntry::TableEntry(Key key, size_t number_of_groups) 
  : key_{std::move(key)}, table_data_{number_of_groups}{}

unsigned int* TableEntry::GetCounters() {
  return table_data_.GetCounters();
}

unsigned char TableEntry::GetKeyByte(size_t byte_index) const {
  return key_[byte_index];
}

void TableEntry::Increment(size_t group_index) {
  table_data_.Increment(group_index);
}

template <>
TableBucket<TableBucketVector>::TableBucket(Key key, size_t number_of_groups) {
  bucket_.emplace_back(std::move(key), number_of_groups);
}

template <>
TableBucketVector& TableBucket<TableBucketVector>::GetBucket() {
    return bucket_;
}

template <class BucketContainer>
size_t TableBucket<BucketContainer>::GetNumberOfEntries() {
  return bucket_.size();
}

template <class BucketContainer>
unsigned int* TableBucket<BucketContainer>::GetCounters(size_t entry_index) {
  return bucket_[entry_index].GetCounters();
}

template <>
TableBucketVector::iterator TableBucket<TableBucketVector>::FindEntry(const unsigned char* key, size_t size_of_key_in_bytes) {
    return std::lower_bound(bucket_.begin(), bucket_.end(), key, [size_of_key_in_bytes](const TableEntry& lhs, const unsigned char* rhs) {
      // Keys to compare are always of equal size
      for (size_t key_index = 0; key_index < size_of_key_in_bytes; ++key_index){
        if (lhs.GetKeyByte(key_index) != rhs[key_index]){
          return lhs.GetKeyByte(key_index) < rhs[key_index];
        }
      }

      return false;
    });
}

template <>
bool TableBucket<TableBucketVector>::IsEntryInBucket(const unsigned char* key, const TableBucketVector::iterator it, size_t size_of_key_in_bytes){
  if (it != bucket_.end()){
    for (size_t key_index = 0; key_index < size_of_key_in_bytes; ++key_index){
      if (it->GetKeyByte(key_index) != key[key_index]){
        return false;
      }
    }

    return true;
  }else{
    return false;
  }
}

template <>
void TableBucket<TableBucketVector>::Increment(Key key, size_t number_of_groups, size_t group_index, size_t size_of_key_in_bytes) {
  TableBucketVector::iterator it = FindEntry(key.get(), size_of_key_in_bytes);
  if (!TableBucket<TableBucketVector>::IsEntryInBucket(key.get(), it, size_of_key_in_bytes)) {
    it = bucket_.emplace(it, std::move(key), number_of_groups);
  }

  it->Increment(group_index);
}

template<class BucketContainer>
void ContingencyTable<BucketContainer>::Initialize(size_t number_of_groups, size_t number_of_probes, bool is_in_compact_mode) {
	g_ = 0.0;
	number_of_required_traces_ = 0;
  size_of_key_in_bytes_ = number_of_probes >> 3;

  if (number_of_probes & 0b111){
    ++size_of_key_in_bytes_;
  }

    if (is_in_compact_mode){
        number_of_indices_in_layer_0_ = number_of_probes + 1;
        number_of_indices_in_layer_1_ = 1;

        hash_table_ = std::make_unique<std::unique_ptr<TableBucket<BucketContainer>[]>[]>(number_of_indices_in_layer_0_);
        for (size_t bucket_index = 0; bucket_index < number_of_indices_in_layer_0_; ++bucket_index){
            hash_table_[bucket_index] = std::make_unique<TableBucket<BucketContainer>[]>(number_of_indices_in_layer_1_);
            hash_table_[bucket_index][0] = TableBucket<BucketContainer>(nullptr, number_of_groups);
        }
    }else{
      if (number_of_probes > 8){
        number_of_indices_in_layer_0_ = 256;

        if (number_of_probes > 16){
          number_of_indices_in_layer_1_ = 256;
        }else{
          number_of_indices_in_layer_1_ = 1 << (number_of_probes - 8);
        }
      }else{
        number_of_indices_in_layer_0_ = 1 << number_of_probes;
        number_of_indices_in_layer_1_ = 1;
      }
      
      hash_table_ = std::make_unique<std::unique_ptr<TableBucket<BucketContainer>[]>[]>(number_of_indices_in_layer_0_);
      for (size_t bucket_index = 0; bucket_index < number_of_indices_in_layer_0_; ++bucket_index){
        hash_table_[bucket_index] = nullptr;
      }
    }
}

template void ContingencyTable<TableBucketVector>::Initialize(size_t, size_t, bool);

template <class BucketContainer>
size_t ContingencyTable<BucketContainer>::GetNumberOfLayers(){
  if (number_of_indices_in_layer_1_ > 1){
    return 2;
  }else{
    return 1;
  }
}

template size_t ContingencyTable<TableBucketVector>::GetNumberOfLayers();

template<class BucketContainer>
unsigned int* ContingencyTable<BucketContainer>::GetCounters(size_t index) {
    return hash_table_[index][0].GetBucket()[0].GetCounters();
}

template unsigned int* ContingencyTable<TableBucketVector>::GetCounters(size_t);

template<class BucketContainer>
double ContingencyTable<BucketContainer>::GetGValue() const {
  return g_;
}

template double ContingencyTable<TableBucketVector>::GetGValue() const;

template<class BucketContainer>
void ContingencyTable<BucketContainer>::ResetGValue() {
  g_ = 0.0;
}

template void ContingencyTable<TableBucketVector>::ResetGValue();

template<class BucketContainer>
size_t ContingencyTable<BucketContainer>::GetNumberOfRequiredTraces() const {
  return number_of_required_traces_;
}

template size_t ContingencyTable<TableBucketVector>::GetNumberOfRequiredTraces() const;

template <class BucketContainer>
size_t ContingencyTable<BucketContainer>::GetKeySizeExcludingHashValues(){
  if (number_of_indices_in_layer_1_ > 1){
    return size_of_key_in_bytes_ - 2;
  }else{
    if (number_of_indices_in_layer_0_ > 1){
      return size_of_key_in_bytes_ - 1;
    }else{
      return size_of_key_in_bytes_;
    }
  }
}

template size_t ContingencyTable<TableBucketVector>::GetKeySizeExcludingHashValues();

template<class BucketContainer>
void ContingencyTable<BucketContainer>::UpdateTable(Key key, unsigned char hash_value0, unsigned char hash_value1, size_t number_of_groups, size_t group_index){ 
  if(hash_table_[hash_value0] != nullptr){
    hash_table_[hash_value0][hash_value1].Increment(std::move(key), number_of_groups, group_index, GetKeySizeExcludingHashValues());
  }else{
    hash_table_[hash_value0] = std::make_unique<TableBucket<BucketContainer>[]>(number_of_indices_in_layer_1_);
    hash_table_[hash_value0][hash_value1] = TableBucket<BucketContainer>(std::move(key), number_of_groups);
    ++hash_table_[hash_value0][hash_value1].GetCounters(0)[group_index];
  }
}

template void ContingencyTable<TableBucketVector>::UpdateTable(Key, unsigned char, unsigned char,  size_t, size_t);

template<class BucketContainer>
size_t ContingencyTable<BucketContainer>::GetNumberOfEntries(){
  size_t l0_index, l1_index, number_of_entries = 0;

  for (l0_index = 0; l0_index < number_of_indices_in_layer_0_; ++l0_index){
    if (hash_table_[l0_index] != nullptr){
      for (l1_index = 0; l1_index < number_of_indices_in_layer_1_; ++l1_index){
        if (hash_table_[l0_index][l1_index].GetNumberOfEntries()){
          number_of_entries += hash_table_[l0_index][l1_index].GetNumberOfEntries();
        }
      }
    }
  }

  return number_of_entries;
}

template<class BucketContainer>
inline unsigned int ContingencyTable<BucketContainer>::ComputeSumOverAllGroupCountersOfAnEntry(unsigned int* counters, size_t number_of_groups){
  unsigned int sum = 0;
  for (size_t group_index = 0; group_index < number_of_groups; ++group_index){
    sum += counters[group_index];
  }

  return sum;
}

template<class BucketContainer>
void ContingencyTable<BucketContainer>::ComputeExpectedFrequenciesOfAnEntry(const std::vector<double>& frequencies, unsigned int sum, std::vector<double>& expected_frequencies){
  for (size_t index = 0; index < expected_frequencies.size(); ++index) {
    expected_frequencies[index] = frequencies[index] * sum;
  }
}

template<class BucketContainer>
bool ContingencyTable<BucketContainer>::AreExpectedFrequenciesHighEnoughForEvaluation(const std::vector<double>& expected_frequencies, double pooling_factor){
  for (size_t index = 0; index < expected_frequencies.size(); ++index) {
    if ((expected_frequencies[index] < 5.0) || ((expected_frequencies[index] < 5.0 * pooling_factor) && expected_frequencies[index] < 20.0)) {
      return false;
    }
  }

  return true;
}

template<class BucketContainer>
inline void ContingencyTable<BucketContainer>::UpdateGValue(unsigned int* counters, const std::vector<double>& expected_frequencies, double& g){
  double portion = 0.0, product = 0.0;
  
  for (size_t index = 0; index < expected_frequencies.size(); ++index) {
    if (counters[index]) {
      portion = counters[index] / expected_frequencies[index];
      product = counters[index] * std::log(portion);
      g += product;
    }
  }
}

template<class BucketContainer>
inline void ContingencyTable<BucketContainer>::UpdatePooledCounters(unsigned int* counters, unsigned int* pooled_counters, size_t number_of_groups){
  for (size_t group_index = 0; group_index < number_of_groups; ++group_index) {
    pooled_counters[group_index] += counters[group_index];
  }
}

template<class BucketContainer>
double ContingencyTable<BucketContainer>::ComputeGValue(size_t number_of_groups, size_t number_of_simulations, std::vector<double> frequencies, size_t size_of_table,
                       size_t& degree_of_freedom){

  size_t l0_index, l1_index, entry_index;
  size_t number_of_entries;
  size_t size_of_sanitized_table = 0;
  unsigned int sum_over_all_group_counters_of_an_entry;
  unsigned int* counters_of_pooled_entry = new unsigned int[number_of_groups]();
  unsigned int* counters;
  double g = 0.0;
  double pooling_factor = (double)number_of_simulations / size_of_table;
  std::vector<double> expected_frequencies(number_of_groups, 0.0);

  std::transform(frequencies.begin(), frequencies.end(), frequencies.begin(), [number_of_simulations](double x) { return x / number_of_simulations; });

  for (l0_index = 0; l0_index < number_of_indices_in_layer_0_; ++l0_index){
    if (hash_table_[l0_index] != nullptr){
      for (l1_index = 0; l1_index < number_of_indices_in_layer_1_; ++l1_index){
        number_of_entries = hash_table_[l0_index][l1_index].GetNumberOfEntries();

        if (number_of_entries){
          for (entry_index = 0; entry_index < number_of_entries; ++entry_index){
            counters = hash_table_[l0_index][l1_index].GetCounters(entry_index);

            sum_over_all_group_counters_of_an_entry = ContingencyTable<BucketContainer>::ComputeSumOverAllGroupCountersOfAnEntry(counters, number_of_groups);
            ContingencyTable<BucketContainer>::ComputeExpectedFrequenciesOfAnEntry(frequencies, sum_over_all_group_counters_of_an_entry, expected_frequencies);

            if (ContingencyTable<BucketContainer>::AreExpectedFrequenciesHighEnoughForEvaluation(expected_frequencies, pooling_factor)) {
              ContingencyTable<BucketContainer>::UpdateGValue(counters, expected_frequencies, g);
              ++size_of_sanitized_table;
            } else {
              ContingencyTable<BucketContainer>::UpdatePooledCounters(counters, counters_of_pooled_entry, number_of_groups);
            }              
          }          
        }
      }
    }
  }
  
  sum_over_all_group_counters_of_an_entry = ContingencyTable<BucketContainer>::ComputeSumOverAllGroupCountersOfAnEntry(counters_of_pooled_entry, number_of_groups);

  if (sum_over_all_group_counters_of_an_entry) {
    ContingencyTable<BucketContainer>::ComputeExpectedFrequenciesOfAnEntry(frequencies, sum_over_all_group_counters_of_an_entry, expected_frequencies);
    ContingencyTable<BucketContainer>::UpdateGValue(counters_of_pooled_entry, expected_frequencies, g);
    ++size_of_sanitized_table;
  }

  g *= 2;
  degree_of_freedom = (number_of_groups - 1) * (size_of_sanitized_table - 1);

  if (g < 0.0) {
    g = 0.0;
  }

  delete[] counters_of_pooled_entry;
  return g;
}

template<class BucketContainer>
void ContingencyTable<BucketContainer>::ComputeGTest(size_t number_of_groups, size_t number_of_simulations, std::vector<double> frequencies) {
  size_t degree_of_freedom;
  size_t size_of_table = GetNumberOfEntries();

  if (number_of_groups != 1 && size_of_table != 1) {
    double g = ContingencyTable<BucketContainer>::ComputeGValue(number_of_groups, number_of_simulations, frequencies, size_of_table, degree_of_freedom);

    if (degree_of_freedom) {
      boost::math::chi_squared_distribution<> distribution(degree_of_freedom);
      // -3.321928094887362 = -log2(10)
      g_ = log2(boost::math::cdf(boost::math::complement(distribution, g))) / -3.321928094887362;
    } else {
      g_ = 0.0;
    }
  } else {
    g_ = 0.0;
  }
}

template void ContingencyTable<TableBucketVector>::ComputeGTest(size_t, size_t, std::vector<double>);

template<class BucketContainer>
void ContingencyTable<BucketContainer>::ComputeNumberOfRequiredTraces(size_t number_of_groups, double beta_threshold, double effect_size){
  unsigned int factor = 1;
  size_t size_of_table = GetNumberOfEntries();
  double non_centrality_parameter, beta;
  bool too_small = true;

  number_of_required_traces_ = 1;

  if (size_of_table > 1) {
    size_t degree_of_freedom = (number_of_groups - 1) * (size_of_table - 1);

    // Compute critical g value
    boost::math::chi_squared_distribution<> distribution1(degree_of_freedom);
    double critical_value = boost::math::quantile(
        boost::math::complement(distribution1, beta_threshold));

    while (true) {
      non_centrality_parameter = effect_size * effect_size * number_of_required_traces_;

      // Get type II error rate
      boost::math::non_central_chi_squared_distribution<> distribution2(
          degree_of_freedom, non_centrality_parameter);
      beta = boost::math::cdf(distribution2, critical_value);

      if (beta > beta_threshold) {
        if (too_small) {
          number_of_required_traces_ += factor;
          factor <<= 1;
        } else {
          if (factor == 1) {
            break;
          } else {
            too_small = true;
            factor = 1;
            number_of_required_traces_ += factor;
          }
        }
      } else {
        if (!too_small) {
          number_of_required_traces_ -= factor;
          factor <<= 1;
        } else {
          if (factor == 1) {
            break;
          } else {
            too_small = false;
            factor = 1;
            number_of_required_traces_ -= factor;
          }
        }
      }
    }
  }
}

template void ContingencyTable<TableBucketVector>::ComputeNumberOfRequiredTraces(size_t, double, double);

}
}

















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

void Util::PrintHelp(){
    std::cout << "Welcome to the PROLEAD help!" << std::endl;
    std::cout << "For detailed instructions on how to use our software, please refer to our GitHub Page:" << std::endl;
    std::cout << "Link to GitHub: https://github.com/ChairImpSec/PROLEAD/tree/main" << std::endl << std::endl;
    std::cout << "If you have further questions, need assistance, or want to reach out for any reason, you can get in touch with me:" << std::endl;
    std::cout << "Website: https://informatik.rub.de/impsec/personen/mueller/" << std::endl;
    std::cout << "E-Mail:  nicolai.mueller@rub.de" << std::endl << std::endl;
    std::cout << "We are happy to assist you with any questions, issues, or feedback you may have." << std::endl; 
    std::cout << "Your input is important to us and will help us enhance your experience with PROLEAD." << std::endl;
    std::cout << "Thank you for choosing PROLEAD!" << std::endl;
}

void Util::PrintCommandLineSettings(const CommandLineParameterStruct& command_line_parameters){
    std::cout << "Library file:   " << command_line_parameters.LibraryFileName            << std::endl;
    std::cout << "Library name:   " << command_line_parameters.LibraryName                << std::endl;
    std::cout << "Design file:    " << command_line_parameters.DesignFileName             << std::endl;
    std::cout << "Module name:    " << command_line_parameters.MainModuleName             << std::endl;
    std::cout << "Linker file:    " << command_line_parameters.LinkerFileName             << std::endl;
    std::cout << "Settings file:  " << command_line_parameters.SettingsFileName           << std::endl;
    std::cout << "Result folder:  " << command_line_parameters.EvaluationResultFolderName << std::endl;
    std::cout << std::endl;
}

uint64_t Util::PrintMemoryConsumption(){
    std::ifstream status("/proc/self/status");
    std::string line, number;
    uint64_t ram = 0;

    if (status.is_open()){
        while (getline(status,line)){
            if (line.find("VmSize") != std::string::npos){
                number = line.substr(7, line.length());
                ram = std::stoll(number.substr(0, number.length() - 2));
                break;
            }
        }
        status.close();
    }else{
        throw std::logic_error("Status file not found!");
    }

    return ram;
}

void Util::PrintHorizontalLine(unsigned int width){
  std::cout.width(width);
  std::cout.fill('-');
  std::cout << '-' << std::endl;
  std::cout.fill(' ');
}

void Util::PrintRow(std::vector<unsigned int>& width, std::vector<std::string>& elements){
  std::cout << '|';

  for (size_t index = 0; index < elements.size(); ++index){
    std::cout.width(width[index]);
    std::cout << (elements[index] + " |");        
  }

  std::cout << std::endl;  
}

void Util::GenerateThreadRng(std::vector<boost::mt19937>& thread_rng, unsigned int number_of_threads){
	unsigned int seed;

	for(unsigned int thread_index = 0; thread_index < number_of_threads; ++thread_index){
		seed = rand();
		boost::mt19937 rng(seed);
		thread_rng[thread_index] = rng;
	}
}

