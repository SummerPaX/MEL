-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Entity                              --
--                                                                           --
-- Description: This is the entity declaration of the IO control unit.       --
--              Handles all I/O operations including switch debouncing       --
--              and 7-segment display control.                               --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : io_ctrl_.vhd                                                       --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY io_ctrl IS
  PORT (
    -- Clock and Reset
    clk_i : IN STD_LOGIC; -- System clock (100 MHz)
    reset_i : IN STD_LOGIC; -- Asynchronous high active reset

    -- Counter digit inputs (from counter unit)
    cntr0_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 0 (LSB) - 3 bits for octal
    cntr1_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 1
    cntr2_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 2  
    cntr3_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 3 (MSB)

    -- LED input (from internal logic)
    led_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- State of 16 LEDs

    -- External inputs from FPGA board
    sw_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16 switches
    pb_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 push buttons

    -- External outputs to FPGA board  
    ss_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 7-segment display segments
    ss_sel_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- 7-segment display selection
    led_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16 LEDs

    -- Synchronized outputs (to internal logic)
    swsync_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Debounced switches
    pbsync_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- Debounced push buttons
  );
END io_ctrl;