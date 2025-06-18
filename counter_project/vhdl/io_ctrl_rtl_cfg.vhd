-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Configuration                       --
--                                                                           --
-- Description: Configuration file binding the io_ctrl entity to its         --
--              RTL architecture implementation.                             --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : io_ctrl_rtl_cfg.vhd                                                --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION io_ctrl_rtl_cfg OF io_ctrl IS
  FOR rtl
  END FOR;
END io_ctrl_rtl_cfg;