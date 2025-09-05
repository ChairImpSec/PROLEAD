#include "Hardware/Simulate.hpp"
#include <boost/log/trivial.hpp>

size_t count_faultable_hw{0};

void evaluateRegisterFaultFree(
  // const Library &library,
  const CircuitStruct &Circuit,
  // Simulation &simulation,
  SharedData &SharedData,
	std::vector<uint64_t> &input_values,
  size_t clock_cycle) {

	uint64_t Value;

  for (size_t RegIndex = 0; RegIndex < Circuit.regs_.size(); RegIndex++){
    input_values.resize(Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs() + Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs());

    for (size_t InputIndex = 0; InputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs(); InputIndex++){
      input_values[InputIndex] = SharedData.signal_values_[Circuit.cells_[Circuit.regs_[RegIndex]].Inputs[InputIndex]];
    }

    for (size_t OutputIndex = 0; OutputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs(); OutputIndex++){
      input_values[Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs() + OutputIndex] = SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]];
    }

    for (size_t OutputIndex = 0; OutputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs(); OutputIndex++){
      Value = Circuit.cells_[Circuit.regs_[RegIndex]].Eval(OutputIndex, input_values);

      if (clock_cycle == 0)
        SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]] = 0;
      else
        SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]] = Value;
    }
  }
}


void evaluateRegisterFaulted(
  // const Library &library,
  const CircuitStruct &Circuit,
  // Simulation &simulation,
  SharedData &SharedData,
	std::vector<uint64_t> &input_values,
  size_t clock_cycle,
  // const std::vector<FaultSet> &fault_sets,
  std::vector<std::vector<std::vector<FaultType>>> &fault_type){

	uint64_t Value;

  for (size_t RegIndex = 0; RegIndex < Circuit.regs_.size(); RegIndex++){
    input_values.resize(Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs() + Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs());

    for (size_t InputIndex = 0; InputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs(); InputIndex++){
      input_values[InputIndex] = SharedData.signal_values_[Circuit.cells_[Circuit.regs_[RegIndex]].Inputs[InputIndex]];
    }

    for (size_t OutputIndex = 0; OutputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs(); OutputIndex++){
      input_values[Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfInputs() + OutputIndex] = SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]];
    }

    for (size_t OutputIndex = 0; OutputIndex < Circuit.cells_[Circuit.regs_[RegIndex]].type->GetNumberOfOutputs(); OutputIndex++){
      if (clock_cycle == 0) {
			SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]] = 0;
      }else{
        Value = Circuit.cells_[Circuit.regs_[RegIndex]].Eval(OutputIndex, input_values);
        for (size_t fault_idx = 0; fault_idx < 64; ++fault_idx) {

          if (Circuit.cells_[Circuit.regs_[RegIndex]].Outputs[OutputIndex] != -1) {
            const FaultType ft = fault_type[fault_idx][Circuit.cells_[Circuit.regs_[RegIndex]].Outputs[OutputIndex]][clock_cycle];
            switch (ft) {
              case FaultType::stuck_at_0:
                Value &= ~(1ULL << fault_idx);
                break;
              case FaultType::stuck_at_1:
                Value |= (1ULL << fault_idx);
                break;
              case FaultType::toggle:
                Value ^= (1ULL << fault_idx);
                break;
              default:
                break;
            }
          }
        }
			  SharedData.register_values_[Circuit.cells_[Circuit.regs_[RegIndex]].RegValueIndexes[OutputIndex]] = Value;
      }
    }
  }
}

void applyAlwaysRandomInputs(
  Simulation &simulation,
  const Settings &settings,
	std::vector<uint64_t> &random_bitsliced_polynomial,
  uint64_t input_element_size,
  Sharing &input_sharing,
  SharedData &SharedData
) {

  std::vector<std::vector<uint64_t>>* always_random_inputs_indices;

 // ----------- applying always random inputs
    if (SharedData.signal_values_[simulation.clock_signal_index_]) {  // rising edge
      always_random_inputs_indices = &simulation.always_random_inputs_rising_edge_indices_;
    } else {  // falling edge
      always_random_inputs_indices = &simulation.always_random_inputs_falling_edge_indices_;
    }

    if (settings.input_finite_field.base == 2) {
      for (const std::vector<uint64_t>& element : *always_random_inputs_indices) {
        random_bitsliced_polynomial = input_sharing.SampleBooleanRandomBitslicedPolynomial();

        for (uint64_t in_idx = 0; in_idx < input_element_size; ++in_idx) {
          SharedData.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];
        }
      }
    } else {
      for (const std::vector<uint64_t>& element : *always_random_inputs_indices) {
        random_bitsliced_polynomial = input_sharing.SampleRandomBitslicedPolynomial();

        for (uint64_t in_idx = 0; in_idx < input_element_size; ++in_idx) {
          SharedData.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];
        }
      }
    }
}

void applyAlwaysRandomInputs(
  Simulation &simulation,
  const Settings &settings,
	std::vector<uint64_t> &random_bitsliced_polynomial,
  uint64_t input_element_size,
  Sharing &input_sharing,
  SharedData &shared_data,
  SharedData &shared_data_faulted
) {

  std::vector<std::vector<uint64_t>>* always_random_inputs_indices;

 // ----------- applying always random inputs
    if (shared_data.signal_values_[simulation.clock_signal_index_]) {  // rising edge
      always_random_inputs_indices = &simulation.always_random_inputs_rising_edge_indices_;
    } else {  // falling edge
      always_random_inputs_indices = &simulation.always_random_inputs_falling_edge_indices_;
    }

    if (settings.input_finite_field.base == 2) {
      for (const std::vector<uint64_t>& element : *always_random_inputs_indices) {
        random_bitsliced_polynomial = input_sharing.SampleBooleanRandomBitslicedPolynomial();

        for (uint64_t in_idx = 0; in_idx < input_element_size; ++in_idx) {
          shared_data.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];
          shared_data_faulted.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];

        }
      }
    } else {
      for (const std::vector<uint64_t>& element : *always_random_inputs_indices) {
        random_bitsliced_polynomial = input_sharing.SampleRandomBitslicedPolynomial();

        for (uint64_t in_idx = 0; in_idx < input_element_size; ++in_idx) {
          shared_data.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];
          shared_data_faulted.signal_values_[element[in_idx]] = random_bitsliced_polynomial[in_idx];
        }
      }
    }
}

