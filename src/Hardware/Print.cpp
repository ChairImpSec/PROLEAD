#include "Hardware/Print.hpp"

void Hardware::Print::Help(){
    std::cout << "Usage:" << std::endl;
    std::cout << "./PROLEAD [-lf/-libraryfile  ?] [-ln/-libraryname ?] [-df/-designfile ?]" << std::endl;
    std::cout << "          [-mn/-modulename   ?] [-cf/-configfile  ?] [-ldf/-linkerfile ?]" << std::endl;
    std::cout << "          [-rf/-resultfolder ?]\n" << std::endl;
    std::cout << "Options:" << std::endl;
    std::cout << "    -lf/-libraryfile" << std::endl;
    std::cout << "        Sets the specified library file as the standard library file for simulation." << std::endl;
    std::cout << "        The library file should define the functional behavior of each cell in the netlist." << std::endl;
    std::cout << "        Such a file is required for the simulator of PROLEAD to understand how to simulate the cells." << std::endl;
    std::cout << std::endl;
    std::cout << "    -ln/-libraryname" << std::endl;
    std::cout << "        Sets the specified library name as the standard library name." << std::endl;
    std::cout << "        The library name identifies a unique library in the library file." << std::endl;
    std::cout << "        This is important as multiple libraries are defined in the same library file." << std::endl;
    std::cout << std::endl;
    std::cout << "    -df/-designfile" << std::endl;
    std::cout << "        Sets the specified design file as the standard design file." << std::endl;
    std::cout << "        The design file specifies a gate-level netlist written in Verilog." << std::endl;
    std::cout << "        Such a netlist is produced by synthesizing the circuit's behavioral description." << std::endl;
    std::cout << "        Synthesizing can be done by using a hardware synthesizer, e.g., Design Compiler or Yosys." << std::endl;
    std::cout << std::endl;
    std::cout << "    -mn/-modulename" << std::endl;
    std::cout << "        Sets the specified module name as the standard module name." << std::endl;
    std::cout << "        The module name specifies the name of the topmodule in the netlist." << std::endl;
    std::cout << std::endl;
    std::cout << "    -ldf/-linkerfile" << std::endl;
    std::cout << "        Sets the specified linker file as the standard linker file." << std::endl;
    std::cout << std::endl;   
    std::cout << "    -rf/-resultfolder" << std::endl;
    std::cout << "        Sets the specified result folder as the standard result folder." << std::endl;
    std::cout << "        All reports are stored in the result folder." << std::endl;
    std::cout << std::endl;     
    std::cout << "    -cf/-configfile" << std::endl;
    std::cout << "        Sets the specified config file as the standard config file." << std::endl;
    std::cout << "        The config file defines the evaluation settings." << std::endl;
    std::cout << std::endl;   
    std::cout << "        Config file parameters:" << std::endl;
    std::cout << "            max_no_of_threads" << std::endl;
    std::cout << "                Specifies the maximum number of threads for parallel operations." << std::endl;
    std::cout << "                A high number of threads leads to a fast evaluation that consumes more RAM." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of threads (> 0)." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    max_no_of_threads" << std::endl;  
    std::cout << "                    16 % The maximum number of usable threads is 16." << std::endl;  
    std::cout << std::endl;    
    std::cout << "            no_of_groups" << std::endl;
    std::cout << "                Specifies the number of groups to conduct the test." << std::endl;
    std::cout << "                Usually, we evaluate two groups in a fixed vs. fixed or fixed vs. random setting." << std::endl;
    std::cout << "                Moreover, we assign a value to each group in Verilog syntax and denote random values with '$'." << std::endl;
    std::cout << std::endl;
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of groups (> 1)." << std::endl;
    std::cout << "                    <string>: The group specification." << std::endl;
    std::cout << std::endl;
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_groups" << std::endl;  
    std::cout << "                    2 % Two groups are conducted for the test." << std::endl;  
    std::cout << std::endl;
    std::cout << "                    64'h0000000000000000 % The first group is assigned to a 64-bit zero vector." << std::endl;  
    std::cout << "                    64'h$$$$$$$$$$$$$$$$ % The second group is assigned to a 64-bit random vector." << std::endl;  
    std::cout << std::endl; 
    std::cout << "            clock_signal_name" << std::endl;
    std::cout << "                Specifies the name of the clock signal." << std::endl;
    std::cout << std::endl;
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The name of the clock signal." << std::endl;
    std::cout << std::endl;
    std::cout << "                Example: " << std::endl;
    std::cout << "                    clock_signal_name" << std::endl;  
    std::cout << "                    clk % The clock signal is named 'clk'." << std::endl;  
    std::cout << std::endl;   
    std::cout << "            max_clock_cycle" << std::endl;
    std::cout << "                Specifies the maximum number of clock cycles per run before checking the end_condition." << std::endl;
    std::cout << std::endl;   
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of clock cycles (> 0)." << std::endl;
    std::cout << std::endl;    
    std::cout << "                Example: " << std::endl;
    std::cout << "                    max_clock_cycle" << std::endl;  
    std::cout << "                    5 % The simulator simulates the first five clock cycles and checks the end_condition afterwards." << std::endl;  
    std::cout << std::endl;     
    std::cout << "            no_of_always_random_inputs" << std::endl;
    std::cout << "                Specifies the number of inputs which are fed randomly at every clock cycle." << std::endl;
    std::cout << "                First, the number of fresh random inputs is given. Afterwards, the given are given in Verilog syntax." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of inputs." << std::endl;
    std::cout << "                    <string>: The name of the inputs." << std::endl;
    std::cout << std::endl;    
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_always_random_inputs" << std::endl;  
    std::cout << "                    2 % PROLEAD expects two fresh random inputs" << std::endl;
    std::cout << std::endl;   
    std::cout << "                    OneBitFreshRand % One-bit input signal with name 'OneBitFreshRand'" << std::endl;
    std::cout << "                    [4:0] FiveBitFreshRand % Five-bit input signal with name 'FiveBitFreshRand'" << std::endl;
    std::cout << std::endl;   
    std::cout << "            no_of_initial_inputs" << std::endl;
    std::cout << "                Specifies the number of inputs during the initialization." << std::endl;
    std::cout << std::endl;   
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of inputs." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_initial_inputs" << std::endl;  
    std::cout << "                    3 % 3 inputs are initialized." << std::endl;
    std::cout << std::endl; 
    std::cout << "            no_of_initial_clock_cycles" << std::endl;
    std::cout << "                Specifies the number of cycles to initiate the run." << std::endl;
    std::cout << "                Moreover, we define an input sequence here." << std::endl;
    std::cout << "                Signals can be assigned with constants or shares of the group value in Verilog syntax." << std::endl;
    std::cout << "                Shares are assigned with the 'group_in' statement, i.e. group_in0 = first share, group_in1 = second share..." << std::endl;
    std::cout << std::endl;   
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of initial clock cycles." << std::endl;
    std::cout << "                    <string>: The signal assignments." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_initial_clock_cycles" << std::endl;  
    std::cout << "                    2 % The initialization sequence takes two clock cycles." << std::endl;
    std::cout << std::endl;   
    std::cout << "                    % Assume that 'SharedInput' stores two 16-bit shares." << std::endl;
    std::cout << "                    [15:0]  SharedInput group_in0[16:0] % Set first share depending on the defined groups." << std::endl;
    std::cout << "                    [31:16] SharedInput group_in1[16:0] % Set second share depending on the defined groups." << std::endl;
    std::cout << "                    Reset  1'b1 % Set the reset signal to one." << std::endl;
    std::cout << std::endl;  
    std::cout << "                    % Initialize inputs to zero for the second clock cycle." << std::endl;
    std::cout << "                    % PROLEAD keeps this input state for the rest of the simulation." << std::endl;    
    std::cout << "                    [15:0]  SharedInput 16'h0000" << std::endl;
    std::cout << "                    [31:16] SharedInput 16'h0000" << std::endl;
    std::cout << "                    Reset  1'b0" << std::endl;
    std::cout << std::endl; 
    std::cout << "            end_condition" << std::endl;
    std::cout << "                Specifies the condition to check to terminate the simulation." << std::endl;
    std::cout << "                PROLEAD can check if a signal reaches a specific state (e.g. done signal is high)." << std::endl;
    std::cout << "                Alternatively, PROLEAD can terminate the simulation after a specific number of clock cycles.." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The end condition as signal assignment or cycle count." << std::endl;
    std::cout << std::endl;     
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    end_condition" << std::endl;  
    std::cout << "                    Done 1'b1 % Stop simulation if 'Done' is set to one." << std::endl;
    std::cout << std::endl;
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    end_condition" << std::endl;     
    std::cout << "                    [31:0] y 32'h89ABCE00 % Stop simulation if vector 'y' is set to 32'h89ABCE00." << std::endl;
    std::cout << std::endl;
    std::cout << "                Example 3: " << std::endl;
    std::cout << "                    end_condition" << std::endl; 
    std::cout << "                    ClockCycles 100 % Stop simulation after 100 clock cycles." << std::endl;
    std::cout << std::endl;  
    std::cout << "            end_wait_cycles" << std::endl;
    std::cout << "                Specifies the number of clock cycles to wait after the end_condition." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of wait clock cycles." << std::endl;
    std::cout << std::endl;    
    std::cout << "                Example: " << std::endl;
    std::cout << "                    end_wait_cycles" << std::endl;  
    std::cout << "                    1 % Wait one clock cycle after the end_condition." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            order_of_test" << std::endl;
    std::cout << "                Specifies the maximum number of standard probes per probing set, i.e., order of test." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The security order." << std::endl;
    std::cout << std::endl;    
    std::cout << "                Example: " << std::endl;
    std::cout << "                    order_of_test" << std::endl;  
    std::cout << "                    1 % The test evaluates first-order probing security." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            multivariate_test" << std::endl;
    std::cout << "                Specifies whether PROLEAD evaluates univariate or multivariate leakage." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The decision (yes/no/exclusive)." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    multivariate_test" << std::endl;  
    std::cout << "                    no % The test evaluates univariate leakage." << std::endl; 
    std::cout << std::endl;  
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    multivariate_test" << std::endl; 
    std::cout << "                    exclusive % The test evaluates multivariate leakage." << std::endl;  
    std::cout << std::endl;  
    std::cout << "                Example 3: " << std::endl;
    std::cout << "                    multivariate_test" << std::endl;     
    std::cout << "                    yes % The test evaluates univariate and multivariate leakage." << std::endl;      
    std::cout << std::endl; 
    std::cout << "            max_distance_multivariate" << std::endl;
    std::cout << "                Specifies the maximum time difference of probes inside a probing set." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The maximum distance." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    max_distance_multivariate" << std::endl;  
    std::cout << "                    10 % All probing sets with a higher distance than 10 are removed." << std::endl;           
    std::cout << std::endl;     
    std::cout << "            transitional_leakage" << std::endl;
    std::cout << "                Specifies whether PROLEAD considers transitional leakage." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The decision (yes/no)." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    transitional_leakage" << std::endl;  
    std::cout << "                    no % PROLEAD considers glitches." << std::endl;      
    std::cout << std::endl; 
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    transitional_leakage" << std::endl;
    std::cout << "                    yes % PROLEAD considers glitches and transitions." << std::endl;      
    std::cout << std::endl; 
    std::cout << "            compact_distributions" << std::endl;
    std::cout << "                Specifies whether distributions (of probes) should be considered as compact." << std::endl;
    std::cout << "                A compact distribution is build based on the hamming weight itermediate instead of the intermediate itself." << std::endl;
    std::cout << "                It is recommended to use to evaluate large circuits at high security order in the compact mode." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The decision (yes/no)." << std::endl;
    std::cout << std::endl; 
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    compact_distributions" << std::endl;  
    std::cout << "                    no % Normal mode." << std::endl;      
    std::cout << std::endl; 
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    compact_distributions" << std::endl;  
    std::cout << "                    yes % Compact mode." << std::endl;      
    std::cout << std::endl; 
    std::cout << "            no_of_test_clock_cycles" << std::endl;
    std::cout << "                Specifies which clock cycles are evaluated." << std::endl;
    std::cout << "                Specify ranges of clock cycles by using the \"-\" notation." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of different clock cycle ranges." << std::endl;
    std::cout << "                    <string>: The clock cycle ranges.." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_test_clock_cycles" << std::endl;  
    std::cout << "                    3 % Specifies that three ranges of clock cycles are evaluated." << std::endl;   
    std::cout << std::endl;  
    std::cout << "                    2 % First block: Clock cycle 2 is evaluated." << std::endl;      
    std::cout << "                    3-7 % Second block: Clock cycles 3,4,5,6,7 are evaluated." << std::endl;      
    std::cout << "                    9-10 % Thrid block: Clock cycles 9 and 10 are evaluated." << std::endl;    
    std::cout << "                    % In total the cycles 2,3,4,5,6,7,9,10 are considered during the leakage detection." << std::endl;  
    std::cout << std::endl;      
    std::cout << "            minimize_probe_sets" << std::endl;
    std::cout << "                Specifies whether it should be tried to find equivalent probing sets." << std::endl;
    std::cout << "                This means that PROLEAD removes each probing set which is fully covered by another probing set." << std::endl;
    std::cout << "                It is recommended to use 'yes' only for small circuits and low security orders due to high complexity." << std::endl;
    std::cout << std::endl;
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The decision (yes/no)." << std::endl;
    std::cout << std::endl;   
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    minimize_probe_sets" << std::endl;  
    std::cout << "                    no % The probing sets are not minimized and subsets of other probing sets are possible." << std::endl;      
    std::cout << std::endl;   
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    minimize_probe_sets" << std::endl;  
    std::cout << "                    yes % The probing sets are minimized. No probing set is a subset of another set." << std::endl;      
    std::cout << std::endl;     
    std::cout << "            no_of_probe_steps" << std::endl;
    std::cout << "                Specifies whether PROLEAD should split the probing sets into multiple blocks." << std::endl;
    std::cout << "                This means that PROLEAD has to keep only one block in the RAM while the block is deleted at the end." << std::endl;
    std::cout << "                It is recommended to use a single block only for small circuits and low security orders due to the high demand of storage." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of steps." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_probe_steps" << std::endl;  
    std::cout << "                    5 % The probing sets are divided into 5 blocks which are evaluates consecutively." << std::endl;      
    std::cout << std::endl; 
    std::cout << "            effect_size" << std::endl;
    std::cout << "                Specifies the statistical power of the underlying test." << std::endl;
    std::cout << "                It is recommended to use the default setting of 0.1 even for low security orders." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <double>: The effect size." << std::endl;
    std::cout << std::endl;      
    std::cout << "                Example: " << std::endl;
    std::cout << "                    effect_size" << std::endl;  
    std::cout << "                    0.1 % The effect size is set to 0.1." << std::endl;      
    std::cout << std::endl;     
    std::cout << "            remove_full_probing_sets" << std::endl;
    std::cout << "                Specifies whether probing sets should be removed after the specified number of simulations is considered." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <string>: The decision (yes/no)." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example 1: " << std::endl;
    std::cout << "                    remove_full_probing_sets" << std::endl;  
    std::cout << "                    no % All probing sets take the complete set of simulations into account." << std::endl;      
    std::cout << std::endl;  
    std::cout << "                Example 2: " << std::endl;
    std::cout << "                    remove_full_probing_sets" << std::endl;  
    std::cout << "                    yes % If a probing set can satisfy the required statistical power, it will be removed." << std::endl;      
    std::cout << std::endl;    
    std::cout << "            no_of_entries_in_report" << std::endl;
    std::cout << "                Specifies how many of the most leaking probes are stored in the report." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of entries." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_entries_in_report" << std::endl;  
    std::cout << "                    10 % The 10 most-leaking probes are stored in the report." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            no_of_simulations" << std::endl;
    std::cout << "                Specifies the total number of simulations." << std::endl;
    std::cout << "                The total number of simulations should be a factor of 64." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of simulations." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_simulations" << std::endl;  
    std::cout << "                    100000000 % The test conducts 100 million simulations." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            no_of_step_simulations" << std::endl;
    std::cout << "                Specifies the number of simulations per step." << std::endl;
    std::cout << "                After each step, all probing sets are analyzed." << std::endl;
    std::cout << "                The total number of step simulations should be a factor of 64 and a divisor of \"no_of_simulations\"." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of simulations." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_step_simulations" << std::endl;  
    std::cout << "                    1000000 % The test conducts 1 million simulations per step." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            no_of_step_write_results" << std::endl;
    std::cout << "                Specifies the number of simulations after which a detailed report is written in a file." << std::endl;
    std::cout << "                The report contains the most leaking probes per cycle and global." << std::endl;
    std::cout << "                Should be a factor of 64, and a divisor of \"no_of_simulations\" and should be a factor of \"no_of_step_simulations\"." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments:" << std::endl;
    std::cout << "                    <int>: The number of simulations." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    no_of_step_write_results" << std::endl;  
    std::cout << "                    1000000 % Every 1 million simulations a report is written." << std::endl;      
    std::cout << std::endl;  
    std::cout << "            probes_include" << std::endl;
    std::cout << "                Specifies the wires which should be included for probing." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments: " << std::endl;
    std::cout << "                    <string>: all: Probes are placed on all wires of the circuit which are not excluded." << std::endl;
    std::cout << "                    <int>: E.g., 2 : to inlcude two wires followed by their names." << std::endl;
    std::cout << "                    <string>: The signal names." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    probes_include" << std::endl;  
    std::cout << "                    3 % 3 wires are included, their names follow." << std::endl;      
    std::cout << std::endl;  
    std::cout << "                    Intermediate % A wire with name \"Intermediate\" is included." << std::endl; 
    std::cout << "                    {GlitchExtendedIntermediate} % A wire with name \"GlitchExtendedIntermediate\" is included together with all wires that contribute to \"GlitchExtendedIntermediate\"." << std::endl; 
    std::cout << "                    Intermediates* % All wires within the multi-bit wire \"Intermediates\" are included. I.e. Intermediates[0], Intermediates[1], ... ." << std::endl; 
    std::cout << std::endl;  
    std::cout << "            probes_exclude" << std::endl;
    std::cout << "                Specifies the wires which should be excluded for probing." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Arguments: " << std::endl;
    std::cout << "                    <string>: all: Probes are placed no wire of the circuit." << std::endl;
    std::cout << "                    <int>: E.g., 2 : to exlcude two wires followed by their names." << std::endl;
    std::cout << "                    <string>: The signal names." << std::endl;
    std::cout << std::endl;  
    std::cout << "                Example: " << std::endl;
    std::cout << "                    probes_exclude" << std::endl;  
    std::cout << "                    3 % 3 wires are excluded, their names follow." << std::endl;      
    std::cout << std::endl;  
    std::cout << "                    Intermediate % A wire with name \"Intermediate\" is excluded." << std::endl; 
    std::cout << "                    {GlitchExtendedIntermediate} % A wire with name \"GlitchExtendedIntermediate\" is excluded together with all wires that contribute to \"GlitchExtendedIntermediate\"." << std::endl; 
    std::cout << "                    Intermediates* % All wires within the multi-bit wire \"Intermediates\" are excluded. I.e. Intermediates[0], Intermediates[1], ... ." << std::endl; 
    std::cout << std::endl;  
}


