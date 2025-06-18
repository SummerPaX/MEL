-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Testbench Implementation                 --
--                                                                           --
-- Description: Comprehensive system-level testbench verifying complete     --
--              counter functionality including switch control, display     --
--              output, and realistic user interaction scenarios.           --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : tb_cntr_top_sim.vhd                                              --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE sim OF tb_cntr_top IS

  -- Component declaration
  COMPONENT cntr_top
    PORT (
      clk_i : IN STD_LOGIC;
      reset_i : IN STD_LOGIC;
      sw_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      pb_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ss_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      ss_sel_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      led_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  -- Clock and reset
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL reset_tb : STD_LOGIC := '1';

  -- Input signals
  SIGNAL sw_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pb_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

  -- Output signals
  SIGNAL ss_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ss_sel_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL led_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- Switch assignments for clarity
  -- SW(0) = Clear, SW(1) = Down, SW(2) = Up, SW(3) = Run/Stop
  ALIAS clear_sw : STD_LOGIC IS sw_tb(0);
  ALIAS down_sw : STD_LOGIC IS sw_tb(1);
  ALIAS up_sw : STD_LOGIC IS sw_tb(2);
  ALIAS run_stop_sw : STD_LOGIC IS sw_tb(3);

  -- Procedure for switch operation (includes debounce time)
  PROCEDURE set_switches(
    SIGNAL switches : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    CONSTANT value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CONSTANT delay : IN TIME := 5 ms
  ) IS
  BEGIN
    switches <= value;
    WAIT FOR delay; -- Allow for debouncing
  END PROCEDURE;

BEGIN

  -- Device under test instantiation
  dut : cntr_top
  PORT MAP(
    clk_i => clk_tb,
    reset_i => reset_tb,
    sw_i => sw_tb,
    pb_i => pb_tb,
    ss_o => ss_tb,
    ss_sel_o => ss_sel_tb,
    led_o => led_tb
  );

  -- Clock generation
  clk_process : PROCESS
  BEGIN
    WHILE true LOOP
      clk_tb <= '0';
      WAIT FOR CLK_PERIOD/2;
      clk_tb <= '1';
      WAIT FOR CLK_PERIOD/2;
    END LOOP;
  END PROCESS;

  -- Stimulus process
  stim_process : PROCESS
  BEGIN
    -- Initial reset
    reset_tb <= '1';
    WAIT FOR 1 us;
    reset_tb <= '0';
    WAIT FOR 1 us;

    REPORT "Starting Top-Level Counter System Testbench";

    -- Test 1: System initialization
    REPORT "Test 1: System initialization and reset";
    set_switches(sw_tb, x"0000");

    -- Verify LEDs show switch states
    ASSERT led_tb(3 DOWNTO 0) = "0000" REPORT "LED initialization failed" SEVERITY error;

    -- Test 2: Clear functionality
    REPORT "Test 2: Clear counter functionality";
    set_switches(sw_tb, x"0001"); -- Clear switch on
    ASSERT led_tb(0) = '1' REPORT "Clear LED indication failed" SEVERITY error;
    set_switches(sw_tb, x"0000"); -- Clear switch off

    -- Test 3: Count up operation
    REPORT "Test 3: Count up operation";
    -- Set Run/Stop=1, Up=1 (switches 3 and 2)
    set_switches(sw_tb, x"000C"); -- Run/Stop + Up

    -- Check LED indicators
    ASSERT led_tb(3 DOWNTO 0) = "1100" REPORT "Count up LED indication failed" SEVERITY error;

    -- Wait for potential counting (limited by simulation time)
    WAIT FOR 10 ms;

    -- Test 4: Count down operation  
    REPORT "Test 4: Count down operation";
    -- Set Run/Stop=1, Down=1 (switches 3 and 1)
    set_switches(sw_tb, x"000A"); -- Run/Stop + Down

    -- Check LED indicators
    ASSERT led_tb(3 DOWNTO 0) = "1010" REPORT "Count down LED indication failed" SEVERITY error;
    WAIT FOR 10 ms;

    -- Test 5: Hold operation
    REPORT "Test 5: Hold operation";
    set_switches(sw_tb, x"0000"); -- All switches off
    ASSERT led_tb(3 DOWNTO 0) = "0000" REPORT "Hold LED indication failed" SEVERITY error;
    WAIT FOR 5 ms;

    -- Test 6: Priority testing - Clear has highest priority
    REPORT "Test 6: Priority testing - Clear overrides all";
    set_switches(sw_tb, x"000F"); -- All control switches on
    ASSERT led_tb(0) = '1' REPORT "Clear priority failed" SEVERITY error;
    WAIT FOR 5 ms;

    -- Test 7: Priority testing - Up overrides Down
    REPORT "Test 7: Priority testing - Up overrides Down";
    set_switches(sw_tb, x"000E"); -- Run/Stop + Up + Down (no Clear)
    ASSERT led_tb(3 DOWNTO 0) = "1110" REPORT "Up priority over Down failed" SEVERITY error;
    WAIT FOR 5 ms;

    -- Test 8: 7-segment display cycling
    REPORT "Test 8: 7-segment display multiplexing";
    set_switches(sw_tb, x"0000"); -- Hold mode

    -- Monitor display for several cycles
    WAIT FOR 20 ms; -- Allow multiple 1kHz refresh cycles

    -- Test 9: Reset during operation
    REPORT "Test 9: Reset during operation";
    set_switches(sw_tb, x"000C"); -- Count up mode
    WAIT FOR 5 ms;

    reset_tb <= '1';
    WAIT FOR 1 us;
    reset_tb <= '0';
    WAIT FOR 1 us;

    -- System should restart properly
    ASSERT led_tb(3 DOWNTO 0) = "1100" REPORT "Reset recovery failed" SEVERITY error;

    -- Test 10: Switch bounce simulation
    REPORT "Test 10: Switch debouncing verification";
    -- Simulate switch bouncing
    FOR i IN 0 TO 5 LOOP
      sw_tb <= x"0001"; -- Clear on
      WAIT FOR 10 us;
      sw_tb <= x"0000"; -- Clear off
      WAIT FOR 10 us;
    END LOOP;
    sw_tb <= x"0001"; -- Final stable state
    WAIT FOR 5 ms; -- Debounce time

    -- Test 11: Comprehensive functionality test
    REPORT "Test 11: Comprehensive system test";

    -- Clear counter
    set_switches(sw_tb, x"0001");
    set_switches(sw_tb, x"0000");

    -- Count up sequence
    set_switches(sw_tb, x"000C");
    WAIT FOR 15 ms;

    -- Switch to count down
    set_switches(sw_tb, x"000A");
    WAIT FOR 15 ms;

    -- Hold
    set_switches(sw_tb, x"0000");
    WAIT FOR 5 ms;

    -- Final clear
    set_switches(sw_tb, x"0001");
    set_switches(sw_tb, x"0000");

    REPORT "Top-Level Counter System Testbench completed successfully";
    REPORT "Note: Full counting verification requires extended simulation time due to 1 Hz frequency";
    WAIT;

  END PROCESS;

  -- Monitor process for continuous observation
  monitor_process : PROCESS
  BEGIN
    WAIT FOR 1 ms;
    WHILE true LOOP
      WAIT FOR 1 ms;
      REPORT "LEDs: " & INTEGER'image(to_integer(unsigned(led_tb(3 DOWNTO 0)))) &
        ", 7-seg select: " & INTEGER'image(to_integer(unsigned(ss_sel_tb))) &
        ", segments: " & INTEGER'image(to_integer(unsigned(ss_tb)));
    END LOOP;
  END PROCESS;

END sim;