-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Testbench Configuration           --
--                                                                           --
-- Description: Configuration file for IO control unit testbench.          --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : tb_io_ctrl_sim_cfg.vhd                                           --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_io_ctrl_sim_cfg of tb_io_ctrl is
  for sim
    for dut: io_ctrl
      use configuration work.io_ctrl_rtl_cfg;
    end for;
  end for;
end tb_io_ctrl_sim_cfg;