void applyInitialInputs(SharedData &shared_data,
                        SharedData &shared_data_faulted,
	                      boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> &ThreadPrng,
                        size_t clock_cycle) {
  // TODO: this requres an if conditioned on the clock cylce,
  // the clock_cycle is selected in the outer most loop,
  // can we chose if this function is evaluated directly after the clock_cycle iterator is
  // increased.
  //
  // TODO: Use same inputs for both datastructures using pointers
  //
  // shared_data.inputs -> inputs <- shared_data_faulted.inputs
  //

  std::vector<uint64_t> input_values(64,0);
  if (clock_cycle < shared_data.input_sequence_.size()){
    for (InputAssignment& input_assignment : shared_data.input_sequence_[clock_cycle]){
      if (input_assignment.signal_values_.empty()) {
        if (input_assignment.is_inverted_){
          for (size_t input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = ~shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];

            shared_data_faulted.signal_values_[input_assignment.signal_indices_[input_index]] = ~shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
          }
        } else {
          for (size_t input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
            shared_data_faulted.signal_values_[input_assignment.signal_indices_[input_index]] = shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];

            auto signal =  shared_data.signal_values_[input_assignment.signal_indices_[input_index]];
            for (size_t i = 0; i < 64; ++i) {
              input_values[i] = input_values[i] << 1;
              input_values[i] = input_values[i] | (signal & 1);
              signal = signal >> 1;
            }
          }
        }
        // TODO: compute inversion under the correct galois field
      } else{
        for (size_t input_index = 0; input_index < input_assignment.signal_values_.size(); ++input_index){
          switch (input_assignment.signal_values_[input_index])
          {
          case vlog_bit_t::zero:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = 0;
            shared_data_faulted.signal_values_[input_assignment.signal_indices_[input_index]] = 0;
            break;
          case vlog_bit_t::one:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = FullOne;
            shared_data_faulted.signal_values_[input_assignment.signal_indices_[input_index]] = FullOne;
            break;
          case vlog_bit_t::random:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = ThreadPrng();
            shared_data_faulted.signal_values_[input_assignment.signal_indices_[input_index]] = ThreadPrng();
            break;
          default:
            break;
          }
        }
      }
    }
  }

  // size_t count_faultable_hw{0};
  // std::cout << "Signal" << std::endl;
  // std::cout << "I: ";
  // for (const auto & signal: input_values) {
  //   std::cout << signal <<", ";
  //   if(signal < 3){
  //     ++count_faultable_hw;
  //   }
  // }
  // std::cout << "(" << count_faultable_hw << ")" << std::endl;

}

void applyInitialInputs(SharedData &shared_data,
	                      boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> &ThreadPrng,
                        size_t clock_cycle) {
  // TODO: this requres an if conditioned on the clock cylce,
  // the clock_cycle is selected in the outer most loop,
  // can we chose if this function is evaluated directly after the clock_cycle iterator is
  // increased.
  //
  if (clock_cycle < shared_data.input_sequence_.size()){
    for (InputAssignment& input_assignment : shared_data.input_sequence_[clock_cycle]){
      if (input_assignment.signal_values_.empty()) {
        if (input_assignment.is_inverted_){
          for (size_t input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = ~shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
          }
        } else {
          for (size_t input_index = 0; input_index < input_assignment.signal_indices_.size(); ++input_index){
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = shared_data.selected_group_values[input_assignment.group_indices_][input_assignment.share_index_][input_index];
          }
        }
        // TODO: compute inversion under the correct galois field
      } else{
        for (size_t input_index = 0; input_index < input_assignment.signal_values_.size(); ++input_index){
          switch (input_assignment.signal_values_[input_index])
          {
          case vlog_bit_t::zero:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = 0;
            break;
          case vlog_bit_t::one:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = FullOne;
            break;
          case vlog_bit_t::random:
            shared_data.signal_values_[input_assignment.signal_indices_[input_index]] = ThreadPrng();
            break;
          default:
            break;
          }
        }
      }
    }
  }
}

void ForwardsRegOutputs(const CircuitStruct &circuit, SharedData &shared_data) {
  for (uint64_t reg_idx : circuit.regs_) {
    for (uint64_t out_idx = 0; out_idx < circuit.cells_[reg_idx].type->GetNumberOfOutputs(); ++out_idx) {
      if (circuit.cells_[reg_idx].Outputs[out_idx] != -1) {
        shared_data.signal_values_[circuit.cells_[reg_idx].Outputs[out_idx]] = shared_data.register_values_[circuit.cells_[reg_idx].RegValueIndexes[out_idx]];
      }
    }
  }
}


void EvaluteCircuitFaultFree(const CircuitStruct &circuit, Simulation &simulation, SharedData &shared_data, std::vector<uint64_t> &input_values, uint64_t clock_cycle) {
  uint64_t idx;
  uint64_t value;

  for (short depth_idx = 1; depth_idx <= circuit.MaxDepth; ++depth_idx) {
    for (int cell_idx = 0; cell_idx < circuit.NumberOfCellsInDepth[depth_idx]; ++cell_idx) {
      idx = circuit.CellsInDepth[depth_idx][cell_idx];

      if (!circuit.cells_[idx].type->IsLatch()) {
        input_values.resize(circuit.cells_[idx].type->GetNumberOfInputs());

        for (uint64_t in_idx = 0; in_idx < circuit.cells_[idx].type->GetNumberOfInputs(); ++in_idx){
          input_values[in_idx] = shared_data.signal_values_[circuit.cells_[idx].Inputs[in_idx]];
        }
      } else {
        input_values.resize(circuit.cells_[idx].type->GetNumberOfInputs() + circuit.cells_[idx].type->GetNumberOfOutputs());

        for (uint64_t in_idx = 0; in_idx < circuit.cells_[idx].type->GetNumberOfInputs(); ++in_idx){
          input_values[in_idx] = shared_data.signal_values_[circuit.cells_[idx].Inputs[in_idx]];
        }

        for (uint64_t out_idx = 0; out_idx < circuit.cells_[idx].type->GetNumberOfOutputs(); ++out_idx) {
          input_values[circuit.cells_[idx].type->GetNumberOfInputs() + out_idx] = shared_data.signal_values_[circuit.cells_[idx].Outputs[out_idx]];
        }
      }

      circuit.cells_[idx].Precomp(input_values);
      for (uint64_t out_idx = 0; out_idx < circuit.cells_[idx].type->GetNumberOfOutputs(); ++out_idx) {
        if (circuit.cells_[idx].Outputs[out_idx] != -1) {
          value = circuit.cells_[idx].Eval(out_idx, input_values);
          if (!simulation.fault_set_.empty()) {
            simulation.fault_set_[0].TryToInduceFaults(value, &circuit.signals_[circuit.cells_[idx].Outputs[out_idx]], clock_cycle);
          }
          shared_data.signal_values_[circuit.cells_[idx].Outputs[out_idx]] = value;
        }
      }
    }
  }
}

void EvaluteCircuitFaulted(
  // const Library &library,
  const CircuitStruct &Circuit,
  // Simulation &simulation,
  SharedData &SharedData,
	std::vector<uint64_t> &input_values,
	unsigned int clock_cycle,
  // const std::vector<FaultSet>& fault_sets,
  std::vector<std::vector<std::vector<FaultType>>> &fault_type) {

	uint64_t Value;

  for (short DepthIndex = 1; DepthIndex <= Circuit.MaxDepth; DepthIndex++) {
    for (int i = 0; i < Circuit.NumberOfCellsInDepth[DepthIndex]; i++) {
      int CellIndex = Circuit.CellsInDepth[DepthIndex][i]; // TODO: int -> size_t

      input_values.resize(Circuit.cells_[CellIndex].type->GetNumberOfInputs());

      for (size_t InputIndex = 0; InputIndex < Circuit.cells_[CellIndex].type->GetNumberOfInputs(); InputIndex++){
        input_values[InputIndex] = SharedData.signal_values_[Circuit.cells_[CellIndex].Inputs[InputIndex]];
      }

      for (size_t OutputIndex = 0; OutputIndex < Circuit.cells_[CellIndex].type->GetNumberOfOutputs(); OutputIndex++){

        if (Circuit.cells_[CellIndex].Outputs[OutputIndex] != -1){
          Value = Circuit.cells_[CellIndex].Eval(OutputIndex, input_values);
          for(size_t fault_idx = 0; fault_idx < 64; ++fault_idx){
            const FaultType ft = fault_type[fault_idx][Circuit.cells_[CellIndex].Outputs[OutputIndex]][clock_cycle];
            switch (ft) {
              case FaultType::stuck_at_0:
                Value &= ~(1ULL << fault_idx);
                break;
              case FaultType::stuck_at_1:
                Value |= (1ULL << fault_idx);
                break;
              case FaultType::toggle:
                Value ^= (1ULL << fault_idx);
                break;
              default:
                break;
            }
          }

          SharedData.signal_values_[Circuit.cells_[CellIndex].Outputs[OutputIndex]] = Value;
        }
      }
    }
  }
}

