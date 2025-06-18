-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the architecture struc of the fulladder VHDL         --
--              class example.                                               --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : fulladder_struc.vhd                                                --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture struc of fulladder is

  component halfadder
    port (a_i   : in  std_logic;
          b_i   : in  std_logic;
          cy_o  : out std_logic;
          sum_o : out std_logic);
  end component;
  
  component orgate
    port (a_i  : in  std_logic;
          b_i  : in  std_logic;
          or_o : out std_logic);
  end component;

  -- Declare the signals used for interconnection of the submodules.
  signal s_sum1 : std_logic;
  signal s_cy1 : std_logic;
  signal s_cy2 : std_logic;

begin

  -- Instantiate the first halfadder, which is connected to
  -- the two data input ports of the fulladder
  i_halfadder1 : halfadder
  port map              
    (a_i   => a_i,
     b_i   => b_i,
     cy_o  => s_cy1,
     sum_o => s_sum1);

  -- Instantiate the second halfadder, which is connected to
  -- the sum output of i_halfadder1 and to the carry input port.
  i_halfadder2 : halfadder
  port map
    (a_i   => s_sum1,
     b_i   => cy_i,
     cy_o  => s_cy2,    
     sum_o => sum_o);

  -- This simple or gate deliveres the final carry flag.
  i_halfadder3 : orgate
  port map
    (a_i  => s_cy2,
     b_i  => s_cy1,
     or_o => cy_o); 

end struc;
