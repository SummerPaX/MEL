-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Testbench Configuration               --
--                                                                           --
-- Description: Configuration file for the counter unit testbench.           --
--              Links the testbench entity with its simulation architecture  --
--              and specifies component bindings.                            --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 19.06.2025                                                         --
-- File : tb_cntr_sim_cfg.vhd                                               --
-------------------------------------------------------------------------------

CONFIGURATION tb_cntr_sim_cfg OF tb_cntr IS
  FOR sim
    FOR dut : cntr
      USE CONFIGURATION work.cntr_rtl_cfg;
    END FOR;
  END FOR;
END tb_cntr_sim_cfg;