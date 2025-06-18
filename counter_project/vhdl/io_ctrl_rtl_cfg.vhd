-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Configuration                      --
--                                                                           --
-- Description: Configuration file binding the io_ctrl entity to its        --
--              RTL architecture implementation.                            --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : io_ctrl_rtl_cfg.vhd                                              --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration io_ctrl_rtl_cfg of io_ctrl is
  for rtl
  end for;
end io_ctrl_rtl_cfg;
