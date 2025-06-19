# MEL Counter Project - Top Level Simulation Script
#
# Description: Runs simulation for complete counter system testbench
#              with comprehensive waveform setup.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 19.06.2025
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
add wave -radix hex sim:/tb_cntr_top/led_tb

add wave -divider "Switch Control Signals"
add wave -radix binary sim:/tb_cntr_top/clear_sw
add wave -radix binary sim:/tb_cntr_top/down_sw
add wave -radix binary sim:/tb_cntr_top/up_sw
add wave -radix binary sim:/tb_cntr_top/run_stop_sw

add wave -divider "7-Segment Display"
add wave -radix ascii sim:/tb_cntr_top/current_digit_name
add wave -radix ascii sim:/tb_cntr_top/active_digit_name
add wave -radix hex sim:/tb_cntr_top/ss_tb
add wave -radix binary sim:/tb_cntr_top/ss_sel_tb

add wave -divider "Internal Counter Values"
add wave -radix unsigned sim:/tb_cntr_top/dut/cntr0_s
add wave -radix unsigned sim:/tb_cntr_top/dut/cntr1_s
add wave -radix unsigned sim:/tb_cntr_top/dut/cntr2_s
add wave -radix unsigned sim:/tb_cntr_top/dut/cntr3_s

add wave -divider "Control Signals"
add wave -radix hex sim:/tb_cntr_top/dut/swsync_s
add wave -radix binary sim:/tb_cntr_top/dut/swsync_s(0)
add wave -radix binary sim:/tb_cntr_top/dut/swsync_s(1)
add wave -radix binary sim:/tb_cntr_top/dut/swsync_s(2)
add wave -radix binary sim:/tb_cntr_top/dut/swsync_s(3)
add wave -radix binary sim:/tb_cntr_top/dut/cntrhold_s

add wave -divider "IO Control Internal"
add wave -radix binary sim:/tb_cntr_top/dut/i_io_ctrl/clk_1khz_en
add wave -radix unsigned sim:/tb_cntr_top/dut/i_io_ctrl/digit_sel

add wave -divider "Counter Internal"
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/count_enable
add wave -radix unsigned sim:/tb_cntr_top/dut/i_cntr/clk_div_cnt
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/clear_active
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/count_up
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/count_down
add wave -radix binary sim:/tb_cntr_top/dut/i_cntr/hold_count

# Configure wave window
configure wave -timelineunits ns
WaveRestoreZoom {0 ns} {1210 us}

# Run simulation
echo "Starting Top-Level System simulation..."
run 1200 us

echo "Top-Level System simulation completed."
