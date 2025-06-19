-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Testbench Configuration             --
--                                                                           --
-- Description: Configuration file for IO control unit testbench.            --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 19.06.2025                                                         --
-- File : tb_io_ctrl_sim_cfg.vhd                                             --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION tb_io_ctrl_sim_cfg OF tb_io_ctrl IS
  FOR sim
    FOR dut : io_ctrl
      USE CONFIGURATION work.io_ctrl_rtl_cfg;
    END FOR;
  END FOR;
END tb_io_ctrl_sim_cfg;