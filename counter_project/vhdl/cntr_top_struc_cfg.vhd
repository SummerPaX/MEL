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

library IEEE;
use IEEE.std_logic_1164.all;

configuration cntr_top_struc_cfg of cntr_top is
  for struc
    for i_io_ctrl: io_ctrl
      use configuration work.io_ctrl_rtl_cfg;
    end for;
    for i_cntr: cntr
      use configuration work.cntr_rtl_cfg;
    end for;
  end for;
end cntr_top_struc_cfg;
