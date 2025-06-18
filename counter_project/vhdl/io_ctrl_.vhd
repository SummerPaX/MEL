-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Entity                             --
--                                                                           --
-- Description: This is the entity declaration of the IO control unit       --
--              for the MEL counter project. Handles all I/O operations     --
--              including switch debouncing and 7-segment display control.  --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : io_ctrl_.vhd                                                      --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity io_ctrl is
  port (
    -- Clock and Reset
    clk_i          : in  std_logic;                    -- System clock (100 MHz)
    reset_i        : in  std_logic;                    -- Asynchronous high active reset
    
    -- Counter digit inputs (from counter unit)
    cntr0_i        : in  std_logic_vector(2 downto 0); -- Digit 0 (LSB) - 3 bits for octal
    cntr1_i        : in  std_logic_vector(2 downto 0); -- Digit 1
    cntr2_i        : in  std_logic_vector(2 downto 0); -- Digit 2  
    cntr3_i        : in  std_logic_vector(2 downto 0); -- Digit 3 (MSB)
    
    -- LED input (from internal logic)
    led_i          : in  std_logic_vector(15 downto 0); -- State of 16 LEDs
    
    -- External inputs from FPGA board
    sw_i           : in  std_logic_vector(15 downto 0); -- 16 switches
    pb_i           : in  std_logic_vector(3 downto 0);  -- 4 push buttons
    
    -- External outputs to FPGA board  
    ss_o           : out std_logic_vector(7 downto 0);  -- 7-segment display segments
    ss_sel_o       : out std_logic_vector(3 downto 0);  -- 7-segment display selection
    led_o          : out std_logic_vector(15 downto 0); -- 16 LEDs
    
    -- Synchronized outputs (to internal logic)
    swsync_o       : out std_logic_vector(15 downto 0); -- Debounced switches
    pbsync_o       : out std_logic_vector(3 downto 0)   -- Debounced push buttons
  );
end io_ctrl;