void EvalEnabler(std::vector<Enabler> &enablers, uint64_t step_idx) {
  for (Enabler& enabler : enablers) {
    enabler.EvalGlitch(step_idx);
    enabler.EvalPropagation(step_idx);
  }
}

void InitGroupValues(const Settings &settings, SharedData &shared_data, Sharing &input_sharing,uint64_t input_element_size, uint64_t number_of_groups) {

    std::vector<uint64_t>::iterator it;
    std::vector<uint64_t> random_bitsliced_polynomial;
  	for (size_t group_index = 0; group_index < number_of_groups; ++group_index) {
  		for (size_t value_index = 0; value_index < settings.GetNumberOfBitsPerGroup() / input_element_size; value_index++){

        if(shared_data.group_values_.size() <= group_index){
          throw std::runtime_error("Error 1 group_index" + std::to_string(group_index) + "size()" + std::to_string(shared_data.group_values_.size()));
        }
        if(shared_data.group_values_[group_index].size() <= value_index * input_element_size){
          throw std::runtime_error("Error 2");
        }

        it = shared_data.group_values_[group_index].begin() + value_index * input_element_size;
	      random_bitsliced_polynomial = input_sharing.SampleRandomBitslicedPolynomial();

        if(random_bitsliced_polynomial.empty()){
          throw std::runtime_error("Error 3");
        }

			  std::move(random_bitsliced_polynomial.begin(), random_bitsliced_polynomial.end(), shared_data.group_values_[group_index].begin() + value_index * input_element_size);
  		}
  	}

  	for (size_t group_index = 0; group_index < number_of_groups; ++group_index) {
  		for (size_t value_index = 0; value_index < settings.GetNumberOfBitsPerGroup(); value_index++) {
  			switch (settings.GetGroupBit(group_index, value_index))
  			{
  			case vlog_bit_t::zero:
  				shared_data.group_values_[group_index][value_index] = 0x0000000000000000;
  				break;
  			case vlog_bit_t::one:
  				shared_data.group_values_[group_index][value_index] = 0xffffffffffffffff;
  				break;
  			default:
  				break;
  			}
  		}
  	}
}


void SelectGroupThreaded(boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> thread_prng, const SharedData &shared_data, std::vector<uint64_t> &select, Simulation &simulation, int simulation_index, uint64_t number_of_groups ) {
  //  simulation.selected_groups_ probably needed per thread

  for (size_t group_index = 0; group_index < number_of_groups; ++group_index) {
    select[group_index] = 0;
  }

  for (size_t bit_index = 0; bit_index < 64; bit_index++) {
    simulation.selected_groups_[simulation_index * 64 + bit_index] = thread_prng() % number_of_groups;
    select[simulation.selected_groups_[simulation_index * 64 + bit_index]] |= shared_data.one_in_64_[bit_index];
  }
}


void SelectGroup(boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> thread_prng, const SharedData &shared_data, std::vector<uint64_t> &select, Simulation &simulation, int simulation_index, uint64_t number_of_groups) {
  //  simulation.selected_groups_ probably needed per thread

  for (size_t group_index = 0; group_index < number_of_groups; ++group_index) {
    select[group_index] = 0;
  }

  for (size_t bit_index = 0; bit_index < 64; bit_index++) {
    simulation.selected_groups_[simulation_index * 64 + bit_index] = thread_prng() % number_of_groups;
    select[simulation.selected_groups_[simulation_index * 64 + bit_index]] |= shared_data.one_in_64_[bit_index];
  }
}


void ShareAndBitslice(SharedData &shared_data, Sharing &input_sharing, const std::vector<uint64_t> &select, const Settings &settings, uint64_t input_element_size, uint64_t number_of_groups) {

	std::vector<uint64_t> bitsliced_element(input_element_size);

  for (auto& shared_value : shared_data.selected_group_values) {
    for (size_t bit_index = 0; bit_index < input_element_size; ++bit_index) {
      bitsliced_element[bit_index] = 0;

      for (size_t group_index = 0; group_index < number_of_groups; ++group_index){
        bitsliced_element[bit_index] |= shared_data.group_values_[group_index][shared_value.first[bit_index]] & select[group_index];
      }
    }

    if (shared_value.second.size() > 1){
      shared_value.second = input_sharing.EncodeBitsliced(bitsliced_element, shared_value.second.size(), settings.input_finite_field.is_additive);
    } else{
      shared_value.second[0] = bitsliced_element;
    }
  }

}

void CheckFunctionalCorrectness(const Settings &settings, const Simulation &simulation,
                                const SharedData& shared_data, Sharing &output_sharing,
                                int SimulationIndex, uint64_t output_element_size) {

  uint64_t number_of_output_shares = simulation.output_share_signal_indices_.size(); // 3
  if (number_of_output_shares) {
    uint64_t number_of_group_values = simulation.output_share_signal_indices_[0].size(); // 4
    std::vector<std::vector<uint64_t>> bitsliced_shared_output_value(number_of_output_shares, std::vector<uint64_t>(output_element_size));
    std::vector<uint64_t> bitsliced_unshared_output_value;
    std::vector<vlog_bit_t> expected_unshared_output_value;
    bitsliced_shared_output_value.resize(number_of_output_shares);

    for (size_t value_index = 0; value_index < number_of_group_values; ++value_index) {
      for (size_t share_index = 0; share_index < number_of_output_shares; ++share_index) {
        for (size_t bit_index = 0; bit_index < output_element_size; ++bit_index) {
          bitsliced_shared_output_value[share_index][bit_index] = shared_data.signal_values_[simulation.output_share_signal_indices_[share_index][value_index][bit_index]];
        }
      }

      bitsliced_unshared_output_value = output_sharing.DecodeBitsliced(bitsliced_shared_output_value, settings.output_finite_field.is_additive);

      for (size_t bit_index = 0; bit_index < 64; ++bit_index){
        if ((simulation.is_simulation_faulty_[SimulationIndex] & shared_data.one_in_64_[bit_index]) == 0){
          expected_unshared_output_value = simulation.expected_unshared_output_values_[simulation.selected_groups_[SimulationIndex * 64 + bit_index]][value_index];

          for (size_t input_index = 0; input_index < expected_unshared_output_value.size(); ++ input_index){
            if (
              ((expected_unshared_output_value[input_index] == vlog_bit_t::zero) && (bitsliced_unshared_output_value[input_index] & shared_data.one_in_64_[bit_index]))
              || ((expected_unshared_output_value[input_index] == vlog_bit_t::one) && ((bitsliced_unshared_output_value[input_index] & shared_data.one_in_64_[bit_index]) == 0))
            ) {
              int out{0};
              if(expected_unshared_output_value[input_index] == vlog_bit_t::zero){
                out = 0;
              }else if (expected_unshared_output_value[input_index] == vlog_bit_t::one) {
                out = 1;
              }
              else {
                out = 1000;
              }
              std::cout << "Error in:\n\t bit_index " << bit_index <<
                "\n\tValue inde " << value_index <<
                "\n\tinput_index" << input_index <<
                 "\n\tExpected output value " << out <<
                 "\n\tOutput value " <<
                (bitsliced_unshared_output_value[input_index] & shared_data.one_in_64_[bit_index]) <<
                std::endl;
                #pragma omp critical
                throw std::runtime_error("Error while simulating the circuit. The received output does not match the expected output!");
            }
          }
        }
      }
    }
  }
}

