-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Configuration                            --
--                                                                           --
-- Description: Configuration file binding the top-level entity to its      --
--              structural architecture and sub-component configurations.   --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : cntr_top_struc_cfg.vhd                                           --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION cntr_top_struc_cfg OF cntr_top IS
  FOR struc
    FOR i_io_ctrl : io_ctrl
      USE CONFIGURATION work.io_ctrl_rtl_cfg;
    END FOR;
    FOR i_cntr : cntr
      USE CONFIGURATION work.cntr_rtl_cfg;
    END FOR;
  END FOR;
END cntr_top_struc_cfg;