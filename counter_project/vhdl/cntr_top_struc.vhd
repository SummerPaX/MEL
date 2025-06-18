-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Structural Architecture                  --
--                                                                           --
-- Description: Structural implementation connecting IO control and          --
--              counter units. Maps control signals from switches           --
--              to counter inputs according to specification.               --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : cntr_top_struc.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture struc of cntr_top is

  -- Component declarations
  component io_ctrl
    port (
      clk_i          : in  std_logic;
      reset_i        : in  std_logic;
      cntr0_i        : in  std_logic_vector(2 downto 0);
      cntr1_i        : in  std_logic_vector(2 downto 0);
      cntr2_i        : in  std_logic_vector(2 downto 0);
      cntr3_i        : in  std_logic_vector(2 downto 0);
      led_i          : in  std_logic_vector(15 downto 0);
      sw_i           : in  std_logic_vector(15 downto 0);
      pb_i           : in  std_logic_vector(3 downto 0);
      ss_o           : out std_logic_vector(7 downto 0);
      ss_sel_o       : out std_logic_vector(3 downto 0);
      led_o          : out std_logic_vector(15 downto 0);
      swsync_o       : out std_logic_vector(15 downto 0);
      pbsync_o       : out std_logic_vector(3 downto 0)
    );
  end component;
  
  component cntr
    port (
      clk_i          : in  std_logic;
      reset_i        : in  std_logic;
      cntrup_i       : in  std_logic;
      cntrdown_i     : in  std_logic;
      cntrclear_i    : in  std_logic;
      cntrhold_i     : in  std_logic;
      cntr0_o        : out std_logic_vector(2 downto 0);
      cntr1_o        : out std_logic_vector(2 downto 0);
      cntr2_o        : out std_logic_vector(2 downto 0);
      cntr3_o        : out std_logic_vector(2 downto 0)
    );
  end component;
  
  -- Internal signals
  signal cntr_digits_s  : std_logic_vector(11 downto 0); -- 4 digits x 3 bits
  signal cntr0_s        : std_logic_vector(2 downto 0);
  signal cntr1_s        : std_logic_vector(2 downto 0);
  signal cntr2_s        : std_logic_vector(2 downto 0);
  signal cntr3_s        : std_logic_vector(2 downto 0);
  signal swsync_s       : std_logic_vector(15 downto 0);
  signal pbsync_s       : std_logic_vector(3 downto 0);
  signal led_internal_s : std_logic_vector(15 downto 0);
  
  -- Control signals mapping
  -- According to assignment: SW(0)=Clear, SW(1)=Down, SW(2)=Up, SW(3)=Run/Stop
  signal clear_s        : std_logic;
  signal down_s         : std_logic;
  signal up_s           : std_logic;
  signal run_stop_s     : std_logic;
  
  -- Counter control signals
  signal cntrup_s       : std_logic;
  signal cntrdown_s     : std_logic;
  signal cntrclear_s    : std_logic;
  signal cntrhold_s     : std_logic;

begin

  -- Component instantiation: IO control unit
  i_io_ctrl: io_ctrl
    port map (
      clk_i      => clk_i,
      reset_i    => reset_i,
      cntr0_i    => cntr0_s,
      cntr1_i    => cntr1_s,
      cntr2_i    => cntr2_s,
      cntr3_i    => cntr3_s,
      led_i      => led_internal_s,
      sw_i       => sw_i,
      pb_i       => pb_i,
      ss_o       => ss_o,
      ss_sel_o   => ss_sel_o,
      led_o      => led_o,
      swsync_o   => swsync_s,
      pbsync_o   => pbsync_s
    );
    
  -- Component instantiation: Counter unit
  i_cntr: cntr
    port map (
      clk_i       => clk_i,
      reset_i     => reset_i,
      cntrup_i    => cntrup_s,
      cntrdown_i  => cntrdown_s,
      cntrclear_i => cntrclear_s,
      cntrhold_i  => cntrhold_s,
      cntr0_o     => cntr0_s,
      cntr1_o     => cntr1_s,
      cntr2_o     => cntr2_s,
      cntr3_o     => cntr3_s
    );
  
  -- Switch assignments according to specification
  -- SW(0) = Clear, SW(1) = Down, SW(2) = Up, SW(3) = Run/Stop
  clear_s     <= swsync_s(0);
  down_s      <= swsync_s(1);
  up_s        <= swsync_s(2);
  run_stop_s  <= swsync_s(3);
  
  -- Control logic according to truth table:
  -- Clear | Run/Stop | Up | Down | Function
  --   1   |    X     | X  |  X   | Clear to 0000
  --   0   |    1     | 1  |  X   | Count Up  
  --   0   |    1     | 0  |  1   | Count Down
  --   0   | others   |    |      | Hold Value
  
  cntrclear_s <= clear_s;
  cntrup_s    <= (not clear_s) and run_stop_s and up_s;
  cntrdown_s  <= (not clear_s) and run_stop_s and (not up_s) and down_s;
  cntrhold_s  <= (not clear_s) and (not run_stop_s or (not up_s and not down_s));
  
  -- LED display shows switch states for debugging
  -- Show active switches on lower 4 LEDs
  led_internal_s <= (others => '0');
  led_internal_s(3 downto 0) <= run_stop_s & up_s & down_s & clear_s;

end struc;
