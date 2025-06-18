################################################
# ModelSim do file, simulates Fulladder example
# Date: 2025-03-08
# Author: P. Roessler
################################################

vsim -t ns -lib work work.tb_fulladder_sim_cfg  
view *
do fulladder_wave.do # define signals to display in Wave window  
run 3000 ns