void CheckCorrectness(const Settings &settings, const Simulation &simulation, const SharedData& shared_data, Sharing &output_sharing, int SimulationIndex, uint64_t output_element_size) {
  uint64_t number_of_output_shares = simulation.output_share_signal_indices_.size();

  if (number_of_output_shares && !simulation.expected_unshared_output_values_.empty() ) {
    uint64_t number_of_group_values = simulation.output_share_signal_indices_[0].size();
    std::vector<std::vector<uint64_t>> bitsliced_shared_output_value(number_of_output_shares, std::vector<uint64_t>(output_element_size));
    std::vector<uint64_t> bitsliced_output_value;
    std::vector<vlog_bit_t> expected_output_value;
    bitsliced_shared_output_value.resize(number_of_output_shares);

    for (uint64_t val_idx = 0; val_idx < number_of_group_values; ++val_idx) {
      for (uint64_t share_idx = 0; share_idx < number_of_output_shares; ++share_idx) {
        for (uint64_t bit_idx = 0; bit_idx < output_element_size; ++bit_idx) {
          bitsliced_shared_output_value[share_idx][bit_idx] = shared_data.signal_values_[simulation.output_share_signal_indices_[share_idx][val_idx][bit_idx]];
        }
      }

      bitsliced_output_value = output_sharing.DecodeBitsliced(bitsliced_shared_output_value, settings.output_finite_field.is_additive);

      for (uint64_t bit_idx = 0; bit_idx < 64; ++bit_idx){
        if ((simulation.is_simulation_faulty_[SimulationIndex] & shared_data.one_in_64_[bit_idx]) == 0){
          expected_output_value = simulation.expected_unshared_output_values_[simulation.selected_groups_[SimulationIndex * 64 + bit_idx]][val_idx];

          for (uint64_t in_idx = 0; in_idx < expected_output_value.size(); ++ in_idx){
            if (
              ((expected_output_value[in_idx] == vlog_bit_t::zero) && (bitsliced_output_value[in_idx] & shared_data.one_in_64_[bit_idx]))
              || ((expected_output_value[in_idx] == vlog_bit_t::one) && ((bitsliced_output_value[in_idx] & shared_data.one_in_64_[bit_idx]) == 0))
            ) {
              uint64_t out{0};
              if(expected_output_value[in_idx] == vlog_bit_t::zero){
                out = 0;
              }else if (expected_output_value[in_idx] == vlog_bit_t::one) {
                out = 1;
              }
              else {
                out = 1000;
              }
              std::cout << "Error in:\n\t bit_index " << bit_idx <<
                "\n\tValue inde " << val_idx <<
                "\n\tinput_index" << in_idx <<
                 "\n\tExpected output value " << out <<
                 "\n\tOutput value " <<
                (bitsliced_output_value[in_idx] & shared_data.one_in_64_[bit_idx]) <<
                std::endl;
                #pragma omp critical
                throw std::runtime_error("Error while simulating the circuit. The received output does not match the expected output!");
            }
          }
        }
      }
    }
  }
}

Simulation::Simulation(CircuitStruct& circuit, Settings& settings) {
  uint64_t index, signal_index, signal_value;
  std::string fresh_mask_signal_names;

  number_of_clock_cycles_ = settings.GetNumberOfClockCycles();
  number_of_processed_simulations = 0;
  selected_groups_.resize(settings.GetNumberOfSimulationsPerStep());

  clock_signal_index_ =
      circuit.GetSignalIndexByName(settings.GetClockSignalName());

  always_random_inputs_rising_edge_indices_.resize(
      settings.GetNumberOfAlwaysRandomInputSignalsRisingEdge());
  for (index = 0;
       index < settings.GetNumberOfAlwaysRandomInputSignalsRisingEdge();
       ++index) {
    fresh_mask_signal_names += "{";
    for (const std::string& signal_name :
         settings.GetAlwaysRandomInputRisingEdgeElement(index)) {
      signal_index = circuit.GetSignalIndexByName(signal_name);
      always_random_inputs_rising_edge_indices_[index].push_back(signal_index);
      fresh_mask_signal_names += signal_name + ", ";
    }

    if (fresh_mask_signal_names.length() > 2) {
      fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
    }

    fresh_mask_signal_names += "}, ";
  }

  if (fresh_mask_signal_names.length() > 2) {
    fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
    BOOST_LOG_TRIVIAL(info) << "Successfully matched "
              << always_random_inputs_rising_edge_indices_.size()
              << " fresh mask signals (for rising edge) ["
              << fresh_mask_signal_names << "]." << std::endl;
  }

  fresh_mask_signal_names.clear();

  always_random_inputs_falling_edge_indices_.resize(
      settings.GetNumberOfAlwaysRandomInputSignalsFallingEdge());
  for (index = 0;
       index < settings.GetNumberOfAlwaysRandomInputSignalsFallingEdge();
       ++index) {
    fresh_mask_signal_names += "{";
    for (const std::string& signal_name :
         settings.GetAlwaysRandomInputFallingEdgeElement(index)) {
      signal_index = circuit.GetSignalIndexByName(signal_name);
      always_random_inputs_falling_edge_indices_[index].push_back(signal_index);
      fresh_mask_signal_names += signal_name + ", ";
    }

    if (fresh_mask_signal_names.length() > 2) {
      fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
    }

    fresh_mask_signal_names += "}, ";
  }

  if (fresh_mask_signal_names.length() > 2) {
    fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
    BOOST_LOG_TRIVIAL(info) << "Successfully matched "
              << always_random_inputs_falling_edge_indices_.size()
              << " fresh mask signals (for falling edge) ["
              << fresh_mask_signal_names << "].";
  }

  for (const std::pair<std::string, bool>& end_condition_signal :
       settings.GetEndConditionSignalValuePairs()) {
    signal_index = circuit.GetSignalIndexByName(end_condition_signal.first);
    signal_value =
        end_condition_signal.second ? 0xffffffffffffffff : 0x0000000000000000;
    end_condition_signals_.emplace_back(signal_index, signal_value);
  }

  for (const std::pair<std::string, bool>& fault_detection_flag :
       settings.GetFaultDetectionSignalValuePairs()) {
    signal_index = circuit.GetSignalIndexByName(fault_detection_flag.first);
    signal_value =
        fault_detection_flag.second ? 0xffffffffffffffff : 0x0000000000000000;
    fault_detection_flags_.emplace_back(signal_index, signal_value);
  }

  output_share_signal_indices_.resize(settings.GetNumberOfOutputShares());

  uint64_t number_of_values, number_of_bits;

  for (uint64_t share_index = 0;
       share_index < settings.GetNumberOfOutputShares(); ++share_index) {
    number_of_bits = std::ceil(std::log2l(settings.output_finite_field.base)) *
                     settings.output_finite_field.exponent;
    number_of_values =
        settings.GetNumberOfBitsPerOutputShare() / number_of_bits;
    output_share_signal_indices_[share_index].resize(number_of_values);

    for (uint64_t value_index = 0; value_index < number_of_values;
         ++value_index) {
      for (uint64_t bit_index = 0; bit_index < number_of_bits; ++bit_index) {
        output_share_signal_indices_[share_index][value_index].push_back(
            circuit.GetSignalIndexByName(settings.GetOutputShareName(
                share_index, value_index * number_of_bits + bit_index)));
      }
    }
  }

  if (settings.GetNumberOfExpectedOutputs() != 0 &&
      settings.GetNumberOfOutputShares() != 0) {
    expected_unshared_output_values_.resize(settings.GetNumberOfGroups());
    for (uint64_t share_index = 0; share_index < settings.GetNumberOfGroups();
         ++share_index) {
      number_of_bits =
          std::ceil(std::log2l(settings.output_finite_field.base)) *
          settings.output_finite_field.exponent;
      number_of_values =
          settings.GetNumberOfBitsPerOutputShare() / number_of_bits;
      expected_unshared_output_values_[share_index].resize(number_of_values);

      for (uint64_t value_index = 0; value_index < number_of_values;
           ++value_index) {
        for (uint64_t bit_index = 0; bit_index < number_of_bits; ++bit_index) {
          expected_unshared_output_values_[share_index][value_index].push_back(
              settings.GetExpectedOutputBit(
                  share_index, value_index * number_of_bits + bit_index));
        }
      }
    }
  }
}

