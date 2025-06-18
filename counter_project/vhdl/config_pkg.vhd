-------------------------------------------------------------------------------
-- MEL Counter Project - Configuration Package                               --
--                                                                           --
-- Description: Global configuration package containing all timing and       --
--              frequency constants for the counter project. Provides        --
--              centralized control of clock frequencies, count rates,       --
--              and derived timing parameters for easy testing.              --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : config_pkg.vhd                                                     --
-------------------------------------------------------------------------------

PACKAGE config_pkg IS
  CONSTANT CLK_FREQ : INTEGER := 100_000_000; -- 100 MHz system clock
  CONSTANT COUNT_FREQ : INTEGER := 1; -- 1 Hz counting frequency
  CONSTANT DIV_COUNT : INTEGER := CLK_FREQ / COUNT_FREQ - 1; -- 99999999
  CONSTANT REFRESH_FREQ : INTEGER := 1_000; -- 1 kHz for IO refresh
  CONSTANT IO_DIV_COUNT : INTEGER := CLK_FREQ / REFRESH_FREQ - 1; -- 99999
  CONSTANT CLK_PERIOD : TIME := 1 sec / CLK_FREQ; -- Auto-calculated period
END PACKAGE;

-- Configuration package for the Simulation
-- PACKAGE config_pkg IS
--   CONSTANT CLK_FREQ : INTEGER := 100_000_000; -- 100 MHz system clock
--   CONSTANT COUNT_FREQ : INTEGER := 10_000_000; -- 1 Hz counting frequency
--   CONSTANT DIV_COUNT : INTEGER := CLK_FREQ / COUNT_FREQ - 1; -- 99999999
--   CONSTANT REFRESH_FREQ : INTEGER := 1_000; -- 1 kHz for IO refresh
--   CONSTANT IO_DIV_COUNT : INTEGER := CLK_FREQ / REFRESH_FREQ - 1; -- 99999
--   CONSTANT CLK_PERIOD : TIME := 1 sec / CLK_FREQ; -- Auto-calculated period
-- END PACKAGE;