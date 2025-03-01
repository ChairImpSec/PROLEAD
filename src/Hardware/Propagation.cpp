#include "Hardware/Propagation.hpp"

namespace Hardware{
    template <class ExtensionContainer>
    void RemoveDuplicates(std::vector<ExtensionContainer>& extensions) {
        std::sort(extensions.begin(), extensions.end(), std::greater<ExtensionContainer>());
        extensions.erase(std::unique(extensions.begin(), extensions.end()), extensions.end());
    }

    template void RemoveDuplicates(std::vector<RobustProbe>&);

    template <class ExtensionContainer>
    Propagation<ExtensionContainer>::Propagation() {}
    template Propagation<RobustProbe>::Propagation();
    template Propagation<RelaxedProbe>::Propagation();

    template <>
    Propagation<RobustProbe>::Propagation(uint64_t signal_index) : signal_index_(signal_index) {}

    template <>
    Propagation<RelaxedProbe>::Propagation(uint64_t signal_index) : signal_index_(signal_index) {
      extension_indices_.resize(1);
      extension_indices_[0].number_of_enable_indices_ = 0;
      extension_indices_[0].number_of_signal_indices_ = 0;
    }

    template <class ExtensionContainer>
    Propagation<ExtensionContainer>::Propagation(uint64_t signal_index, std::vector<ExtensionContainer> extension_indies) : signal_index_(signal_index), extension_indices_(extension_indies) {}

    template Propagation<RobustProbe>::Propagation(uint64_t, std::vector<RobustProbe>);
    template Propagation<RelaxedProbe>::Propagation(uint64_t, std::vector<RelaxedProbe>);

    template <>
    Propagation<RelaxedProbe>::Propagation(uint64_t signal_index, uint64_t enable_index, uint64_t number_of_enable_indices, uint64_t number_of_signal_indices, std::vector<uint64_t> signal_indices, std::vector<uint64_t> propagation_indices) : signal_index_(signal_index) {
        extension_indices_.resize(1);
        extension_indices_[0].enable_index_ = enable_index;
        extension_indices_[0].number_of_enable_indices_ = number_of_enable_indices;
        extension_indices_[0].number_of_signal_indices_ = number_of_signal_indices;
        extension_indices_[0].signal_indices_ = signal_indices;
        extension_indices_[0].propagation_indices_ = propagation_indices;
    }

    template <>
    bool Propagation<RobustProbe>::operator==(const Propagation<RobustProbe>& other) const {
        return (signal_index_ == other.signal_index_) && (extension_indices_ == other.extension_indices_);
    }

    template <>
    bool Propagation<RelaxedProbe>::operator==(const Propagation<RelaxedProbe>& other) const {
        return (signal_index_ == other.signal_index_)  && (extension_indices_[0].enable_index_ == other.extension_indices_[0].enable_index_) &&
        (extension_indices_[0].number_of_enable_indices_ == other.extension_indices_[0].number_of_enable_indices_) && (extension_indices_[0].number_of_signal_indices_ == other.extension_indices_[0].number_of_signal_indices_) &&
        (extension_indices_[0].propagation_indices_ == other.extension_indices_[0].propagation_indices_) && (extension_indices_[0].signal_indices_ == other.extension_indices_[0].signal_indices_);
    }

    template <class ExtensionContainer>
    uint64_t Propagation<ExtensionContainer>::GetSignalIndex() {
        return signal_index_;
    }

    template uint64_t Propagation<RobustProbe>::GetSignalIndex();
    template uint64_t Propagation<RelaxedProbe>::GetSignalIndex();

    template <>
    std::vector<uint64_t> Propagation<RobustProbe>::GetExtensionIndices() {
        return extension_indices_;
    }

