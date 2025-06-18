###############################################################################
# ModelSim Script - Fulladder Class Example, Wave Configuration               #
#                                                                             #
# Description: ModelSim do file, defines signals to display in simulation     #
#              of Fulladder example                                           #
#                                                                             #
# Author : Paulus Summer, Matthias Brinskelle                                 #
# Date : 18.06.2025                                                           #
# File : fulladder_wave.do                                                    #
###############################################################################

onerror {resume}
add wave -noupdate -format logic /tb_fulladder/a_i
add wave -noupdate -format logic /tb_fulladder/b_i
add wave -noupdate -format logic /tb_fulladder/cy_i
add wave -noupdate -format logic /tb_fulladder/sum_o
add wave -noupdate -format logic /tb_fulladder/cy_o