void Hardware::Simulate::All(const CircuitStruct& Circuit,
                             const Settings& settings, SharedData& SharedData,
                             std::vector<const Probe*>& extensions,
                             std::vector<Enabler>& enabler,
                             Simulation& simulation, int SimulationIndex,
                             boost::mt19937& ThreadRng) {
  uint64_t number_of_groups = settings.GetNumberOfGroups();
  uint64_t bit_index, group_index, input_index, value_index;

  int i;
  int InputIndex;
  int OutputIndex;
  int DepthIndex;
  int CellIndex;
  uint64_t Value;
  int NumberOfWaitedClockCycles;
  uint64_t Active;
  std::vector<uint64_t> Select(number_of_groups);
  std::string ErrorMessage;
  uint64_t probe_index = 0;
  unsigned int clock_cycle;
  std::vector<uint64_t> input_values;
  std::vector<std::unique_ptr<uint64_t[]>*> input_indices;
  std::vector<uint64_t> temp_signal_values_;

  // assigning inputs (fixed/random/etc)
  boost::uniform_int<uint64_t> ThreadDist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>>
      ThreadPrng(ThreadRng, ThreadDist);

  Sharing input_sharing(
      settings.input_finite_field.base, settings.input_finite_field.exponent,
      settings.input_finite_field.irreducible_polynomial, ThreadRng);
  Sharing output_sharing(
      settings.output_finite_field.base, settings.output_finite_field.exponent,
      settings.output_finite_field.irreducible_polynomial, ThreadRng);
  uint64_t input_element_size =
      std::ceil(std::log2l(settings.input_finite_field.base)) *
      settings.input_finite_field.exponent;
  uint64_t output_element_size =
      std::ceil(std::log2l(settings.output_finite_field.base)) *
      settings.output_finite_field.exponent;
  std::vector<uint64_t>::iterator it;
  std::vector<uint64_t> random_bitsliced_polynomial;
  std::vector<std::vector<uint64_t>>* always_random_inputs_indices_;

  if (settings.input_finite_field.base == 2) {
    for (group_index = 0; group_index < number_of_groups; ++group_index) {
      for (value_index = 0; value_index < settings.GetNumberOfBitsPerGroup() /
                                              input_element_size;
           value_index++) {
        random_bitsliced_polynomial =
            input_sharing.SampleBooleanRandomBitslicedPolynomial();
        std::move(random_bitsliced_polynomial.begin(),
                  random_bitsliced_polynomial.end(),
                  SharedData.group_values_[group_index].begin() +
                      value_index * input_element_size);
      }
    }
  } else {
    for (group_index = 0; group_index < number_of_groups; ++group_index) {
      for (value_index = 0; value_index < settings.GetNumberOfBitsPerGroup() /
                                              input_element_size;
           value_index++) {
        random_bitsliced_polynomial =
            input_sharing.SampleRandomBitslicedPolynomial();
        std::move(random_bitsliced_polynomial.begin(),
                  random_bitsliced_polynomial.end(),
                  SharedData.group_values_[group_index].begin() +
                      value_index * input_element_size);
      }
    }
  }

  for (group_index = 0; group_index < number_of_groups; ++group_index) {
    for (value_index = 0; value_index < settings.GetNumberOfBitsPerGroup();
         value_index++) {
      switch (settings.GetGroupBit(group_index, value_index)) {
        case vlog_bit_t::zero:
          SharedData.group_values_[group_index][value_index] =
              0x0000000000000000;
          break;
        case vlog_bit_t::one:
          SharedData.group_values_[group_index][value_index] =
              0xffffffffffffffff;
          break;
        default:
          break;
      }
    }

    Select[group_index] = 0;
  }

  for (bit_index = 0; bit_index < 64; bit_index++) {
    simulation.selected_groups_[SimulationIndex * 64 + bit_index] =
        ThreadPrng() % number_of_groups;
    Select[simulation.selected_groups_[SimulationIndex * 64 + bit_index]] |=
        SharedData.one_in_64_[bit_index];
  }

  std::vector<uint64_t> bitsliced_element(input_element_size);

  if (settings.side_channel_analysis.notion == sca_notion_t::ps) { // Mode for probing security set unshared x
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
  } else { // Mode for composability set Sh(x)
    for (auto& shared_value : SharedData.selected_group_values) {
      for (value_index = 0; value_index < shared_value.second.size(); ++value_index) {
        std::fill(shared_value.second[value_index].begin(), shared_value.second[value_index].end(), 0);

        for (bit_index = 0; bit_index < input_element_size; ++bit_index) {
          for (group_index = 0; group_index < number_of_groups; ++group_index){
            if (settings.IsInGroupMapping(value_index, shared_value.first[bit_index])) {
              shared_value.second[value_index][bit_index] |= SharedData.group_values_[group_index][settings.GetGroupMapping(value_index, shared_value.first[bit_index])] & Select[group_index];
            }else{
              shared_value.second[value_index][bit_index] |= SharedData.group_values_[group_index][settings.GetGroupMappingWithOneShare(shared_value.first[bit_index])] & Select[group_index];
            }
          }
        }				
      }
    }		
  }

  NumberOfWaitedClockCycles = -1;

  if (settings.IsWaveformSimulation()) {
    Hardware::Simulate::GenerateVCDfile(
        Circuit,
        SimulationIndex + simulation.number_of_processed_simulations / 64,
        "simulation", simulation.topmodule_name_);
  }

  if (settings.GetClkEdge() == clk_edge_t::rising)
    SharedData.signal_values_[simulation.clock_signal_index_] = 0;
  else if (settings.GetClkEdge() == clk_edge_t::falling)
    SharedData.signal_values_[simulation.clock_signal_index_] = FullOne;

  for (clock_cycle = 0; clock_cycle < settings.GetNumberOfClockCycles();
       clock_cycle++) {
    temp_signal_values_ = SharedData.signal_values_;

    if (settings.GetClkEdge() == clk_edge_t::rising)
      temp_signal_values_[simulation.clock_signal_index_] = FullOne;
    else if (settings.GetClkEdge() == clk_edge_t::falling)
      temp_signal_values_[simulation.clock_signal_index_] = 0;
    else  // if (settings.GetClkEdge() == clk_edge_t::falling)
    {
      if (clock_cycle & 1)
        temp_signal_values_[simulation.clock_signal_index_] = FullOne;
      else
        temp_signal_values_[simulation.clock_signal_index_] = 0;
    }

    // ----------- evaluate the combinational circuit providing the clock of
    // registers

    for (DepthIndex = 1; DepthIndex <= Circuit.MaxDepth; DepthIndex++) {
      for (i = 0; i < Circuit.NumberOfClockCellsInDepth[DepthIndex]; i++) {
        CellIndex = Circuit.ClockCellsInDepth[DepthIndex][i];

        if (!Circuit.cells_[CellIndex].type->IsLatch()) {
          input_values.resize(
              Circuit.cells_[CellIndex].type->GetNumberOfInputs());

          for (InputIndex = 0;
               InputIndex <
               (int)Circuit.cells_[CellIndex].type->GetNumberOfInputs();
               InputIndex++)
            input_values[InputIndex] =
                temp_signal_values_[Circuit.cells_[CellIndex]
                                        .Inputs[InputIndex]];
        } else {
          input_values.resize(
              Circuit.cells_[CellIndex].type->GetNumberOfInputs() +
              Circuit.cells_[CellIndex].type->GetNumberOfOutputs());

          for (InputIndex = 0;
               InputIndex <
               (int)Circuit.cells_[CellIndex].type->GetNumberOfInputs();
               InputIndex++)
            input_values[InputIndex] =
                temp_signal_values_[Circuit.cells_[CellIndex]
                                        .Inputs[InputIndex]];

          for (OutputIndex = 0;
               OutputIndex <
               (int)Circuit.cells_[CellIndex].type->GetNumberOfOutputs();
               OutputIndex++)
            input_values[Circuit.cells_[CellIndex].type->GetNumberOfInputs() +
                         OutputIndex] =
                temp_signal_values_[Circuit.cells_[CellIndex]
                                        .Outputs[OutputIndex]];
        }

        Circuit.cells_[CellIndex].Precomp(input_values);
        for (OutputIndex = 0;
             OutputIndex <
             (int)Circuit.cells_[CellIndex].type->GetNumberOfOutputs();
             OutputIndex++)
          if (Circuit.cells_[CellIndex].Outputs[OutputIndex] != -1) {
            Value = Circuit.cells_[CellIndex].Eval(OutputIndex, input_values);
            if (!simulation.fault_set_.empty()) {
              simulation.fault_set_[0].TryToInduceFaults(
                  Value, &Circuit.signals_[Circuit.cells_[CellIndex].Outputs[OutputIndex]],
                  clock_cycle);
            }
            temp_signal_values_[Circuit.cells_[CellIndex]
                                    .Outputs[OutputIndex]] = Value;
          }
      }
    }

    // ----------- evaluate the registers
    for (uint64_t reg_idx : Circuit.regs_) {
      input_values.resize(Circuit.cells_[reg_idx].type->GetNumberOfInputs() +
                          Circuit.cells_[reg_idx].type->GetNumberOfOutputs());

      for (InputIndex = 0;
           InputIndex < (int)Circuit.cells_[reg_idx].type->GetNumberOfInputs();
           InputIndex++) {
        input_values[InputIndex] =
            SharedData
                .signal_values_[Circuit.cells_[reg_idx].Inputs[InputIndex]];
      }

      InputIndex = *Circuit.cells_[reg_idx].type->GetClock();

      switch (Circuit.cells_[reg_idx].type->GetClkEdge()) {
        case clk_edge_t::rising:
          input_values[InputIndex] = ~input_values[InputIndex];
          input_values[InputIndex] &=
              temp_signal_values_[Circuit.cells_[reg_idx].Inputs[InputIndex]];
          break;
        case clk_edge_t::falling:
          input_values[InputIndex] = ~input_values[InputIndex];
          input_values[InputIndex] |=
              temp_signal_values_[Circuit.cells_[reg_idx].Inputs[InputIndex]];
          break;
        default:
          input_values[InputIndex] ^=
              temp_signal_values_[Circuit.cells_[reg_idx].Inputs[InputIndex]];
          break;
      }

      for (OutputIndex = 0;
           OutputIndex <
           (int)Circuit.cells_[reg_idx].type->GetNumberOfOutputs();
           OutputIndex++)
        input_values[Circuit.cells_[reg_idx].type->GetNumberOfInputs() +
                     OutputIndex] =
            SharedData.register_values_[Circuit.cells_[reg_idx]
                                            .RegValueIndexes[OutputIndex]];

      Circuit.cells_[reg_idx].Precomp(input_values);
      for (OutputIndex = 0;
           OutputIndex <
           (int)Circuit.cells_[reg_idx].type->GetNumberOfOutputs();
           OutputIndex++) {
        Value = Circuit.cells_[reg_idx].Eval(OutputIndex, input_values);
        if (!simulation.fault_set_.empty()) {
          simulation.fault_set_[0].TryToInduceFaults(
              Value, &Circuit.signals_[Circuit.cells_[reg_idx].Outputs[OutputIndex]], clock_cycle);
        }

        if (clock_cycle == 0)
          SharedData.register_values_[Circuit.cells_[reg_idx]
                                          .RegValueIndexes[OutputIndex]] = 0;
        else
          SharedData.register_values_[Circuit.cells_[reg_idx]
                                          .RegValueIndexes[OutputIndex]] =
              Value;
      }
    }

    SharedData.signal_values_[simulation.clock_signal_index_] =
        temp_signal_values_[simulation.clock_signal_index_];

    // ----------- applying always random inputs
    if (SharedData
            .signal_values_[simulation.clock_signal_index_]) {  // rising edge
      always_random_inputs_indices_ =
          &simulation.always_random_inputs_rising_edge_indices_;
    } else {  // falling edge
      always_random_inputs_indices_ =
          &simulation.always_random_inputs_falling_edge_indices_;
    }

    if (settings.input_finite_field.base == 2) {
      for (const std::vector<uint64_t>& element :
           *always_random_inputs_indices_) {
        random_bitsliced_polynomial =
            input_sharing.SampleBooleanRandomBitslicedPolynomial();

        for (input_index = 0; input_index < input_element_size; ++input_index) {
          SharedData.signal_values_[element[input_index]] =
              random_bitsliced_polynomial[input_index];
        }
      }
    } else {
      for (const std::vector<uint64_t>& element :
           *always_random_inputs_indices_) {
        random_bitsliced_polynomial =
            input_sharing.SampleRandomBitslicedPolynomial();

        for (input_index = 0; input_index < input_element_size; ++input_index) {
          SharedData.signal_values_[element[input_index]] =
              random_bitsliced_polynomial[input_index];
        }
      }
    }

    // ----------- applying the initial inputs
    if (clock_cycle < SharedData.input_sequence_.size()) {
      for (InputAssignment& input_assignment :
           SharedData.input_sequence_[clock_cycle]) {
        if (input_assignment.signal_values_.empty()) {
          if (input_assignment.is_inverted_) {
            for (input_index = 0;
                 input_index < input_assignment.signal_indices_.size();
                 ++input_index) {
              SharedData.signal_values_[input_assignment
                                            .signal_indices_[input_index]] =
                  ~SharedData
                       .selected_group_values[input_assignment.group_indices_]
                                             [input_assignment.share_index_]
                                             [input_index];
            }
          } else {
            for (input_index = 0;
                 input_index < input_assignment.signal_indices_.size();
                 ++input_index) {
              SharedData.signal_values_[input_assignment
                                            .signal_indices_[input_index]] =
                  SharedData
                      .selected_group_values[input_assignment.group_indices_]
                                            [input_assignment.share_index_]
                                            [input_index];
            }
          }
          // TODO: compute inversion under the correct galois field
        } else {
          for (input_index = 0;
               input_index < input_assignment.signal_values_.size();
               ++input_index) {
            switch (input_assignment.signal_values_[input_index]) {
              case vlog_bit_t::zero:
                SharedData.signal_values_[input_assignment
                                              .signal_indices_[input_index]] =
                    0;
                break;
              case vlog_bit_t::one:
                SharedData.signal_values_[input_assignment
                                              .signal_indices_[input_index]] =
                    FullOne;
                break;
              case vlog_bit_t::random:
                SharedData.signal_values_[input_assignment
                                              .signal_indices_[input_index]] =
                    ThreadPrng();
                break;
              default:
                break;
            }
          }
        }
      }
    }

    ForwardsRegOutputs(Circuit, SharedData);
    EvaluteCircuitFaultFree(Circuit, simulation, SharedData, input_values, clock_cycle);

    // ----------- storing the probe values in simualtion memory
    while ((probe_index < extensions.size()) &&
           (extensions[probe_index]->GetCycle() < clock_cycle)) {
      ++probe_index;
    }

    while ((probe_index < extensions.size()) &&
           (extensions[probe_index]->GetCycle() == clock_cycle)) {
      simulation.probe_values_[probe_index][SimulationIndex] =
          SharedData.signal_values_[extensions[probe_index]->GetSignals()[0]->id];
      ++probe_index;
    }

    // Here, we store the result during one clock cycle in a vcd file
    if (settings.IsWaveformSimulation()) {
      Hardware::Simulate::WriteVCDfile(
          Circuit, simulation.clock_signal_index_, SharedData,
          SimulationIndex + simulation.number_of_processed_simulations / 64,
          clock_cycle, "simulation");
    }

    // ----------- check the conditions to terminate the simulation
    Active = 0;
    for (const std::pair<uint64_t, uint64_t>& end_condition_signal : simulation.end_condition_signals_) {
      Active |= SharedData.signal_values_[end_condition_signal.first] ^ end_condition_signal.second;
    }

    if (Active == 0 && !simulation.end_condition_signals_.empty()) {
      if (NumberOfWaitedClockCycles == -1) {
        NumberOfWaitedClockCycles = 0;
      } else {
        NumberOfWaitedClockCycles++;
      }
    }

    if (NumberOfWaitedClockCycles == (int)settings.GetNumberOfWaitCycles()) {
      // ClockCyclesTook = ClockCycle;
      break;
    } else if ((clock_cycle == (settings.GetNumberOfClockCycles() - 1)) && (NumberOfWaitedClockCycles < (int)settings.GetNumberOfWaitCycles())) {
      // ClockCyclesTook = ClockCycle + 1;
      break;
    }

    if (settings.GetClkEdge() == clk_edge_t::rising)
      SharedData.signal_values_[simulation.clock_signal_index_] = 0;
    else if (settings.GetClkEdge() == clk_edge_t::falling)
      SharedData.signal_values_[simulation.clock_signal_index_] = FullOne;

    if ((settings.GetClkEdge() == clk_edge_t::rising) ||
        (settings.GetClkEdge() == clk_edge_t::falling)) {
      EvaluteCircuitFaultFree(Circuit, simulation, SharedData, input_values, clock_cycle);
    }
  }

  EvalEnabler(enabler, SimulationIndex);

  if (settings.IsWaveformSimulation()) {
    Hardware::Simulate::FinalizeVCDfile(
        settings.GetNumberOfClockCycles(),
        SimulationIndex + simulation.number_of_processed_simulations / 64,
        "simulation");
  }

  if (!simulation.fault_detection_flags_.empty()) {
    simulation.is_simulation_faulty_[SimulationIndex] = 0;
    for (std::pair<uint64_t, uint64_t>& fault_detection_flag :
         simulation.fault_detection_flags_) {
      simulation.is_simulation_faulty_[SimulationIndex] |=
          SharedData.signal_values_[fault_detection_flag.first] ^
          fault_detection_flag.second;
    }
    simulation.is_simulation_faulty_[SimulationIndex] =
        ~simulation.is_simulation_faulty_[SimulationIndex];
  }

  if (simulation.fault_set_.empty()) {
    CheckCorrectness(settings, simulation, SharedData, output_sharing, SimulationIndex, output_element_size);
  }
}

