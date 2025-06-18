-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Entity                                --
--                                                                           --
-- Description: This is the entity declaration of the counter unit          --
--              for the MEL counter project. Implements 4-digit octal       --
--              up/down counter with 1 Hz counting frequency.               --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : cntr_.vhd                                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity cntr is
  port (
    -- Clock and Reset
    clk_i          : in  std_logic;                    -- System clock (100 MHz)
    reset_i        : in  std_logic;                    -- Asynchronous high active reset
    
    -- Control inputs
    cntrup_i       : in  std_logic;                    -- Count up enable
    cntrdown_i     : in  std_logic;                    -- Count down enable
    cntrclear_i    : in  std_logic;                    -- Clear counter to 0000
    cntrhold_i     : in  std_logic;                    -- Hold current value
    
    -- Counter digit outputs (3 bits each for octal)
    cntr0_o        : out std_logic_vector(2 downto 0); -- Digit 0 (LSB)
    cntr1_o        : out std_logic_vector(2 downto 0); -- Digit 1
    cntr2_o        : out std_logic_vector(2 downto 0); -- Digit 2
    cntr3_o        : out std_logic_vector(2 downto 0)  -- Digit 3 (MSB)
  );
end cntr;
