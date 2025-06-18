-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Configuration                          --
--                                                                           --
-- Description: Configuration file binding the cntr entity to its            --
--              RTL architecture implementation.                             --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : cntr_rtl_cfg.vhd                                                   --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

CONFIGURATION cntr_rtl_cfg OF cntr IS
  FOR rtl
  END FOR;
END cntr_rtl_cfg;