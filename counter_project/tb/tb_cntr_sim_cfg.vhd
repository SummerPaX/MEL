-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Testbench Configuration              --
--                                                                           --
-- Description: Configuration file for counter unit testbench.             --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : tb_cntr_sim_cfg.vhd                                              --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_cntr_sim_cfg of tb_cntr is
  for sim
    for dut: cntr
      use configuration work.cntr_rtl_cfg;
    end for;
  end for;
end tb_cntr_sim_cfg;
