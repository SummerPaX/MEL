-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Entity                                 --
--                                                                           --
-- Description: This is the entity declaration of the counter unit.          --
--              Implements 4-digit octal up/down counter.                    --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : cntr_.vhd                                                          --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cntr IS
  PORT (
    -- Clock and Reset
    clk_i : IN STD_LOGIC; -- System clock (100 MHz)
    reset_i : IN STD_LOGIC; -- Asynchronous high active reset

    -- Control inputs
    cntrup_i : IN STD_LOGIC; -- Count up enable
    cntrdown_i : IN STD_LOGIC; -- Count down enable
    cntrclear_i : IN STD_LOGIC; -- Clear counter to 0000
    cntrhold_i : IN STD_LOGIC; -- Hold current value

    -- Counter digit outputs (3 bits each for octal)
    cntr0_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 0 (LSB)
    cntr1_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 1
    cntr2_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Digit 2
    cntr3_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) -- Digit 3 (MSB)
  );
END cntr;