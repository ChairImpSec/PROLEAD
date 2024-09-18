#include "Hardware/Simulate.hpp"

void Hardware::Simulate::All(const Hardware::Library &library, const Hardware::CircuitStruct &Circuit, const Settings &settings, SharedData& SharedData, std::vector<Probe>& extended_probes, std::vector<Enabler<CustomOperation>>& enabler, std::vector<size_t>& enabler_evaluation_order, Simulation &simulation, int SimulationIndex, boost::mt19937 &ThreadRng)
{
	uint64_t number_of_groups = settings.GetNumberOfGroups();
	uint64_t bit_index, group_index, input_index, share_index, signal_index, value_index;

	int i;
	int InputIndex;
	int OutputIndex;
	int RegIndex;
	int DepthIndex;
	int CellIndex;
	uint64_t Value;
	int NumberOfWaitedClockCycles;
	uint64_t Active;
	std::vector<uint64_t> Select(number_of_groups);
	std::string ErrorMessage;
	size_t probe_index = 0;
	unsigned int clock_cycle;
	std::vector<uint64_t> input_values;
	std::vector<std::unique_ptr<uint64_t[]>*> input_indices;

	// assigning inputs (fixed/random/etc)
	boost::uniform_int<uint64_t> ThreadDist(0, std::numeric_limits<uint64_t>::max());
	boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> ThreadPrng(ThreadRng, ThreadDist);

	Sharing input_sharing(settings.input_finite_field.base, settings.input_finite_field.exponent, settings.input_finite_field.irreducible_polynomial, ThreadRng);
	Sharing output_sharing(settings.output_finite_field.base, settings.output_finite_field.exponent, settings.output_finite_field.irreducible_polynomial, ThreadRng);
	uint64_t input_element_size = std::ceil(std::log2l(settings.input_finite_field.base)) * settings.input_finite_field.exponent;
	uint64_t output_element_size = std::ceil(std::log2l(settings.output_finite_field.base)) * settings.output_finite_field.exponent;
  	std::vector<uint64_t>::iterator it;
	std::vector<uint64_t> random_bitsliced_polynomial;

	for (group_index = 0; group_index < number_of_groups; ++group_index) {
		for (value_index = 0; value_index < settings.GetNumberOfBitsPerGroup() / input_element_size; value_index++) {
			random_bitsliced_polynomial = input_sharing.SampleRandomBitslicedPolynomial();
			std::move(random_bitsliced_polynomial.begin(), random_bitsliced_polynomial.end(), SharedData.group_values_[group_index].begin() + value_index * input_element_size);
		}
	}



	for (group_index = 0; group_index < number_of_groups; ++group_index) {
		for (value_index = 0; value_index < settings.GetNumberOfBitsPerGroup(); value_index++) {
			switch (settings.GetGroupBit(group_index, value_index))
			{
			case TriStateBit::zero_value:
				SharedData.group_values_[group_index][value_index] = 0x0000000000000000;
				break;
			case TriStateBit::one_value:
				SharedData.group_values_[group_index][value_index] = 0xffffffffffffffff;
				break;
			default:
				break;
			}
		}

		Select[group_index] = 0;
	}

	for (bit_index = 0; bit_index < 64; bit_index++) {
		simulation.selected_groups_[SimulationIndex * 64 + bit_index] = ThreadPrng() % number_of_groups;
		Select[simulation.selected_groups_[SimulationIndex * 64 + bit_index]] |= SharedData.one_in_64_[bit_index];
	}

	std::vector<uint64_t> bitsliced_element(input_element_size);

	for (auto& shared_value : SharedData.selected_group_values) {
		std::fill(bitsliced_element.begin(), bitsliced_element.end(), 0);
		for (bit_index = 0; bit_index < input_element_size; ++bit_index) {
			for (group_index = 0; group_index < number_of_groups; ++group_index){
				bitsliced_element[bit_index] |= SharedData.group_values_[group_index][shared_value.first[bit_index]] & Select[group_index];
			}
		}

		if (shared_value.second.size() > 1){
			shared_value.second = input_sharing.EncodeBitsliced(bitsliced_element, shared_value.second.size(), settings.input_finite_field.is_additive);
		} else{
			shared_value.second[0] = bitsliced_element;
		}
	}

	NumberOfWaitedClockCycles = -1;

	if (settings.IsWaveformSimulation()){
		Hardware::Simulate::GenerateVCDfile(Circuit, SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation", simulation.topmodule_name_);
	}

	for (clock_cycle = 0; clock_cycle < settings.GetNumberOfClockCycles(); clock_cycle++)
	{
		SharedData.signal_values_[simulation.clock_signal_index_] = FullOne;

		// ----------- evaluate the registers
		for (RegIndex = 0; RegIndex < Circuit.NumberOfRegs; RegIndex++)
		{
			input_values.resize(Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfInputs + Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs);

			for (InputIndex = 0; InputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfInputs; InputIndex++)
				input_values[InputIndex] = SharedData.signal_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->Inputs[InputIndex]];

			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
				input_values[Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfInputs + OutputIndex] = SharedData.register_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]];

			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
			{
				Value = library.Evaluate(Circuit.Cells[Circuit.Regs[RegIndex]]->Type, OutputIndex, input_values);
				if (!simulation.fault_set.empty()) {
					simulation.fault_set[0].TryToInduceFaults(Value, Circuit.Cells[Circuit.Regs[RegIndex]]->Outputs[OutputIndex], clock_cycle);
				}

				if (clock_cycle == 0)
					SharedData.register_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]] = 0;
				else
					SharedData.register_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]] = Value;
			}
		}

		// ----------- applying always random inputs
		for (const std::vector<uint64_t>& element : simulation.always_random_inputs_indices_){
			random_bitsliced_polynomial = input_sharing.SampleRandomBitslicedPolynomial();

			for (input_index = 0; input_index < input_element_size; ++input_index){
				SharedData.signal_values_[element[input_index]] = random_bitsliced_polynomial[input_index];
			}
		}

		// ----------- applying the initial inputs
		if (clock_cycle < SharedData.input_sequence_.size()){
			for (InputAssignment& input_assignment : SharedData.input_sequence_[clock_cycle]){
				if (input_assignment.signal_values_.empty()) {
					if (input_assignment.is_inverted_){
						for (input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
							SharedData.signal_values_[input_assignment.signal_indices_[input_index]] = ~SharedData.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
						}
					} else {
						for (input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
							SharedData.signal_values_[input_assignment.signal_indices_[input_index]] = SharedData.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
						}
					}
					// TODO: compute inversion under the correct galois field
				} else{
					for (input_index = 0; input_index < input_assignment.signal_values_.size(); ++input_index){
						switch (input_assignment.signal_values_[input_index])
						{
						case TriStateBit::zero_value:
							SharedData.signal_values_[input_assignment.signal_indices_[input_index]] = 0;
							break;
						case TriStateBit::one_value:
							SharedData.signal_values_[input_assignment.signal_indices_[input_index]] = FullOne;
							break;
						case TriStateBit::random_value:
							SharedData.signal_values_[input_assignment.signal_indices_[input_index]] = ThreadPrng();
							break;
						default:
							break;
						}
					}
				}
			}
		}

		// ----------- applying the register outputs to the output signals
		for (RegIndex = 0; RegIndex < Circuit.NumberOfRegs; RegIndex++)
		{
			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
				if (Circuit.Cells[Circuit.Regs[RegIndex]]->Outputs[OutputIndex] != -1)
					SharedData.signal_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->Outputs[OutputIndex]] = SharedData.register_values_[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]];
		}

		// ----------- evaluate the circuits :D

		for (DepthIndex = 1; DepthIndex <= Circuit.MaxDepth; DepthIndex++)
		{
			for (i = 0; i < Circuit.NumberOfCellsInDepth[DepthIndex]; i++)
			{
				CellIndex = Circuit.CellsInDepth[DepthIndex][i];

				input_values.resize(Circuit.Cells[CellIndex]->NumberOfInputs);

				for (InputIndex = 0; InputIndex < Circuit.Cells[CellIndex]->NumberOfInputs; InputIndex++)
					input_values[InputIndex] = SharedData.signal_values_[Circuit.Cells[CellIndex]->Inputs[InputIndex]];

				for (OutputIndex = 0; OutputIndex < Circuit.Cells[CellIndex]->NumberOfOutputs; OutputIndex++)
					if (Circuit.Cells[CellIndex]->Outputs[OutputIndex] != -1)
					{
						Value = library.Evaluate(Circuit.Cells[CellIndex]->Type, OutputIndex, input_values);
						if (!simulation.fault_set.empty()) {
							simulation.fault_set[0].TryToInduceFaults(Value, Circuit.Cells[CellIndex]->Outputs[OutputIndex], clock_cycle);
						}
						SharedData.signal_values_[Circuit.Cells[CellIndex]->Outputs[OutputIndex]] = Value;
					}
			}
		}

		SharedData.signal_values_[simulation.clock_signal_index_] = 0;

		// ----------- storing the probe values in simualtion memory
		while ((probe_index < extended_probes.size()) && (extended_probes[probe_index].GetCycle() < clock_cycle)){
			++probe_index;
		}

		while ((probe_index < extended_probes.size()) && (extended_probes[probe_index].GetCycle() == clock_cycle)){
			simulation.probe_values_[probe_index][SimulationIndex] = SharedData.signal_values_[extended_probes[probe_index].GetSignalIndex()];
			++probe_index;
		}

		// Here, we store the result during one clock cycle in a vcd file
		if (settings.IsWaveformSimulation()){
			Hardware::Simulate::WriteVCDfile(Circuit, simulation.clock_signal_index_, SharedData, SimulationIndex + simulation.number_of_processed_simulations / 64, clock_cycle, "simulation");
		}

		// ----------- check the conditions to terminate the simulation
		if (clock_cycle > settings.GetNumberOfClockCycles())
		{
			Active = 0;
			if (settings.GetEndConditionClockCycles())
				Active = (clock_cycle >= settings.GetEndConditionClockCycles()) ? 0 : FullOne;
			else
				for (std::pair<uint64_t, uint64_t>& end_condition_signal : simulation.end_condition_signals_) {
					Active |= SharedData.signal_values_[end_condition_signal.first] ^ end_condition_signal.second;
				}

			if (Active == 0)
			{
				if (NumberOfWaitedClockCycles == -1)
					NumberOfWaitedClockCycles = 0;
				else
					NumberOfWaitedClockCycles++;
			}

			if (NumberOfWaitedClockCycles == (int)settings.GetNumberOfWaitCycles())
			{
				// ClockCyclesTook = ClockCycle;
				break;
			}
			else if ((clock_cycle == (settings.GetNumberOfClockCycles() - 1)) && (NumberOfWaitedClockCycles < (int)settings.GetNumberOfWaitCycles()))
			{
				// ClockCyclesTook = ClockCycle + 1;
				break;
			}
		}
	}

	// evaluate the enabler
	for (size_t enabler_index : enabler_evaluation_order){

		input_indices = enabler[enabler_index].GetInputSignalIndices();
		input_values.resize(input_indices.size());

		for (signal_index = 0; signal_index < input_indices.size(); ++signal_index){
			input_values[signal_index] = (*(input_indices[signal_index]))[SimulationIndex];
		}

		if (enabler[enabler_index].CheckFunctions()){
			simulation.glitch_values_[enabler_index][SimulationIndex] = enabler[enabler_index].EvaluateGlitch(input_values);
			simulation.propagation_values_[enabler_index][SimulationIndex] = enabler[enabler_index].EvaluatePropagation(input_values);
		} else{
			simulation.glitch_values_[enabler_index][SimulationIndex] = 0xffffffffffffffff;
			simulation.propagation_values_[enabler_index][SimulationIndex] = 0xffffffffffffffff;
		}
	}

	if (settings.IsWaveformSimulation()){
		Hardware::Simulate::FinalizeVCDfile(settings.GetNumberOfClockCycles(), SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation");
	}

	uint64_t number_of_output_shares = simulation.output_share_signal_indices_.size();

	if (!simulation.fault_detection_flags_.empty()) {
		simulation.is_simulation_faulty_[SimulationIndex] = 0;
		for (std::pair<uint64_t, uint64_t>& fault_detection_flag : simulation.fault_detection_flags_) {
			simulation.is_simulation_faulty_[SimulationIndex] |= SharedData.signal_values_[fault_detection_flag.first] ^ fault_detection_flag.second;
		}
		simulation.is_simulation_faulty_[SimulationIndex] = ~simulation.is_simulation_faulty_[SimulationIndex];
	}

	if (number_of_output_shares) {
		uint64_t number_of_group_values = simulation.output_share_signal_indices_[0].size();
		std::vector<std::vector<uint64_t>> bitsliced_shared_output_value(number_of_output_shares, std::vector<uint64_t>(output_element_size));
		std::vector<uint64_t> bitsliced_unshared_output_value;
		std::vector<TriStateBit> expected_unshared_output_value;
		bitsliced_shared_output_value.resize(number_of_output_shares);

		for (value_index = 0; value_index < number_of_group_values; ++value_index) {
			for (share_index = 0; share_index < number_of_output_shares; ++share_index) {
				for (bit_index = 0; bit_index < output_element_size; ++bit_index) {
					bitsliced_shared_output_value[share_index][bit_index] = SharedData.signal_values_[simulation.output_share_signal_indices_[share_index][value_index][bit_index]];
				}
			}

			bitsliced_unshared_output_value = output_sharing.DecodeBitsliced(bitsliced_shared_output_value, settings.output_finite_field.is_additive);

			for (bit_index = 0; bit_index < 64; ++bit_index){
				if ((simulation.is_simulation_faulty_[SimulationIndex] & SharedData.one_in_64_[bit_index]) == 0){
					expected_unshared_output_value = simulation.expected_unshared_output_values_[simulation.selected_groups_[SimulationIndex * 64 + bit_index]][value_index];

					for (input_index = 0; input_index < expected_unshared_output_value.size(); ++ input_index){
						if (((expected_unshared_output_value[input_index] == TriStateBit::zero_value) && (bitsliced_unshared_output_value[input_index] & SharedData.one_in_64_[bit_index])) || ((expected_unshared_output_value[input_index] == TriStateBit::one_value) && ((bitsliced_unshared_output_value[input_index] & SharedData.one_in_64_[bit_index]) == 0))) {
							#pragma omp critical
							throw std::runtime_error("Error while simulating the circuit. The received output does not match the expected output!");
						}
					}
				}
			}
		}
	}
}

