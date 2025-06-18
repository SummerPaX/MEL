-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the architecture rtl of the halfadder submodule      --
--              of the fulladder VHDL class example.                         --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : halfadder_rtl.vhd                                                  --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture rtl of halfadder is
begin
  sum_o <= a_i xor b_i; -- sum of the data bits
  cy_o  <= a_i and b_i; -- carry of the addition
end rtl;
