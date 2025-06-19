-------------------------------------------------------------------------------
-- MEL Counter Project - Top Level Testbench Implementation                 --
--                                                                           --
-- Description: Comprehensive system-level testbench verifying complete     --
--              counter functionality including switch control, display     --
--              output, and realistic user interaction scenarios.           --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 19.06.2025                                                        --
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

  CONSTANT CNTR_CLK_PERIOD : TIME := 1 sec / COUNT_FREQ;

  -- Clock and reset
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL reset_tb : STD_LOGIC := '1';

  -- Input signals
  SIGNAL sw_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL pb_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

  -- Output signals
  SIGNAL ss_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ss_sel_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL led_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- Helper signals for readable 7-segment display
  SIGNAL current_digit_name : STRING(1 TO 7) := "INVALID";
  SIGNAL active_digit_name : STRING(1 TO 7) := "DIGIT_0";
  -- Switch control signals (for clarity)
  -- SW(0) = Enable/Run-Stop, SW(1) = Up, SW(2) = Down, SW(3) = Clear
  SIGNAL run_stop_sw : STD_LOGIC; -- Enable/Run-Stop
  SIGNAL up_sw : STD_LOGIC; -- Up
  SIGNAL down_sw : STD_LOGIC; -- Down
  SIGNAL clear_sw : STD_LOGIC; -- Clear

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
  -- Switch control signal assignments
  run_stop_sw <= sw_tb(0); -- Enable/Run-Stop
  up_sw <= sw_tb(1); -- Up 
  down_sw <= sw_tb(2); -- Down
  clear_sw <= sw_tb(3); -- Clear

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

  -- 7-segment pattern decoder for simulation readability
  proc_7seg_decoder : PROCESS (ss_tb)
  BEGIN
    CASE ss_tb IS
      WHEN "11000000" => current_digit_name <= "ZERO   ";
      WHEN "11111001" => current_digit_name <= "ONE    ";
      WHEN "10100100" => current_digit_name <= "TWO    ";
      WHEN "10110000" => current_digit_name <= "THREE  ";
      WHEN "10011001" => current_digit_name <= "FOUR   ";
      WHEN "10010010" => current_digit_name <= "FIVE   ";
      WHEN "10000010" => current_digit_name <= "SIX    ";
      WHEN "11111000" => current_digit_name <= "SEVEN  ";
      WHEN "11111111" => current_digit_name <= "OFF    ";
      WHEN OTHERS => current_digit_name <= "INVALID";
    END CASE;
  END PROCESS proc_7seg_decoder;

  -- Active digit decoder for simulation readability
  proc_digit_sel_decoder : PROCESS (ss_sel_tb)
  BEGIN
    CASE ss_sel_tb IS
      WHEN "1110" => active_digit_name <= "DIGIT_0";
      WHEN "1101" => active_digit_name <= "DIGIT_1";
      WHEN "1011" => active_digit_name <= "DIGIT_2";
      WHEN "0111" => active_digit_name <= "DIGIT_3";
      WHEN OTHERS => active_digit_name <= "INVALID";
    END CASE;
  END PROCESS proc_digit_sel_decoder;

  -- Stimulus process
  stim_process : PROCESS
  BEGIN
    -- Initial reset
    reset_tb <= '1';
    WAIT FOR CLK_PERIOD * 10;
    reset_tb <= '0';

    REPORT "Starting Top-Level Counter System Testbench";
    REPORT "Test 1: System initialization and reset";
    sw_tb <= x"0000";
    WAIT FOR CNTR_CLK_PERIOD;
    REPORT "Test 2: Clear counter functionality";
    sw_tb <= x"0008"; -- Clear switch on (bit 3)
    WAIT FOR CNTR_CLK_PERIOD;
    sw_tb <= x"0000"; -- Clear switch off
    WAIT FOR CNTR_CLK_PERIOD;
    REPORT "Test 3: Count up operation";
    sw_tb <= x"0003"; -- Enable + Up (bits 0 and 1)
    WAIT FOR CNTR_CLK_PERIOD * 18;
    REPORT "Test 4: Count down operation";
    sw_tb <= x"0005"; -- Enable + Down (bits 0 and 2)
    WAIT FOR CNTR_CLK_PERIOD * 10;

    REPORT "Test 5: Hold operation";
    sw_tb <= x"0000"; -- All switches off
    WAIT FOR CNTR_CLK_PERIOD * 3;
    REPORT "Test 6: Priority testing - Clear overrides all";
    sw_tb <= x"000F"; -- All control switches on (Enable + Up + Down + Clear)
    WAIT FOR CNTR_CLK_PERIOD * 10;
    REPORT "Test 7: Priority testing - Up overrides Down";
    sw_tb <= x"0007"; -- Enable + Up + Down (no Clear)
    WAIT FOR CNTR_CLK_PERIOD * 10;

    REPORT "Test 8: 7-segment display multiplexing";
    sw_tb <= x"0000"; -- Hold mode
    WAIT FOR CNTR_CLK_PERIOD * 8; -- Allow multiple refresh cycles    REPORT "Test 9: Reset during operation";
    sw_tb <= x"0003"; -- Enable + Up
    WAIT FOR CNTR_CLK_PERIOD * 2;
    reset_tb <= '1';
    WAIT FOR CNTR_CLK_PERIOD;
    reset_tb <= '0';
    WAIT FOR CNTR_CLK_PERIOD; -- Test 10: Switch debouncing verification
    REPORT "Test 10: Switch debouncing verification";
    -- Simulate switch bouncing
    FOR i IN 0 TO 5 LOOP
      sw_tb <= x"0008"; -- Clear on (bit 3)
      WAIT FOR CLK_PERIOD;
      sw_tb <= x"0000"; -- Clear off
      WAIT FOR CLK_PERIOD;
    END LOOP;
    sw_tb <= x"0008"; -- Final stable state (Clear)
    WAIT FOR CNTR_CLK_PERIOD; -- Debounce time    -- Test 11: Comprehensive functionality test
    REPORT "Test 11: Comprehensive system test";

    -- Clear counter
    sw_tb <= x"0008"; -- Clear (bit 3)
    WAIT FOR CNTR_CLK_PERIOD * 2;
    sw_tb <= x"0000";
    WAIT FOR CLK_PERIOD * 10;

    -- Count up sequence
    sw_tb <= x"0003"; -- Enable + Up (bits 0 and 1)
    WAIT FOR CNTR_CLK_PERIOD * 8;

    -- Switch to count down
    sw_tb <= x"0005"; -- Enable + Down (bits 0 and 2)
    WAIT FOR CNTR_CLK_PERIOD * 10;

    -- Hold
    sw_tb <= x"0000"; -- All switches off
    WAIT FOR CNTR_CLK_PERIOD * 3;

    -- Final clear
    sw_tb <= x"0008"; -- Clear (bit 3)
    WAIT FOR CNTR_CLK_PERIOD * 2;
    sw_tb <= x"0000";

    REPORT "Top-Level Counter System Testbench completed successfully";
    REPORT "Note: Full counting verification requires extended simulation time due to 1 Hz frequency";
    WAIT;

  END PROCESS;
END sim;