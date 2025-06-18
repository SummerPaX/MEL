###############################################################################
# ModelSim Script - Fulladder Class Example, Compilation                      #
#                                                                             #
# Description: ModelSim do file, compiles design & testbench of Fulladder     #
#              example                                                        #
#                                                                             #
# Author : Paulus Summer, Matthias Brinskelle                                 #
# Date : 18.06.2025                                                           #
# File : compile.do                                                           #
###############################################################################

# compile design files of Fulladder class example
vcom ../vhdl/halfadder_.vhd
vcom ../vhdl/halfadder_rtl.vhd
vcom ../vhdl/halfadder_rtl_cfg.vhd
vcom ../vhdl/orgate_.vhd
vcom ../vhdl/orgate_rtl.vhd
vcom ../vhdl/orgate_rtl_cfg.vhd
vcom ../vhdl/fulladder_.vhd
vcom ../vhdl/fulladder_struc.vhd
vcom ../vhdl/fulladder_struc_cfg.vhd

# compile testbench of Fulladder class example
vcom ../tb/tb_fulladder_.vhd
vcom ../tb/tb_fulladder_sim.vhd
vcom ../tb/tb_fulladder_sim_cfg.vhd
