# MEL Counter Project - Basys3 FPGA Constraints File
#
# Description: Pin assignments and timing constraints for the MEL counter
#              project on the Digilent Basys3 FPGA development board.
#              Target device: xc7a35tcpg236-1 (Artix-7)
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025
# File : cntr_top_basys3.xdc

## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_i]

## Reset button (BTNC)
set_property PACKAGE_PIN U18 [get_ports reset_i]
set_property IOSTANDARD LVCMOS33 [get_ports reset_i]

## Switches (SW0-SW15)
set_property PACKAGE_PIN V17 [get_ports {sw_i[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw_i[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw_i[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw_i[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw_i[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw_i[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw_i[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw_i[7]}]
set_property PACKAGE_PIN V2 [get_ports {sw_i[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw_i[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw_i[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw_i[11]}]
set_property PACKAGE_PIN W2 [get_ports {sw_i[12]}]
set_property PACKAGE_PIN U1 [get_ports {sw_i[13]}]
set_property PACKAGE_PIN T1 [get_ports {sw_i[14]}]
set_property PACKAGE_PIN R2 [get_ports {sw_i[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[*]}]

## Push buttons (BTNL, BTNU, BTNR, BTND)
set_property PACKAGE_PIN W19 [get_ports {pb_i[0]}]  # BTNL
set_property PACKAGE_PIN T17 [get_ports {pb_i[1]}]  # BTNU  
set_property PACKAGE_PIN T18 [get_ports {pb_i[2]}]  # BTNR
set_property PACKAGE_PIN U17 [get_ports {pb_i[3]}]  # BTND
set_property IOSTANDARD LVCMOS33 [get_ports {pb_i[*]}]

## LEDs (LD0-LD15)
set_property PACKAGE_PIN U16 [get_ports {led_o[0]}]
set_property PACKAGE_PIN E19 [get_ports {led_o[1]}]
set_property PACKAGE_PIN U19 [get_ports {led_o[2]}]
set_property PACKAGE_PIN V19 [get_ports {led_o[3]}]
set_property PACKAGE_PIN W18 [get_ports {led_o[4]}]
set_property PACKAGE_PIN U15 [get_ports {led_o[5]}]
set_property PACKAGE_PIN U14 [get_ports {led_o[6]}]
set_property PACKAGE_PIN V14 [get_ports {led_o[7]}]
set_property PACKAGE_PIN V13 [get_ports {led_o[8]}]
set_property PACKAGE_PIN V3 [get_ports {led_o[9]}]
set_property PACKAGE_PIN W3 [get_ports {led_o[10]}]
set_property PACKAGE_PIN U3 [get_ports {led_o[11]}]
set_property PACKAGE_PIN P3 [get_ports {led_o[12]}]
set_property PACKAGE_PIN N3 [get_ports {led_o[13]}]
set_property PACKAGE_PIN P1 [get_ports {led_o[14]}]
set_property PACKAGE_PIN L1 [get_ports {led_o[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]

## 7-segment display segments (CA-CG, DP)
set_property PACKAGE_PIN W7 [get_ports {ss_o[0]}]   # CA
set_property PACKAGE_PIN W6 [get_ports {ss_o[1]}]   # CB
set_property PACKAGE_PIN U8 [get_ports {ss_o[2]}]   # CC
set_property PACKAGE_PIN V8 [get_ports {ss_o[3]}]   # CD
set_property PACKAGE_PIN U5 [get_ports {ss_o[4]}]   # CE
set_property PACKAGE_PIN V5 [get_ports {ss_o[5]}]   # CF
set_property PACKAGE_PIN U7 [get_ports {ss_o[6]}]   # CG
set_property PACKAGE_PIN V7 [get_ports {ss_o[7]}]   # DP
set_property IOSTANDARD LVCMOS33 [get_ports {ss_o[*]}]

## 7-segment display anodes (AN0-AN3)
set_property PACKAGE_PIN U2 [get_ports {ss_sel_o[0]}]  # AN0
set_property PACKAGE_PIN U4 [get_ports {ss_sel_o[1]}]  # AN1
set_property PACKAGE_PIN V4 [get_ports {ss_sel_o[2]}]  # AN2
set_property PACKAGE_PIN W4 [get_ports {ss_sel_o[3]}]  # AN3
set_property IOSTANDARD LVCMOS33 [get_ports {ss_sel_o[*]}]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Timing constraints
# Clock groups (if needed for multiple clock domains)
# set_clock_groups -asynchronous -group [get_clocks sys_clk_pin]

## False paths for asynchronous reset
set_false_path -from [get_ports reset_i]

## Input delays for switch and button inputs (assuming no external timing requirements)
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.0 [get_ports {sw_i[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.0 [get_ports {sw_i[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.0 [get_ports {pb_i[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.0 [get_ports {pb_i[*]}]

## Output delays for LED and 7-segment outputs
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.0 [get_ports {led_o[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.0 [get_ports {led_o[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.0 [get_ports {ss_o[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.0 [get_ports {ss_o[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.0 [get_ports {ss_sel_o[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.0 [get_ports {ss_sel_o[*]}]