void Hardware::Print::CommandLineSettings(CommandLineParameterStruct& CommandLineParameters){
    std::cout << "Library file:   " << CommandLineParameters.LibraryFileName            << std::endl;
    std::cout << "Library name:   " << CommandLineParameters.LibraryName                << std::endl;
    std::cout << "Design file:    " << CommandLineParameters.DesignFileName             << std::endl;
    std::cout << "Module name:    " << CommandLineParameters.MainModuleName             << std::endl;
    std::cout << "Linker file:    " << CommandLineParameters.LinkerFileName             << std::endl;
    std::cout << "Settings file:  " << CommandLineParameters.SettingsFileName           << std::endl;
    std::cout << "Result folder:  " << CommandLineParameters.EvaluationResultFolderName << std::endl;
    std::cout << std::endl;
}

void Hardware::Print::ProbeGenerationSettings(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    // Standard, Extended, Order, Distance, Report, ProbingSet, Probes
    std::array<std::string, 7> TableColumn;

    TableColumn.at(0) = std::to_string(Test.StandardProbes.size());
    TableColumn.at(1) = std::to_string(Test.ExtendedProbes.size());
    TableColumn.at(2) = std::to_string(Simulation.TestOrder);
    TableColumn.at(3) = std::to_string(Settings.MaxDistanceMultivariet);
    TableColumn.at(4) = std::to_string(Settings.Max_No_ReportEntries);
    TableColumn.at(5) = std::to_string(Test.ProbingSet.size());

    // Find maximum number of probes in a single probing set
    unsigned int MaximumNumberOfProbes = 0;
    size_t Index = 0;
	
    for (Index = 0; Index < Test.ProbingSet.size(); Index++){
        if (Test.ProbingSet.at(Index).Extension.size() > MaximumNumberOfProbes){
            MaximumNumberOfProbes = Test.ProbingSet.at(Index).Extension.size();
		}
	}

	TableColumn.at(6) = std::to_string(MaximumNumberOfProbes);    

    // Print the settings
    int TableWidth = 130;

	std::array<std::string, 7> Headers{{ "#Standard Probes", "#Extended Probes", "Security Order", "Distance", "#Entries in Report", "#Probing Sets", "Maximum #Probes per Set" }};
	std::array<unsigned int, 7> Widths{{19, 19, 17, 11, 21, 16, 26}};

    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
	std::cout.setf(std::ios::right, std::ios::adjustfield);
    std::cout << '|';

    for (Index = 0; Index < 7; Index++){
        std::cout.width(Widths.at(Index));
        std::cout << (Headers.at(Index) + " |");        
    }

    std::cout << std::endl;
    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
	std::cout << '|';

    for (Index = 0; Index < 7; Index++){
        std::cout.width(Widths.at(Index));
        std::cout << (TableColumn.at(Index) + " |");        
    }

    std::cout << std::endl;
    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
    std::cout << std::endl;    
}

