# MEL Counter Project - IO Control Unit Simulation Script
#
# Description: Runs simulation for IO control unit testbench.
#
# Author : Summer Paulus, Matthias Brinskelle  
# Date : 19.06.2025
# File : sim_io_ctrl.do

# Load testbench
vsim work.tb_io_ctrl_sim_cfg

# Add signals to waveform
add wave -divider "Clock and Reset"
add wave -radix binary sim:/tb_io_ctrl/clk_tb
add wave -radix binary sim:/tb_io_ctrl/reset_tb

add wave -divider "Input Signals"
add wave -radix octal sim:/tb_io_ctrl/cntr0_tb
add wave -radix octal sim:/tb_io_ctrl/cntr1_tb  
add wave -radix octal sim:/tb_io_ctrl/cntr2_tb
add wave -radix octal sim:/tb_io_ctrl/cntr3_tb
add wave -radix hex sim:/tb_io_ctrl/sw_tb
add wave -radix binary sim:/tb_io_ctrl/pb_tb
add wave -radix hex sim:/tb_io_ctrl/led_i_tb

add wave -divider "LED Output"
add wave -radix hex sim:/tb_io_ctrl/led_o_tb

add wave -divider "Debounced Outputs" 
add wave -radix hex sim:/tb_io_ctrl/swsync_tb
add wave -radix binary sim:/tb_io_ctrl/pbsync_tb

add wave -divider "7-Segment Display"
add wave -radix ascii sim:/tb_io_ctrl/current_digit_name
add wave -radix ascii sim:/tb_io_ctrl/active_digit_name
add wave -radix hex sim:/tb_io_ctrl/ss_tb
add wave -radix binary sim:/tb_io_ctrl/ss_sel_tb


add wave -divider "Internal Signals"
add wave -radix binary sim:/tb_io_ctrl/dut/clk_1khz_en
add wave -radix decimal sim:/tb_io_ctrl/dut/clk_en_cnt
add wave -radix binary sim:/tb_io_ctrl/dut/digit_sel
add wave -radix octal sim:/tb_io_ctrl/dut/current_digit

# Configure wave window
configure wave -timelineunits ns
WaveRestoreZoom {0 us} {31 us}

# Run simulation
echo "Starting IO Control Unit simulation..."
run 30 us

echo "IO Control Unit simulation completed."
