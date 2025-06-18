-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the architecture rtl of the orgate submodule         --
--              of the fulladder VHDL class example.                         --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : orgate_rtl.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture rtl of orgate is
begin
  -- generate the output or_o
  or_o <= a_i or b_i;
end rtl;
