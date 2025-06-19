-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Structural Architecture                   --
--                                                                           --
-- Description: Structural implementation connecting IO control and          --
--              counter units. Maps control signals from switches            --
--              to counter inputs according to specification.                --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : cntr_top_struc.vhd                                                 --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ARCHITECTURE struc OF cntr_top IS

  -- Component declarations
  COMPONENT io_ctrl
    PORT (
      clk_i : IN STD_LOGIC;
      reset_i : IN STD_LOGIC;
      cntr0_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr1_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr2_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr3_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      led_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      sw_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      pb_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ss_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      ss_sel_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      led_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      swsync_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      pbsync_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT cntr
    PORT (
      clk_i : IN STD_LOGIC;
      reset_i : IN STD_LOGIC;
      cntrup_i : IN STD_LOGIC;
      cntrdown_i : IN STD_LOGIC;
      cntrclear_i : IN STD_LOGIC;
      cntrhold_i : IN STD_LOGIC;
      cntr0_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr1_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr2_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      cntr3_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
  END COMPONENT;
  -- Internal signals
  SIGNAL cntr_digits_s : STD_LOGIC_VECTOR(11 DOWNTO 0); -- 4 digits x 3 bits
  SIGNAL cntr0_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr1_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr2_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr3_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL swsync_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL pbsync_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL led_internal_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL cntrhold_s : STD_LOGIC;

BEGIN

  -- Signal assignments
  cntrhold_s <= NOT swsync_s(0);

  -- Component instantiation: IO control unit
  i_io_ctrl : io_ctrl
  PORT MAP(
    clk_i => clk_i,
    reset_i => reset_i,
    cntr0_i => cntr0_s,
    cntr1_i => cntr1_s,
    cntr2_i => cntr2_s,
    cntr3_i => cntr3_s,
    led_i => led_internal_s,
    sw_i => sw_i,
    pb_i => pb_i,
    ss_o => ss_o,
    ss_sel_o => ss_sel_o,
    led_o => led_o,
    swsync_o => swsync_s,
    pbsync_o => pbsync_s
  );
  -- Component instantiation: Counter unit
  i_cntr : cntr
  PORT MAP(
    clk_i => clk_i,
    reset_i => reset_i,
    cntrhold_i => cntrhold_s,
    cntrup_i => swsync_s(1),
    cntrdown_i => swsync_s(2),
    cntrclear_i => swsync_s(3),
    cntr0_o => cntr0_s,
    cntr1_o => cntr1_s,
    cntr2_o => cntr2_s,
    cntr3_o => cntr3_s
  );

  -- Show active switches on lower 4 LEDs
  led_internal_s(15 DOWNTO 4) <= (OTHERS => '0');
  led_internal_s(3 DOWNTO 0) <= swsync_s(3 DOWNTO 0);

END struc;