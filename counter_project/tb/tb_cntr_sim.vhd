-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit Testbench Implementation               --
--                                                                           --
-- Description: Comprehensive testbench for counter unit including           --
--              up/down counting, clear functionality, hold operation,       --
--              wraparound behavior, and priority control verification.      --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 19.06.2025                                                         --
-- File : tb_cntr_sim.vhd                                                    --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE sim OF tb_cntr IS

  -- Component declaration
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

  CONSTANT CNTR_CLK_PERIOD : TIME := 1 sec / COUNT_FREQ;

  -- Clock and reset
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL reset_tb : STD_LOGIC := '1';

  -- Input control signals
  SIGNAL cntrup_tb : STD_LOGIC := '0';
  SIGNAL cntrdown_tb : STD_LOGIC := '0';
  SIGNAL cntrclear_tb : STD_LOGIC := '0';
  SIGNAL cntrhold_tb : STD_LOGIC := '0';

  -- Output signals
  SIGNAL cntr0_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr1_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr2_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL cntr3_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Helper signals for readable counter display
  SIGNAL counter_value : INTEGER;
  SIGNAL counter_string : STRING(1 TO 4);

BEGIN

  -- Device under test instantiation
  dut : cntr
  PORT MAP(
    clk_i => clk_tb,
    reset_i => reset_tb,
    cntrup_i => cntrup_tb,
    cntrdown_i => cntrdown_tb,
    cntrclear_i => cntrclear_tb,
    cntrhold_i => cntrhold_tb,
    cntr0_o => cntr0_tb,
    cntr1_o => cntr1_tb,
    cntr2_o => cntr2_tb,
    cntr3_o => cntr3_tb
  );

  -- Clock generation
  clk_process : PROCESS
  BEGIN
    WHILE true LOOP
      clk_tb <= '0';
      WAIT FOR CLK_PERIOD / 2;
      clk_tb <= '1';
      WAIT FOR CLK_PERIOD / 2;
    END LOOP;
  END PROCESS;

  -- Convert counter digits to readable integer value
  proc_counter_display : PROCESS (cntr3_tb, cntr2_tb, cntr1_tb, cntr0_tb)
  BEGIN
    counter_value <= to_integer(unsigned(cntr3_tb)) * 512 +
      to_integer(unsigned(cntr2_tb)) * 64 +
      to_integer(unsigned(cntr1_tb)) * 8 +
      to_integer(unsigned(cntr0_tb));

    -- Convert to octal string representation
    counter_string <= CHARACTER'val(48 + to_integer(unsigned(cntr3_tb))) &
      CHARACTER'val(48 + to_integer(unsigned(cntr2_tb))) &
      CHARACTER'val(48 + to_integer(unsigned(cntr1_tb))) &
      CHARACTER'val(48 + to_integer(unsigned(cntr0_tb)));
  END PROCESS proc_counter_display;

  -- Stimulus process
  stim_process : PROCESS
  BEGIN
    -- Initial reset
    reset_tb <= '1';
    WAIT FOR CLK_PERIOD * 10;
    reset_tb <= '0';

    REPORT "Starting Counter Unit Testbench";
    REPORT "Test 1: Reset functionality - should initialize to 0000";
    WAIT FOR CNTR_CLK_PERIOD * 2;

    REPORT "Test 2: Count up functionality - counting from 0000 to 0007";
    cntrup_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD * 10;
    cntrup_tb <= '0';

    REPORT "Test 3: Count down functionality";
    cntrdown_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD * 15;
    cntrdown_tb <= '0';

    REPORT "Test 4: Hold functionality - counter should not change";
    cntrhold_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD * 3;
    cntrup_tb <= '1'; -- Try to count up while holding
    WAIT FOR CNTR_CLK_PERIOD * 3;
    cntrup_tb <= '0';
    cntrdown_tb <= '1'; -- Try to count down while holding
    WAIT FOR CNTR_CLK_PERIOD * 3;
    cntrdown_tb <= '0';
    cntrhold_tb <= '0';

    REPORT "Test 5: Clear functionality";
    cntrclear_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD;
    cntrclear_tb <= '0';
    WAIT FOR CNTR_CLK_PERIOD;

    REPORT "Test 6: Wraparound down functionality";
    cntrdown_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD * 32;

    REPORT "Test 7: Wraparound up functionality";
    cntrup_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD * 37;
    cntrup_tb <= '0';
    cntrdown_tb <= '0';

    -- Test 8: Priority control (Clear > Up/Down > Hold)
    REPORT "Test 8: Priority control testing";
    -- Test clear priority over all others
    cntrup_tb <= '1';
    cntrdown_tb <= '1';
    cntrhold_tb <= '1';
    cntrclear_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD;

    -- Reset
    reset_tb <= '1';
    cntrup_tb <= '0';
    cntrdown_tb <= '0';
    cntrhold_tb <= '0';
    cntrclear_tb <= '0';

    REPORT "Counter Unit Testbench completed successfully";
    WAIT;

  END PROCESS;

END sim;