unsigned int Hardware::Print::EvaluationSettings(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    // Check how much space is required to print the probes
    unsigned int Space = 1, Maximum = 47;
    int ProbeIndex = 0;
    char cycle[10];
    size_t SetIndex;

	for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        Space = 1;

        for (ProbeIndex = 0; ProbeIndex < Test.GetNumberOfStandardProbes(SetIndex); ProbeIndex++){
            if (ProbeIndex == (Test.GetNumberOfStandardProbes(SetIndex) - 1)){
				std::sprintf(cycle, " (%d)  ", Test.GetStandardProbe(SetIndex, ProbeIndex).Cycle + 1);
            }else{
				std::sprintf(cycle, " (%d),  ", Test.GetStandardProbe(SetIndex, ProbeIndex).Cycle + 1);
            }
            
            Space += strlen(Simulation.ProbeName[Test.GetStandardProbe(SetIndex, ProbeIndex).Probe]) + strlen(cycle);
        }

        if (Space > Maximum){
            Maximum = Space;
        }
    }

    // Print the settings
    unsigned int Index = 0;
    int TableWidth = 89 + Maximum;
	std::array<std::string, 6> Headers{{ "Elapsed Time", "Required Ram", "Processed Simulations", "Probing Set with highest Information Leakage", "-log10(p)", "Status"}};
	std::array<unsigned int, 6> Widths{{20, 20, 25, Maximum, 13, 10}};

    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
	std::cout.setf(std::ios::right, std::ios::adjustfield);
	std::cout << '|';

    for (Index = 0; Index < 6; Index++){
        std::cout.width(Widths.at(Index));
        std::cout << (Headers.at(Index) + " |");        
    }

    std::cout << std::endl;
    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');

    return Maximum;
}

