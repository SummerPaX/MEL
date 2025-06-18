-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the entity declaration of the halfadder submodule    --
--              of the fulladder VHDL class example.                         --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : halfadder_.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity halfadder is
  port (a_i   : in  std_logic;  -- first data bit
        b_i   : in  std_logic;  -- second data bit
        sum_o : out std_logic;  -- sum of the data bits
        cy_o  : out std_logic); -- carry of the addition
end halfadder;
