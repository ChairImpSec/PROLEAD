LIBRARY_PATH="../lib/"

# Command line arguments:
# $1: The projects hardware description language (either VHDL or Verilog)
# $2: The path to the rtl code. All files must be in one directory
# $3: The name of the top module

if [[ $1 == "VHDL" || $1 == "vhdl" || $1 == "Vhdl" ]]; 
then
    ghdl -a $2*.vhd
    yosys -m ghdl -p 'ghdl '"$3"'; read_verilog -lib '"$LIBRARY_PATH"'custom_cells.v; setattr -set keep_hierarchy 1; synth -top '"$3"'; dfflibmap -liberty '"$LIBRARY_PATH"'custom_cells.lib; abc -liberty '"$LIBRARY_PATH"'custom_cells.lib; clean; stat -liberty '"$LIBRARY_PATH"'custom_cells.lib; setattr -set keep_hierarchy 0; flatten; select '"$3"'; insbuf -buf BUF A Y; write_verilog -noattr -selected design.v;';
elif [[ $1 == "VERILOG" || $1 == "verilog" || $1 == "Verilog" ]]
then
    yosys -m ghdl -p 'read_verilog '"$2"'*.v; read_verilog -lib '"$LIBRARY_PATH"'custom_cells.v; setattr -set keep_hierarchy 1; synth -top '"$3"'; dfflibmap -liberty '"$LIBRARY_PATH"'custom_cells.lib; abc -liberty '"$LIBRARY_PATH"'custom_cells.lib; opt_clean; stat -liberty '"$LIBRARY_PATH"'custom_cells.lib; setattr -set keep_hierarchy 0; flatten; select '"$3"'; insbuf -buf BUF A Y; write_verilog -noattr -selected design.v;';
else
    echo "Command " $1 " is not supported.";
fi