unsigned int Hardware::Print::MemoryConsumption(){
    std::ifstream Status("/proc/self/status");
    std::string Line, Number;
    unsigned int ram = 0;

    if (Status.is_open()){
        while (getline(Status,Line)){
            if (Line.find("VmSize") != std::string::npos){
                Number = Line.substr(7, Line.length());
                ram = std::stoi(Number.substr(0, Number.length() - 2));
                break;
            }
        }
        Status.close();
    }else{
        throw std::logic_error("Status file not found!");
    }

    return ram;
}

void Hardware::Print::EvaluationResults(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, double& DeletedAlpha, std::string& DeletedProbingSet, double ElapsedTimePeriod, unsigned int Space){
    std::array<std::string, 6> TableColumn;
    std::string Probe, Cycle, ProbingSet = "";
    double MaximumAlpha = DeletedAlpha;
    unsigned int MaximumTraces = 0;
    unsigned int MaximumSetIndex = 0;
    int ProbeIndex;
    size_t SetIndex;

    // Find the most leaking probing set and required number of traces
	for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
		if (Test.ProbingSet.at(SetIndex).ContingencyTable.Probability > MaximumAlpha){
            MaximumAlpha = Test.ProbingSet.at(SetIndex).ContingencyTable.Probability;
            MaximumSetIndex = SetIndex;
        }

        if (Test.ProbingSet.at(SetIndex).ContingencyTable.Traces > MaximumTraces){
            MaximumTraces = Test.ProbingSet.at(SetIndex).ContingencyTable.Traces; 
        }
    }

    if (MaximumAlpha > DeletedAlpha){
        for (ProbeIndex = 0; ProbeIndex < Test.GetNumberOfStandardProbes(MaximumSetIndex); ProbeIndex++){
            Probe = Simulation.ProbeName[Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Probe];
            Cycle = std::to_string(Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Cycle + 1);

            if (ProbeIndex == (Test.GetNumberOfStandardProbes(MaximumSetIndex) - 1)){
                ProbingSet += Probe + " (" + Cycle + ")";
            }else{
                ProbingSet += Probe + " (" + Cycle + "), ";
            }
        }
    
        TableColumn.at(3) = ProbingSet;
        TableColumn.at(4) = std::to_string(MaximumAlpha);

        if (MaximumAlpha < 5.0){
            TableColumn.at(5) = "OKAY";
        }else{
            TableColumn.at(5) = "LEAKAGE";
        }

    }else{
        TableColumn.at(3) = DeletedProbingSet;
        TableColumn.at(4) = std::to_string(DeletedAlpha);

        if (DeletedAlpha < 5.0){
            TableColumn.at(5) = "OKAY";
        }else{
            TableColumn.at(5) = "LEAKAGE";
        }        
    }

    TableColumn.at(0) = std::to_string(ElapsedTimePeriod);
    TableColumn.at(1) = std::to_string(Hardware::Print::MemoryConsumption() / 1e6);

    if (Settings.CompactDistributions){
        TableColumn.at(2) = std::to_string(Simulation.NumberOfProcessedSimulations);
    }else{
        TableColumn.at(2) = std::to_string(Simulation.NumberOfProcessedSimulations) + " / " + std::to_string(MaximumTraces);
    }

    std::cout << '|';
    std::cout.width(20);
    std::cout << (TableColumn.at(0) + "s |");
    std::cout.width(20);
    std::cout << (TableColumn.at(1) + "GB |");
    std::cout.width(25);
	std::cout << (TableColumn.at(2) + " |");
    std::cout.width(Space);
    std::cout << (TableColumn.at(3) + " |");
    std::cout.width(13);
    std::cout << (TableColumn.at(4) + " |");
    std::cout.width(10);
    std::cout << (TableColumn.at(5) + " |");
    std::cout << std::endl;

    //Hardware::Print::MemoryConsumption();
}