void Hardware::Simulate::GenerateVCDfile(const CircuitStruct& Circuit,
                                         int SimulationIndex,
                                         std::string file_name,
                                         std::string topmodule_name) {
  std::string SignalName;
  unsigned int BitIndex;

  for (BitIndex = 0; BitIndex < 64; BitIndex++) {
    std::ofstream VCDFile(file_name + "_" +
                          std::to_string(SimulationIndex * 64 + BitIndex) +
                          ".vcd");
    VCDFile << "$version \n PROLEAD \n$end \n$timescale \n 1ps \n$end"
            << std::endl;
    VCDFile << "$scope module " << topmodule_name << " $end\n" << std::endl;

    for (int SignalIndex = 0; SignalIndex < Circuit.NumberOfSignals;
         ++SignalIndex) {
      SignalName = Circuit.signals_[SignalIndex].Name;
      if (SignalName != "1'b0" && SignalName != "1'b1" &&
          SignalName != "1'h0" && SignalName != "1'h1") {
        VCDFile << "$var wire 1 " << SignalName << " " << SignalName << " $end"
                << std::endl;
      }
    }

    VCDFile << "$upscope $end" << std::endl;
    VCDFile << "$enddefinitions $end" << std::endl;
    VCDFile.close();
  }
}

void Hardware::Simulate::WriteVCDfile(const CircuitStruct& Circuit,
                                      uint64_t clock_signal_index,
                                      SharedData& SharedData,
                                      int SimulationIndex, int CycleIndex,
                                      std::string file_name) {
  uint64_t number_of_signals = Circuit.NumberOfSignals;
  uint64_t bit_index, signal_index;
  std::string signal_name;
  bool value;

  for (bit_index = 0; bit_index < 64; ++bit_index) {
    std::ofstream VCDFile;
    VCDFile.open(file_name + "_" +
                     std::to_string((SimulationIndex << 6) + bit_index) +
                     ".vcd",
                 std::ios_base::app);
    VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;

    for (signal_index = 0; signal_index < number_of_signals; ++signal_index) {
      signal_name = Circuit.signals_[signal_index].Name;

      if (signal_name != "1'b0" && signal_name != "1'b1" &&
          signal_name != "1'h0" && signal_name != "1'h1") {
        if (signal_index == clock_signal_index) {
          VCDFile << "1" << signal_name << std::endl;
        } else {
          value = (SharedData.signal_values_[signal_index] >> bit_index) & 0x1;
          VCDFile << value << signal_name << std::endl;
        }
      }
    }

    VCDFile << "#" << (2 * CycleIndex + 1) * 1000 << std::endl;
    VCDFile << "0" << Circuit.signals_[clock_signal_index].Name << std::endl;
    VCDFile.close();
  }
}

