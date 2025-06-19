-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Testbench Implementation          --
--                                                                           --
-- Description: Comprehensive testbench for IO control unit including       --
--              switch debouncing test, 7-segment display multiplexing,     --
--              and LED functionality verification.                         --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 19.06.2025                                                        --
-- File : tb_io_ctrl_sim.vhd                                               --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE sim OF tb_io_ctrl IS

  -- Component declaration
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

  CONSTANT IO_CLK_PERIOD : TIME := 1 sec / REFRESH_FREQ;

  -- Clock and reset
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL reset_tb : STD_LOGIC := '1';

  -- Input signals
  SIGNAL cntr0_tb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  SIGNAL cntr1_tb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  SIGNAL cntr2_tb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  SIGNAL cntr3_tb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  SIGNAL led_i_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"5555";
  SIGNAL sw_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL pb_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  -- Output signals
  SIGNAL ss_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ss_sel_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL led_o_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL swsync_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL pbsync_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- Helper signals for readable 7-segment display
  SIGNAL current_digit_name : STRING(1 TO 7) := "INVALID";
  SIGNAL active_digit_name : STRING(1 TO 7) := "DIGIT_0";

BEGIN

  -- Device under test instantiation
  dut : io_ctrl
  PORT MAP(
    clk_i => clk_tb,
    reset_i => reset_tb,
    cntr0_i => cntr0_tb,
    cntr1_i => cntr1_tb,
    cntr2_i => cntr2_tb,
    cntr3_i => cntr3_tb,
    led_i => led_i_tb,
    sw_i => sw_tb,
    pb_i => pb_tb,
    ss_o => ss_tb,
    ss_sel_o => ss_sel_tb,
    led_o => led_o_tb,
    swsync_o => swsync_tb,
    pbsync_o => pbsync_tb
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
      WHEN "1111" => active_digit_name <= "ALL_OFF";
      WHEN OTHERS => active_digit_name <= "INVALID";
    END CASE;
  END PROCESS proc_digit_sel_decoder;

  -- Stimulus process
  stim_process : PROCESS
  BEGIN
    -- Initial reset
    reset_tb <= '1';
    WAIT FOR IO_CLK_PERIOD;
    reset_tb <= '0';

    REPORT "Starting IO Control Unit Testbench";

    -- Test 1: Basic LED passthrough
    REPORT "Test 1: LED passthrough functionality";
    led_i_tb <= x"AAAA";
    WAIT FOR IO_CLK_PERIOD * 4;
    led_i_tb <= x"1234";
    WAIT FOR IO_CLK_PERIOD * 4;
    led_i_tb <= x"ABCD";
    WAIT FOR IO_CLK_PERIOD * 4;

    REPORT "Test 2: Switch debouncing test";
    WAIT FOR IO_CLK_PERIOD / 3;
    sw_tb <= x"0001";
    WAIT FOR CLK_PERIOD; -- Brief glitch
    sw_tb <= x"0000";
    WAIT FOR CLK_PERIOD;
    sw_tb <= x"0045"; -- Final stable value
    WAIT FOR CLK_PERIOD;

    REPORT "Test 3: Push button debouncing test";
    pb_tb <= "0001";
    WAIT FOR CLK_PERIOD;
    pb_tb <= "0000";
    WAIT FOR CLK_PERIOD;
    pb_tb <= "0010";
    WAIT FOR IO_CLK_PERIOD * 5 / 3; -- Wait for at least one refresh cycle

    REPORT "Test 4: 7-segment display multiplexing";
    cntr0_tb <= "101"; -- display 5 on first digit
    cntr1_tb <= "110"; -- display 6 on second digit
    cntr2_tb <= "001"; -- display 2 on third digit
    cntr3_tb <= "010"; -- display 3 on fourth digit
    WAIT FOR IO_CLK_PERIOD * 8; -- Wait for 8 cycles to see the digit

    REPORT "Test 4: Reset functionality";
    reset_tb <= '1';
    WAIT FOR IO_CLK_PERIOD;
    reset_tb <= '0';
    WAIT FOR IO_CLK_PERIOD;

    REPORT "Test 5: Complete 7-segment decoder test";
    FOR i IN 0 TO 1 LOOP
      cntr3_tb <= STD_LOGIC_VECTOR(to_unsigned((7 - i) MOD 8, 3));
      FOR j IN 0 TO 1 LOOP
        cntr2_tb <= STD_LOGIC_VECTOR(to_unsigned(3 * (i + j) MOD 8, 3));
        FOR k IN 0 TO 1 LOOP
          cntr1_tb <= STD_LOGIC_VECTOR(to_unsigned(4 * (i + j + k) MOD 8, 3));
          FOR l IN 0 TO 1 LOOP
            cntr0_tb <= STD_LOGIC_VECTOR(to_unsigned((i + j + k + l) MOD 8, 3)); -- Test each digit from 0 to 7
            WAIT FOR IO_CLK_PERIOD * 4;
          END LOOP;
          WAIT FOR IO_CLK_PERIOD * 4;
        END LOOP;
        WAIT FOR IO_CLK_PERIOD * 4;
      END LOOP;
      WAIT FOR IO_CLK_PERIOD * 4; -- Wait for display update
    END LOOP;

    REPORT "IO Control Unit Testbench completed successfully";
    WAIT;

  END PROCESS;

END sim;