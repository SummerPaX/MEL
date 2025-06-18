-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the entity declaration of the orgate submodule       --
--              of the fulladder VHDL class example.                         --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : orgate_.vhd                                                        --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity orgate is
  port (a_i  : in  std_logic;  -- operand a
        b_i  : in  std_logic;  -- operand b
        or_o : out std_logic); -- output
end orgate;