void Hardware::Print::Report(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, unsigned int ProbeStepIndex, unsigned int TableWidth){
    std::string ReportName;
    
    if (Settings.ProbeStepSize == UINT_MAX){
        ReportName = (std::string)Simulation.EvaluationResultFolderName + "/Report_" + std::to_string(Simulation.NumberOfProcessedSimulations) + ".dat"; 
    }else{
        ReportName = (std::string)Simulation.EvaluationResultFolderName + "/Report_" + std::to_string(Simulation.NumberOfProcessedSimulations) + "_Step_" + std::to_string(ProbeStepIndex) + ".dat"; 
    }

    std::ofstream Report(ReportName);
    size_t SetIndex;
    unsigned int ProbeIndex, LatestClockCycle, Counter = 0;
    unsigned int MaximumSetIndex = 0;
	std::vector<ProbingSetStruct>::iterator Maximum;
    int CycleIndex;

    std::vector<unsigned int> MaximumProbingSetPerCycle(Simulation.NumberOfClockCycles, 0);
    std::vector<bool> MaximumProbingSetPerCycleSet(Simulation.NumberOfClockCycles, false);
    std::vector<double> MaximumGPerCycle(Simulation.NumberOfClockCycles, 0.0);

    Report << "Report file after " << Simulation.NumberOfProcessedSimulations << " simulations:" << std::endl << std::endl;
    Report << "1.) Summary of most leaking (and already active) probing sets per clock cycle: " << std::endl << std::endl;

    for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        // Get the probe with the latest clock cycle of the set
        LatestClockCycle = 0;

        for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet.at(SetIndex).Extension.size(); ProbeIndex++){
            if (Test.GetExtendedProbe(SetIndex, ProbeIndex).Cycle > LatestClockCycle){
                LatestClockCycle = Test.GetExtendedProbe(SetIndex, ProbeIndex).Cycle;
            }
        }

        if (Test.ProbingSet.at(SetIndex).ContingencyTable.Probability > MaximumGPerCycle.at(LatestClockCycle)){
            MaximumGPerCycle.at(LatestClockCycle) = Test.ProbingSet.at(SetIndex).ContingencyTable.Probability;
            MaximumProbingSetPerCycle.at(LatestClockCycle) = SetIndex;
            MaximumProbingSetPerCycleSet.at(LatestClockCycle) = true;
        }
    }

    for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){
        if (MaximumProbingSetPerCycleSet.at(Simulation.TestClockCycles[CycleIndex] - 1)){
            Report << "Cycle " << Simulation.TestClockCycles[CycleIndex] << ": @[";

            for (ProbeIndex = 0; ProbeIndex < (unsigned int)Test.GetNumberOfStandardProbes(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)); ProbeIndex++){
                if (ProbeIndex == (unsigned int)(Test.GetNumberOfStandardProbes(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)) - 1)){
                    Report << Simulation.ProbeName[Test.GetStandardProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Probe] << "(" << (Test.GetStandardProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Cycle + 1) << ")]";
                }else{
                    Report << Simulation.ProbeName[Test.GetStandardProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Probe] << "(" << (Test.GetStandardProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Cycle + 1) << "), ";
                }
            }

            Report << " ==> [";

            for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet.at(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)).Extension.size(); ProbeIndex++){
                if (ProbeIndex == (Test.ProbingSet.at(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)).Extension.size() - 1)){
                    Report << Simulation.GlitchExtendedProbeName[Test.GetExtendedProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Probe] << "(" << (Test.GetExtendedProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Cycle + 1) << ")]";
                }else{
                    Report << Simulation.GlitchExtendedProbeName[Test.GetExtendedProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Probe] << "(" << (Test.GetExtendedProbe(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1), ProbeIndex).Cycle + 1) << "), ";
                }
            }

            Report << " -log10(p) = " << Test.ProbingSet.at(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)).ContingencyTable.Probability;
            if(Test.ProbingSet.at(MaximumProbingSetPerCycle.at(Simulation.TestClockCycles[CycleIndex] - 1)).ContingencyTable.Probability > Settings.AlphaThreshold){
                Report << " --> LEAKAGE" << std::endl;
            }else{
                Report << " --> OKAY" << std::endl;
            }
        }
    }
    
    Report << std::endl;
    Report << "2.) Summary of the most leakging (and already active) probing sets: " << std::endl << std::endl;

    while((Counter < (unsigned int)Settings.Max_No_ReportEntries) && (Counter < Test.ProbingSet.size()))
	{
		Maximum = std::max_element(Test.ProbingSet.begin(), Test.ProbingSet.end(), [](const Hardware::ProbingSetStruct& lhs, const Hardware::ProbingSetStruct& rhs){return lhs.ContingencyTable.Probability < rhs.ContingencyTable.Probability;});
		MaximumSetIndex = std::distance(Test.ProbingSet.begin(), Maximum);
        
        Report << "@[";

	    for (ProbeIndex = 0; ProbeIndex < (unsigned int)Test.GetNumberOfStandardProbes(MaximumSetIndex); ProbeIndex++){
            if (ProbeIndex == (unsigned int)(Test.GetNumberOfStandardProbes(MaximumSetIndex) - 1)){
                Report << Simulation.ProbeName[Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Probe] << "(" << (Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Cycle + 1) << ")]";
            }else{
                Report << Simulation.ProbeName[Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Probe] << "(" << (Test.GetStandardProbe(MaximumSetIndex, ProbeIndex).Cycle + 1) << "), ";
            }
        }

        Report << " ==> [";

        for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet.at(MaximumSetIndex).Extension.size(); ProbeIndex++){
            if (ProbeIndex == (Test.ProbingSet.at(MaximumSetIndex).Extension.size() - 1)){
                Report << Simulation.GlitchExtendedProbeName[Test.GetExtendedProbe(MaximumSetIndex, ProbeIndex).Probe] << "(" << (Test.GetExtendedProbe(MaximumSetIndex, ProbeIndex).Cycle + 1) << ")]";
            }else{
                Report << Simulation.GlitchExtendedProbeName[Test.GetExtendedProbe(MaximumSetIndex, ProbeIndex).Probe] << "(" << (Test.GetExtendedProbe(MaximumSetIndex, ProbeIndex).Cycle + 1) << "), ";
            }
        }

	    Report << " -log10(p) = " << Test.ProbingSet.at(MaximumSetIndex).ContingencyTable.Probability;
        if(Test.ProbingSet.at(MaximumSetIndex).ContingencyTable.Probability > 5.0){
            Report << " --> LEAKAGE" << std::endl;
        }else{
            Report << " --> OKAY" << std::endl;
        }

        Test.ProbingSet.at(MaximumSetIndex).ContingencyTable.Probability = 0;
		Counter++;
	}

    Report.close();

    std::cout.width(89 + TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
}