-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Testbench Configuration                 --
--                                                                           --
-- Description: Configuration file for top-level system testbench.         --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : tb_cntr_top_sim_cfg.vhd                                          --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_cntr_top_sim_cfg of tb_cntr_top is
  for sim
    for dut: cntr_top
      use configuration work.cntr_top_struc_cfg;
    end for;
  end for;
end tb_cntr_top_sim_cfg;
