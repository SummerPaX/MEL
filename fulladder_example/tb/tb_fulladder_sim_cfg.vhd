-------------------------------------------------------------------------------
-- VHDL Class Example Fulladder, Design                                      --
--                                                                           --
-- Description: This is the configuration for the fulladder testbench        --
--              of the fulladder VHDL class example.                         --
--                                                                           --
-- Author : Paulus Summer, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : tb_fulladder_sim_cfg.vhd                                           --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_fulladder_sim_cfg of tb_fulladder is
  for sim
    for i_fulladder : fulladder
      use configuration work.fulladder_struc_cfg;
    end for;
  end for;
end tb_fulladder_sim_cfg;