void Hardware::Simulate::FinalizeVCDfile(int CycleIndex, int SimulationIndex,
                                         std::string file_name) {
  for (unsigned int BitIndex = 0; BitIndex < 64; BitIndex++) {
    std::ofstream VCDFile;
    VCDFile.open(file_name + "_" +
                     std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd",
                 std::ios_base::app);
    VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;
    VCDFile.close();
  }
}

void Hardware::Simulate::SimulateFaultedAndFaultFree2(//const Library &library,
                                                     const CircuitStruct &circuit,
                                                     const Settings &settings,
                                                     SharedData &shared_data,
                                                     SharedData &shared_data_faulted,
                                                     Simulation &simulation,
                                                     uint64_t SimulationIndex,
                                                     boost::mt19937 &ThreadRng,
                                                     //const std::vector<FaultSet> &fault_sets,
                                                     uint64_t thread_index,
                                                     std::vector<std::vector<std::vector<FaultType>>> &fault_type) {

	uint64_t number_of_groups = settings.GetNumberOfGroups();

	int NumberOfWaitedClockCycles;
	uint64_t Active;
	std::vector<uint64_t> Select(number_of_groups);
	std::string ErrorMessage;
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
	std::vector<uint64_t> random_bitsliced_polynomial;


  // Inititgroup values
  InitGroupValues(settings, shared_data, input_sharing, input_element_size, number_of_groups);

  // std::cout << "[+] Init of group values completed!" << std::endl;

  // Select Group
  SelectGroupThreaded(ThreadPrng, shared_data, Select, simulation, SimulationIndex, number_of_groups);
  // std::cout << "[+] Selection of group completed!" << std::endl;

  // Sharing/Encoding
  ShareAndBitslice(shared_data, input_sharing, Select, settings, input_element_size, number_of_groups);
  // std::cout << "[+] Sharing and bitslicing completd!" << std::endl;
  // TODO: is this neccessary? probably no init values which have inpact on compuation
  //shared_data_faulted = shared_data;

	NumberOfWaitedClockCycles = -1;

  //waveform stuff is mostlikely not working anymore since we do not multithread simulations any
  //more
	if (settings.IsWaveformSimulation() && thread_index == 0){
		Hardware::Simulate::GenerateVCDfile(circuit, SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation", simulation.topmodule_name_);
		Hardware::Simulate::GenerateVCDfile(circuit, SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation-faulted", simulation.topmodule_name_);
    // std::cout << "[+] Simulation step is written to VCD fiel" << std::endl;
	}

	for (clock_cycle = 0; clock_cycle < settings.GetNumberOfClockCycles(); clock_cycle++){
    // std::cout << "Simulation: " << SimulationIndex << " Clock cycle: " << clock_cycle << std::endl;

    // clock signal pos_edge
		shared_data.signal_values_[simulation.clock_signal_index_] = FullOne;
		shared_data_faulted.signal_values_[simulation.clock_signal_index_] = FullOne;

		// ----------- evaluate the registers
    // NOTE: This writes shared_data -> Do twice for faulted and non-faulted circuit.
    evaluateRegisterFaultFree(circuit, shared_data, input_values, clock_cycle);
    evaluateRegisterFaulted(circuit, shared_data_faulted, input_values, clock_cycle, fault_type);

    // Before here takes quite long
    // std::cout << "[+] Registers are evaluatated!" << std::endl;

		// ----------- applying always random inputs
    // NOTE: This must be equal for both the faulted and non-faulted state
    // --> We have call this once for faulted and non-faulted and dublicate it.
    applyAlwaysRandomInputs(simulation, settings, random_bitsliced_polynomial, input_element_size, input_sharing, shared_data, shared_data_faulted);
    // std::cout << "[+] Random inputs are applied!" << std::endl;

		// ----------- applying the initial inputs
    applyInitialInputs(shared_data, shared_data_faulted, ThreadPrng, clock_cycle);
    // std::cout << "[+] Initial inputs are applied!" << std::endl;

		// ----------- applying the register outputs to the output signals
    ForwardsRegOutputs(circuit, shared_data);
    ForwardsRegOutputs(circuit, shared_data_faulted);

    // After here takes quite long
    EvaluteCircuitFaultFree(circuit, simulation, shared_data, input_values, clock_cycle);
    EvaluteCircuitFaulted(circuit, shared_data_faulted, input_values, clock_cycle, fault_type);

    // clock signal neg_edge
		shared_data.signal_values_[simulation.clock_signal_index_] = 0;
		shared_data_faulted.signal_values_[simulation.clock_signal_index_] = 0;


		// Here, we store the result during one clock cycle in a vcd file
		if (settings.IsWaveformSimulation()&& thread_index == 0){
			Hardware::Simulate::WriteVCDfile(circuit, simulation.clock_signal_index_, shared_data, SimulationIndex + simulation.number_of_processed_simulations / 64, clock_cycle, "simulation");
			Hardware::Simulate::WriteVCDfile(circuit, simulation.clock_signal_index_, shared_data_faulted, SimulationIndex + simulation.number_of_processed_simulations / 64, clock_cycle, "simulation-faulted");
      // std::cout << "[+] Clockcycle is written to VCD file!" << std::endl;
		}

		// ----------- check the conditions to terminate the simulation
    Active = 0;
    for (const std::pair<uint64_t, uint64_t>& end_condition_signal : simulation.end_condition_signals_) {
      Active |= shared_data.signal_values_[end_condition_signal.first] ^ end_condition_signal.second;
    }

    if (Active == 0 && !simulation.end_condition_signals_.empty()) {
      if (NumberOfWaitedClockCycles == -1) {
        NumberOfWaitedClockCycles = 0;
      } else {
        NumberOfWaitedClockCycles++;
      }
    }

    if (NumberOfWaitedClockCycles == (int)settings.GetNumberOfWaitCycles()) {
      // ClockCyclesTook = ClockCycle;
      break;
    } else if ((clock_cycle == (settings.GetNumberOfClockCycles() - 1)) && (NumberOfWaitedClockCycles < (int)settings.GetNumberOfWaitCycles())) {
      // ClockCyclesTook = ClockCycle + 1;
      break;
		}
	}

	if (settings.IsWaveformSimulation()&& thread_index == 0){
		Hardware::Simulate::FinalizeVCDfile(settings.GetNumberOfClockCycles(), SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation");
		Hardware::Simulate::FinalizeVCDfile(settings.GetNumberOfClockCycles(), SimulationIndex + simulation.number_of_processed_simulations / 64, "simulation-faulted");
	}

  CheckCorrectness(settings, simulation, shared_data, output_sharing, SimulationIndex, output_element_size);
}
