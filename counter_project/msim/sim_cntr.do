# MEL Counter Project - Counter Unit Simulation Script
#
# Description: Runs simulation for counter unit testbench
#              with appropriate waveform setup.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025  
# File : sim_cntr.do

# Load testbench
vsim work.tb_cntr_sim_cfg

# Add signals to waveform
add wave -divider "Clock and Reset"
add wave -radix binary sim:/tb_cntr/clk_tb
add wave -radix binary sim:/tb_cntr/reset_tb

add wave -divider "Control Inputs"
add wave -radix binary sim:/tb_cntr/cntrup_tb
add wave -radix binary sim:/tb_cntr/cntrdown_tb
add wave -radix binary sim:/tb_cntr/cntrclear_tb
add wave -radix binary sim:/tb_cntr/cntrhold_tb

add wave -divider "Counter Outputs"
add wave -radix unsigned sim:/tb_cntr/cntr0_tb
add wave -radix unsigned sim:/tb_cntr/cntr1_tb
add wave -radix unsigned sim:/tb_cntr/cntr2_tb
add wave -radix unsigned sim:/tb_cntr/cntr3_tb
add wave -radix hex sim:/tb_cntr/counter_value

add wave -divider "Internal Signals"
add wave -radix binary sim:/tb_cntr/dut/count_enable
add wave -radix unsigned sim:/tb_cntr/dut/clk_div_cnt
add wave -radix binary sim:/tb_cntr/dut/clear_active
add wave -radix binary sim:/tb_cntr/dut/count_up
add wave -radix binary sim:/tb_cntr/dut/count_down
add wave -radix binary sim:/tb_cntr/dut/carry0
add wave -radix binary sim:/tb_cntr/dut/carry1
add wave -radix binary sim:/tb_cntr/dut/carry2

# Configure wave window
configure wave -timelineunits ns
WaveRestoreZoom {0 ns} {20 us}

# Run simulation
echo "Starting Counter Unit simulation..."
run 20 us

echo "Counter Unit simulation completed."