void Hardware::Simulate::GenerateVCDfile(const Hardware::CircuitStruct &Circuit, int SimulationIndex, std::string file_name, std::string topmodule_name)
{
	std::string SignalName;
	unsigned int BitIndex;

	for (BitIndex = 0; BitIndex < 64; BitIndex++){
		std::ofstream VCDFile(file_name + "_" + std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd");
		VCDFile << "$version \n PROLEAD \n$end \n$timescale \n 1ps \n$end" << std::endl;
		VCDFile << "$scope module " << topmodule_name << " $end\n" << std::endl;

		for (int SignalIndex = 0; SignalIndex < Circuit.NumberOfSignals; ++SignalIndex){
			SignalName = Circuit.Signals[SignalIndex]->Name;
			if (SignalName != "1'b0" && SignalName != "1'b1" && SignalName != "1'h0" && SignalName != "1'h1"){
				VCDFile << "$var wire 1 " << SignalName << " " << SignalName << " $end" << std::endl;
			}
		}

		VCDFile << "$upscope $end" << std::endl;
		VCDFile << "$enddefinitions $end" << std::endl;
		VCDFile.close();
	}
}

void Hardware::Simulate::WriteVCDfile(const Hardware::CircuitStruct &Circuit, uint64_t clock_signal_index, SharedData& SharedData, int SimulationIndex, int CycleIndex, std::string file_name) {
	uint64_t number_of_signals = Circuit.NumberOfSignals;
	uint64_t bit_index, signal_index;
	std::string signal_name;
	bool value;

	for (bit_index = 0; bit_index < 64; ++bit_index){
		std::ofstream VCDFile;
		VCDFile.open(file_name + "_" + std::to_string((SimulationIndex << 6) + bit_index) + ".vcd", std::ios_base::app);
		VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;

		for (signal_index = 0; signal_index < number_of_signals; ++signal_index){
			signal_name = Circuit.Signals[signal_index]->Name;

			if (signal_name != "1'b0" && signal_name != "1'b1" && signal_name != "1'h0" && signal_name != "1'h1"){
				if (signal_index == clock_signal_index){
					VCDFile << "1" << signal_name << std::endl;
				}else{
					value = (SharedData.signal_values_[signal_index] >> bit_index) & 0x1;
					VCDFile << value << signal_name << std::endl;
				}
			}
		}

		VCDFile << "#" << (2 * CycleIndex + 1) * 1000 << std::endl;
		VCDFile << "0" << Circuit.Signals[clock_signal_index]->Name << std::endl;
		VCDFile.close();
	}
}

void Hardware::Simulate::FinalizeVCDfile(int CycleIndex, int SimulationIndex, std::string file_name)
{
	for (unsigned int BitIndex = 0; BitIndex < 64; BitIndex++){
		std::ofstream VCDFile;
		VCDFile.open(file_name + "_" + std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd", std::ios_base::app);
		VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;
		VCDFile.close();
	}
}
