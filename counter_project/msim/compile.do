# MEL Counter Project - ModelSim Compilation Script
# 
# Description: Compiles all VHDL design and testbench files.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025
# File : compile.do

# Create work library
vlib work

echo "Compiling configuration package..."
vcom ../vhdl/config_pkg.vhd

echo "Compiling design entities..."
vcom ../vhdl/io_ctrl_.vhd
vcom ../vhdl/cntr_.vhd  
vcom ../vhdl/cntr_top_.vhd

echo "Compiling design architectures..."
vcom ../vhdl/io_ctrl_rtl.vhd
vcom ../vhdl/cntr_rtl.vhd
vcom ../vhdl/cntr_top_struc.vhd

echo "Compiling design configurations..."
vcom ../vhdl/io_ctrl_rtl_cfg.vhd
vcom ../vhdl/cntr_rtl_cfg.vhd
vcom ../vhdl/cntr_top_struc_cfg.vhd

echo "Compiling testbench entities..."
vcom ../tb/tb_io_ctrl_.vhd
vcom ../tb/tb_cntr_.vhd
vcom ../tb/tb_cntr_top_.vhd

echo "Compiling testbench architectures..."
vcom ../tb/tb_io_ctrl_sim.vhd
vcom ../tb/tb_cntr_sim.vhd
vcom ../tb/tb_cntr_top_sim.vhd

echo "Compiling testbench configurations..."
vcom ../tb/tb_io_ctrl_sim_cfg.vhd
vcom ../tb/tb_cntr_sim_cfg.vhd
vcom ../tb/tb_cntr_top_sim_cfg.vhd

echo "Compilation completed successfully!"
