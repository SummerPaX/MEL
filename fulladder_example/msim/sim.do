###############################################################################
# ModelSim Script - Fulladder Class Example, Simulation                       #
#                                                                             #
# Description: ModelSim do file, simulates Fulladder example                  #
#                                                                             #
# Author : Paulus Summer, Matthias Brinskelle                                 #
# Date : 18.06.2025                                                           #
# File : sim.do                                                               #
###############################################################################

vsim -t ns -lib work work.tb_fulladder_sim_cfg
view *
do fulladder_wave.do # define signals to display in Wave window  
run 3000 ns
