# Command line arguments:
# $1: The projects hardware description language (either VHDL or Verilog)
# $2: The path to the rtl code. All files must be in one directory
# $3: The name of the top module

# The yosys script runs the following steps
# 1.) Read all design files
# 2.) Read all library files
# 3.) Prevent any cross-boundary optimizations
# 4.) Generic synthesis with a given top module
# 5.) Mapping flip-flops to the library
# 6.) Mapping logic to the library
# 7.) Identify unused signals and cells and remove them
# 8.) Print some statistics
# 9.) Remove the keep hierarchy attribute
# 10.) Flatten the netlist
# 11.) Select the top module
# 12.) Exchange all "assign" statements with buffer modules
# 13.) Write the synthsized design without attributes

# Path to the Yosys library files
LIBRARY_PATH="../lib/"

if [[ $1 == "VHDL" || $1 == "vhdl" || $1 == "Vhdl" ]]; 
then
    # Analyze VHDL sources
    ghdl -a $2*.vhd

    # Run 1.) - 13.)
    yosys -m ghdl -p 'ghdl '"$3"'; read_verilog -lib '"$LIBRARY_PATH"'custom_cells.v; setattr -set keep_hierarchy 1; synth -top '"$3"'; dfflibmap -liberty '"$LIBRARY_PATH"'custom_cells.lib; abc -liberty '"$LIBRARY_PATH"'custom_cells.lib; clean; stat -liberty '"$LIBRARY_PATH"'custom_cells.lib; setattr -set keep_hierarchy 0; flatten; select '"$3"'; insbuf -buf BUF A Y; write_verilog -noattr -selected design.v;';
elif [[ $1 == "VERILOG" || $1 == "verilog" || $1 == "Verilog" ]]
then
    # Run 1.) - 13.)
    yosys -p 'read_verilog '"$2"'*.v; read_verilog -lib '"$LIBRARY_PATH"'custom_cells.v; setattr -set keep_hierarchy 1; synth -top '"$3"'; dfflibmap -liberty '"$LIBRARY_PATH"'custom_cells.lib; abc -liberty '"$LIBRARY_PATH"'custom_cells.lib; opt_clean; stat -liberty '"$LIBRARY_PATH"'custom_cells.lib; setattr -set keep_hierarchy 0; flatten; select '"$3"'; insbuf -buf BUF A Y; write_verilog -noattr -selected design.v;';
else
    echo "Command " $1 " is not supported.";
fi
