# MEL Counter Project - ModelSim Compilation Script
# 
# Description: Compiles all VHDL design and testbench files for the
#              MEL counter project in the correct order.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025
# File : compile.do

# Create work library
vlib work

# Compile design files (entities first, then architectures, then configurations)
echo "Compiling design entities..."
vcom -93 ../vhdl/io_ctrl_.vhd
vcom -93 ../vhdl/cntr_.vhd  
vcom -93 ../vhdl/cntr_top_.vhd

echo "Compiling design architectures..."
vcom -93 ../vhdl/io_ctrl_rtl.vhd
vcom -93 ../vhdl/cntr_rtl.vhd
vcom -93 ../vhdl/cntr_top_struc.vhd

echo "Compiling design configurations..."
vcom -93 ../vhdl/io_ctrl_rtl_cfg.vhd
vcom -93 ../vhdl/cntr_rtl_cfg.vhd
vcom -93 ../vhdl/cntr_top_struc_cfg.vhd

# Compile testbench files
echo "Compiling testbench entities..."
vcom -93 ../tb/tb_io_ctrl_.vhd
vcom -93 ../tb/tb_cntr_.vhd
vcom -93 ../tb/tb_cntr_top_.vhd

echo "Compiling testbench architectures..."
vcom -93 ../tb/tb_io_ctrl_sim.vhd
vcom -93 ../tb/tb_cntr_sim.vhd
vcom -93 ../tb/tb_cntr_top_sim.vhd

echo "Compiling testbench configurations..."
vcom -93 ../tb/tb_io_ctrl_sim_cfg.vhd
vcom -93 ../tb/tb_cntr_sim_cfg.vhd
vcom -93 ../tb/tb_cntr_top_sim_cfg.vhd

echo "Compilation completed successfully!"
