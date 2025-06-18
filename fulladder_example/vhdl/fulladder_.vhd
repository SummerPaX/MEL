-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the entity declaration of the fulladder              --
--              VHDL class example.                                          --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : fulladder_.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
  port (a_i   : in  std_logic;  -- first data bit
        b_i   : in  std_logic;  -- second data bit
        cy_i  : in  std_logic;  -- carry input
        cy_o  : out std_logic;  -- carry output
        sum_o : out std_logic); -- sum output
end fulladder;