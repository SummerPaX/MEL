# MEL Counter Project - Top Level Simulation Script
#
# Description: Runs simulation for complete counter system testbench
#              with comprehensive waveform setup.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025
# File : sim_cntr_top.do

# Load testbench  
vsim work.tb_cntr_top_sim_cfg

# Add signals to waveform
add wave -divider "Clock and Reset"
add wave -radix binary sim:/tb_cntr_top/clk_tb
add wave -radix binary sim:/tb_cntr_top/reset_tb

add wave -divider "External I/O"
add wave -radix hex sim:/tb_cntr_top/sw_tb
add wave -radix hex sim:/tb_cntr_top/pb_tb
add wave -radix hex sim:/tb_cntr_top/ss_tb
add wave -radix binary sim:/tb_cntr_top/ss_sel_tb
add wave -radix hex sim:/tb_cntr_top/led_tb

add wave -divider "Switch Control Aliases"
add wave -radix binary sim:/tb_cntr_top/clear_sw
add wave -radix binary sim:/tb_cntr_top/down_sw
add wave -radix binary sim:/tb_cntr_top/up_sw
add wave -radix binary sim:/tb_cntr_top/run_stop_sw

add wave -divider "Internal Counter Values"
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/cntr0_o
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/cntr1_o
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/cntr2_o
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/cntr3_o

add wave -divider "Control Signals"
add wave -radix binary sim:/tb_cntr_top/dut/cntrup_s
add wave -radix binary sim:/tb_cntr_top/dut/cntrdown_s
add wave -radix binary sim:/tb_cntr_top/dut/cntrclear_s
add wave -radix binary sim:/tb_cntr_top/dut/cntrhold_s

add wave -divider "IO Control Internal"
add wave -radix hex sim:/tb_cntr_top/dut/swsync_s
add wave -radix binary sim:/tb_cntr_top/dut/i_io_ctrl/clk_1khz_en
add wave -radix unsigned sim:/tb_cntr_top/dut/i_io_ctrl/digit_sel

add wave -divider "Counter Internal"
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/count_enable
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/clk_div_cnt

# Configure wave window
configure wave -timelineunits ms
WaveRestoreZoom {0 ms} {100 ms}

# Run simulation
echo "Starting Top-Level System simulation..."
run 100 ms

echo "Top-Level System simulation completed."
