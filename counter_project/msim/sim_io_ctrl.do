# MEL Counter Project - IO Control Unit Simulation Script
#
# Description: Runs simulation for IO control unit testbench
#              with appropriate waveform setup.
#
# Author : Summer Paulus, Matthias Brinskelle  
# Date : 18.06.2025
# File : sim_io_ctrl.do

# Load testbench
vsim work.tb_io_ctrl_sim_cfg

# Add signals to waveform
add wave -divider "Clock and Reset"
add wave -radix binary sim:/tb_io_ctrl/clk_tb
add wave -radix binary sim:/tb_io_ctrl/reset_tb

add wave -divider "Input Signals"
add wave -radix hex sim:/tb_io_ctrl/cntr0_tb
add wave -radix hex sim:/tb_io_ctrl/cntr1_tb  
add wave -radix hex sim:/tb_io_ctrl/cntr2_tb
add wave -radix hex sim:/tb_io_ctrl/cntr3_tb
add wave -radix hex sim:/tb_io_ctrl/sw_tb
add wave -radix hex sim:/tb_io_ctrl/pb_tb
add wave -radix hex sim:/tb_io_ctrl/led_i_tb

add wave -divider "Output Signals" 
add wave -radix hex sim:/tb_io_ctrl/ss_tb
add wave -radix binary sim:/tb_io_ctrl/ss_sel_tb
add wave -radix hex sim:/tb_io_ctrl/led_o_tb
add wave -radix hex sim:/tb_io_ctrl/swsync_tb
add wave -radix hex sim:/tb_io_ctrl/pbsync_tb

add wave -divider "Internal Signals"
add wave -radix binary sim:/tb_io_ctrl/dut/clk_1khz
add wave -radix unsigned sim:/tb_io_ctrl/dut/clk_div_cnt
add wave -radix unsigned sim:/tb_io_ctrl/dut/digit_sel
add wave -radix hex sim:/tb_io_ctrl/dut/current_digit

# Configure wave window
configure wave -timelineunits ns
WaveRestoreZoom {0 ns} {50 ms}

# Run simulation
echo "Starting IO Control Unit simulation..."
run 50 ms

echo "IO Control Unit simulation completed."
