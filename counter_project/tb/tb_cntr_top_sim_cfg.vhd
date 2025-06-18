-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Testbench Configuration                   --
--                                                                           --
-- Description: Configuration file for top-level system testbench.           --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : tb_cntr_top_sim_cfg.vhd                                            --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION tb_cntr_top_sim_cfg OF tb_cntr_top IS
  FOR sim
    FOR dut : cntr_top
      USE CONFIGURATION work.cntr_top_struc_cfg;
    END FOR;
  END FOR;
END tb_cntr_top_sim_cfg;