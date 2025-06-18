-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Testbench Configuration                --
--                                                                           --
-- Description: Configuration file for counter unit testbench.               --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : tb_cntr_sim_cfg.vhd                                                --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION tb_cntr_sim_cfg OF tb_cntr IS
  FOR sim
    FOR dut : cntr
      USE CONFIGURATION work.cntr_rtl_cfg;
    END FOR;
  END FOR;
END tb_cntr_sim_cfg;