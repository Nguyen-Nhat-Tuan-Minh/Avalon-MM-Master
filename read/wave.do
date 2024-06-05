# # TOP-LEVEL TEMPLATE - BEGIN

set system_name      read_m
set QSYS_SIMDIR      $system_name/simulation 

# # Source the generated IP simulation script.
source $QSYS_SIMDIR/mentor/msim_setup.tcl
# #

# # Call command to compile the Quartus EDA simulation library.
dev_com

# # Call command to compile the Quartus-generated IP simulation files.
com

# # Add commands to compile all design files and testbench files, including
# # the top level. (These are all the files required for simulation other
# # than the files compiled by the Quartus-generated IP simulation script)

vlog -sv read_m_tb.sv

# # Set the top-level simulation or testbench module/entity name, which is
# # used by the elab command to elaborate the top level.

set TOP_LEVEL_NAME read_m

# # Call command to elaborate your design and testbench.
elab_debug

# # Add wave to simulation.
add wave *
#add wave -noupdate -format Logic -radix hexadecimal /ram_write_tb/ram_w_0/user_buffer_empty

# # Run the simulation.
run 100ns

# # Report success to the shell.
#exit -code 0