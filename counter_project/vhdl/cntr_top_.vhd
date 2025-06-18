-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Entity                                   --
--                                                                           --
-- Description: This is the top-level entity declaration for the MEL        --
--              counter project. Connects to all FPGA I/O pins and          --
--              integrates IO control and counter units.                    --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : cntr_top_.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity cntr_top is
  port (
    -- Clock and Reset
    clk_i          : in  std_logic;                    -- System clock (100 MHz)
    reset_i        : in  std_logic;                    -- Asynchronous high active reset
    
    -- External FPGA board I/O
    sw_i           : in  std_logic_vector(15 downto 0); -- 16 switches
    pb_i           : in  std_logic_vector(3 downto 0);  -- 4 push buttons
    ss_o           : out std_logic_vector(7 downto 0);  -- 7-segment display segments
    ss_sel_o       : out std_logic_vector(3 downto 0);  -- 7-segment display selection
    led_o          : out std_logic_vector(15 downto 0)  -- 16 LEDs
  );
end cntr_top;
