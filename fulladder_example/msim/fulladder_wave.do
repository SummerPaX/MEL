#################################################################
# ModelSim do file, defines signals to display in simulation
#                   of Fulladder example 
# Date: 2025-03-08
# Author: P. Roessler
#################################################################

onerror {resume}
add wave -noupdate -format logic /tb_fulladder/a_i
add wave -noupdate -format logic /tb_fulladder/b_i
add wave -noupdate -format logic /tb_fulladder/cy_i
add wave -noupdate -format logic /tb_fulladder/sum_o
add wave -noupdate -format logic /tb_fulladder/cy_o