    template <>
    std::vector<uint64_t> Propagation<RelaxedProbe>::GetExtensionIndices(std::vector<Propagation>& propagations) {
        std::vector<uint64_t> result, indices, signal_indices;
        std::set<uint64_t> considered_indices;
        uint64_t index;

        indices.push_back(signal_index_);

        while(!indices.empty()){
            index = indices.back();
            indices.pop_back();

            std::vector<Propagation>::iterator it = std::lower_bound(propagations.begin(), propagations.end(), index, [](Propagation& propagation, uint64_t value) {
                return propagation.GetSignalIndex() < value;
            });

            if (it != propagations.end() && index == it->GetSignalIndex()) {
                index = std::distance(propagations.begin(), it);
            }else{
                throw std::out_of_range("Unable to find the propagation belonging to a signal! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
            }

            signal_indices = propagations[index].extension_indices_[0].signal_indices_;
            result.insert(result.end(), signal_indices.begin(), signal_indices.end());

            for (size_t propagation_index : propagations[index].extension_indices_[0].propagation_indices_){
                if (considered_indices.find(propagation_index) == considered_indices.end()){
                    indices.push_back(propagation_index);
                    considered_indices.insert(propagation_index);
                }
            }
        }

        std::sort(result.begin(), result.end());
        result.erase(std::unique(result.begin(), result.end()), result.end());
        return result;
    }

    template <>
    std::vector<uint64_t> Propagation<RelaxedProbe>::GetEnableIndices(std::vector<Propagation>& propagations) {
        std::vector<uint64_t> result, indices, signal_indices;
        std::set<uint64_t> considered_indices;
        uint64_t index;

        if (extension_indices_[0].number_of_enable_indices_){
            indices.push_back(signal_index_);
            result.push_back(extension_indices_[0].enable_index_);
        }

        while(!indices.empty()){
            index = indices.back();
            indices.pop_back();

            std::vector<Propagation>::iterator it = std::lower_bound(propagations.begin(), propagations.end(), index, [](Propagation& propagation, uint64_t value) {
                return propagation.GetSignalIndex() < value;
            });

            if (it != propagations.end() && index == it->GetSignalIndex()) {
                index = std::distance(propagations.begin(), it);
            }else{
                throw std::out_of_range("Unable to find the propagation belonging to a signal! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
            }

            if (propagations[index].extension_indices_[0].number_of_enable_indices_){
                if (std::find(result.begin(), result.end(), propagations[index].extension_indices_[0].enable_index_) == result.end()){
                    result.push_back(propagations[index].extension_indices_[0].enable_index_);
                }
            }

            for (size_t propagation_index : propagations[index].extension_indices_[0].propagation_indices_){
                if (considered_indices.find(propagation_index) == considered_indices.end()){
                    indices.push_back(propagation_index);
                    considered_indices.insert(propagation_index);
                }
            }
        }

        return result;
    }

    template <>
    uint64_t Propagation<RelaxedProbe>::GetEnableIndex() {
        return extension_indices_[0].enable_index_;
    }

    template <>
    std::vector<RobustProbe>& Propagation<RobustProbe>::GetExtensionContainer() {
        return extension_indices_;
    }

    template <>
    uint64_t Propagation<RelaxedProbe>::GetNumberOfEnableIndices(){
        return extension_indices_[0].number_of_enable_indices_;
    }

    template <>
    uint64_t Propagation<RelaxedProbe>::GetNumberOfSignalIndices(){
        return extension_indices_[0].number_of_signal_indices_;
    }

    template <>
    RelaxedProbe* Propagation<RelaxedProbe>::GetProbeAddress(uint64_t index){
        return &extension_indices_[index];
    }

    uint64_t BackpropagateUntilBranch(const CircuitStruct& circuit, uint64_t signal_index) {
        uint64_t result = signal_index;

        while ((circuit.Signals[result]->Output != -1) && (circuit.GetNumberOfInputsForSignalsComputingCell(result) == 1) && (circuit.Signals[result]->is_extension_allowed)){
            result = circuit.Cells[circuit.Signals[result]->Output]->Inputs[0];
        }

        return result;
    }

    template <>
    void Propagation<RobustProbe>::Propagate(const Library& library, const CircuitStruct& circuit, std::vector<Propagation>& propagations) {
        uint64_t index, input_index;

        if (circuit.Signals[signal_index_]->is_extension_allowed){
            for (index = 0; index < circuit.GetNumberOfInputsForSignalsComputingCell(signal_index_); ++index) {
                input_index = circuit.Cells[circuit.Signals[signal_index_]->Output]->Inputs[index];

                if (propagations[input_index].extension_indices_.empty()){
                    propagations[input_index].Propagate(library, circuit, propagations);
                }

                extension_indices_.insert(extension_indices_.end(), propagations[input_index].extension_indices_.begin(), propagations[input_index].extension_indices_.end());
            }

            std::sort(extension_indices_.begin(), extension_indices_.end());
            extension_indices_.erase(std::unique(extension_indices_.begin(), extension_indices_.end()), extension_indices_.end());
        }else{
            if (circuit.Signals[signal_index_]->is_analysis_allowed) {
                extension_indices_.push_back(signal_index_);
            }
        }
    }

    template <>
    void Propagation<RelaxedProbe>::Propagate(const Library& library, const CircuitStruct& circuit, std::vector<Propagation>& propagations) {
        uint64_t index, input_index;
        uint64_t signal_index = BackpropagateUntilBranch(circuit, signal_index_);

        if (circuit.Signals[signal_index]->is_extension_allowed){
            extension_indices_[0].enable_index_ = signal_index;
            ++extension_indices_[0].number_of_enable_indices_;

            for (index = 0; index < circuit.GetNumberOfInputsForSignalsComputingCell(signal_index); ++index) {
                input_index = circuit.Cells[circuit.Signals[signal_index]->Output]->Inputs[index];
                input_index = BackpropagateUntilBranch(circuit, input_index);

                if (propagations[input_index].extension_indices_[0].signal_indices_.empty()){
                    propagations[input_index].Propagate(library, circuit, propagations);
                }

                if (!propagations[input_index].extension_indices_[0].signal_indices_.empty()){
                    extension_indices_[0].number_of_enable_indices_ += propagations[input_index].extension_indices_[0].number_of_enable_indices_;
                    extension_indices_[0].number_of_signal_indices_ += propagations[input_index].extension_indices_[0].number_of_signal_indices_;
                    extension_indices_[0].propagation_indices_.push_back(input_index);
                }
            }
        }

        if (circuit.Signals[signal_index]->is_analysis_allowed) {
            extension_indices_[0].signal_indices_.push_back(signal_index);

            if (extension_indices_[0].number_of_signal_indices_ == 0){
                ++extension_indices_[0].number_of_signal_indices_;
            }
        }
    }

    template <>
    bool Propagation<RobustProbe>::IsObsolete(const CircuitStruct& circuit, const Settings& settings){
        uint64_t signal_index = GetSignalIndex();
        if (!circuit.Signals[signal_index]->is_probe_allowed) {
            return true;
        }

        if (extension_indices_.empty()) {
            return true;
        }

        if (settings.GetMinimization() != Minimization::none){
            for (int index = 0; index < circuit.Signals[signal_index]->NumberOfInputs; ++index) {
                if (circuit.Cells[circuit.Signals[signal_index]->Inputs[index]]->type->GetType() != cell_t::sequential){
                    return true;
                }
            }
        }

        return false;
    }

    template <>
    bool Propagation<RelaxedProbe>::IsObsolete(const CircuitStruct& circuit, const Settings& /*settings*/){
        uint64_t signal_index = GetSignalIndex();

        if (!extension_indices_[0].number_of_enable_indices_ && extension_indices_[0].propagation_indices_.empty() && !extension_indices_[0].number_of_signal_indices_) {
            return true;
        }

        if (circuit.Signals[signal_index]->Output != -1){
            if (circuit.Cells[circuit.Signals[signal_index]->Output]->type->GetNumberOfInputs() == 1){
                return true;
            }
        }

        return false;
    }

    template <>
    Propagation<RelaxedProbe> Propagation<RelaxedProbe>::ExtendWithTime(uint64_t clock_cycle, std::vector<Probe>& probes, std::vector<Enabler>& enabler) {
        Propagation<RelaxedProbe> propagation;
        std::vector<uint64_t> indices;
        Probe probe ({signal_index_}, clock_cycle);

        std::optional<uint64_t> probe_index = SearchProbe(probe, probes);

        propagation.signal_index_ = *probe_index;
        propagation.extension_indices_.resize(1);

        if (clock_cycle){
            propagation.extension_indices_[0].signal_indices_.resize(2);

            Probe probe2 ({extension_indices_[0].signal_indices_[0]}, clock_cycle - 1);
            probe_index = SearchProbe(probe2, probes);
            propagation.extension_indices_[0].signal_indices_[0] = *probe_index;

            Probe probe3 ({extension_indices_[0].signal_indices_[0]}, clock_cycle);
            probe_index = SearchProbe(probe3, probes);
            propagation.extension_indices_[0].signal_indices_[1] = *probe_index;
        }else{
            propagation.extension_indices_[0].signal_indices_.resize(1);
            Probe probe3 ({extension_indices_[0].signal_indices_[0]}, clock_cycle);
            probe_index = SearchProbe(probe3, probes);
            propagation.extension_indices_[0].signal_indices_[0] = *probe_index;
        }

        if (extension_indices_[0].number_of_enable_indices_){
            Probe probe4 ({extension_indices_[0].enable_index_}, clock_cycle);
            probe_index = SearchProbe(probe4, probes);
            propagation.extension_indices_[0].enable_index_ =  SearchEnabler(*probe_index, enabler);
        }

        propagation.extension_indices_[0].number_of_enable_indices_ = extension_indices_[0].number_of_enable_indices_;

        for (uint64_t propagation_index : extension_indices_[0].propagation_indices_){
            Probe probe5 ({propagation_index}, clock_cycle);
            probe_index = SearchProbe(probe5, probes);
            indices.push_back(*probe_index);
        }

        propagation.extension_indices_[0].propagation_indices_ = indices;

        return propagation;
    }

    template <>
    void Propagation<RelaxedProbe>::Finalize(std::vector<Propagation<RelaxedProbe>>& propagations) {
        std::vector<Propagation<RelaxedProbe>>::iterator it;

        for (uint64_t& index : extension_indices_[0].propagation_indices_){
            it = std::lower_bound(propagations.begin(), propagations.end(), index, [](Propagation<RelaxedProbe>& p, uint64_t signal_index) {
                return p.GetSignalIndex() < signal_index;
            });

            if (it != propagations.end() && it->GetSignalIndex() == index) {
                index = std::distance(propagations.begin(), it);
            } else {
                throw std::out_of_range("Unable to find the propagation belonging to a signal! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
            }
        }
    }

    template <>
    void Propagation<RelaxedProbe>::UpdateNumberOfSignals(std::vector<Propagation<RelaxedProbe>>& propagations) {
        extension_indices_[0].number_of_signal_indices_ = GetExtensionIndices(propagations).size();
        extension_indices_[0].number_of_enable_indices_ = GetEnableIndices(propagations).size();
    }
}
