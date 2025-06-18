-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Entity                                    --
--                                                                           --
-- Description: This is the top-level entity declaration.                    --
--              Connects to all FPGA I/O pins and                            --
--              integrates IO control and counter units.                     --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : cntr_top_.vhd                                                      --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cntr_top IS
  PORT (
    -- Clock and Reset
    clk_i : IN STD_LOGIC; -- System clock (100 MHz)
    reset_i : IN STD_LOGIC; -- Asynchronous high active reset

    -- External FPGA board I/O
    sw_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16 switches
    pb_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 push buttons
    ss_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 7-segment display segments
    ss_sel_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- 7-segment display selection
    led_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- 16 LEDs
  );
END cntr_top;