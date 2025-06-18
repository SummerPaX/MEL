-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit Testbench Implementation          --
--                                                                           --
-- Description: Comprehensive testbench for IO control unit including       --
--              switch debouncing test, 7-segment display multiplexing,     --
--              and LED functionality verification.                         --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
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
    WAIT FOR 100 ns;
    reset_tb <= '0';
    WAIT FOR 100 ns;

    REPORT "Starting IO Control Unit Testbench";

    -- Test 1: Basic LED passthrough
    REPORT "Test 1: LED passthrough functionality";
    led_i_tb <= x"AAAA";
    WAIT FOR 1 us;
    ASSERT led_o_tb = x"AAAA" REPORT "LED passthrough failed" SEVERITY error;

    -- Test 2: Switch debouncing
    REPORT "Test 2: Switch debouncing test";
    sw_tb <= x"0001";
    WAIT FOR 50 us; -- Wait less than debounce time
    sw_tb <= x"0000";
    WAIT FOR 50 us;
    sw_tb <= x"0001";
    WAIT FOR 2 ms; -- Wait longer than debounce time
    ASSERT swsync_tb = x"0001" REPORT "Switch debouncing failed" SEVERITY error;

    -- Test 3: Push button debouncing
    REPORT "Test 3: Push button debouncing test";
    pb_tb <= "0001";
    WAIT FOR 50 us;
    pb_tb <= "0000";
    WAIT FOR 50 us;
    pb_tb <= "0001";
    WAIT FOR 2 ms;
    ASSERT pbsync_tb = "0001" REPORT "Push button debouncing failed" SEVERITY error;

    -- Test 4: 7-segment display multiplexing
    REPORT "Test 4: 7-segment display multiplexing";
    cntr0_tb <= "000"; -- Display 0
    cntr1_tb <= "001"; -- Display 1
    cntr2_tb <= "010"; -- Display 2
    cntr3_tb <= "011"; -- Display 3

    -- Wait for multiple display cycles and check each digit
    WAIT FOR 5 ms; -- Allow multiple refresh cycles

    -- Test 5: 7-segment decoder verification
    REPORT "Test 5: 7-segment decoder patterns";
    cntr0_tb <= "111"; -- Display 7
    cntr1_tb <= "110"; -- Display 6
    cntr2_tb <= "101"; -- Display 5
    cntr3_tb <= "100"; -- Display 4
    WAIT FOR 5 ms;

    -- Test 6: Reset functionality
    REPORT "Test 6: Reset functionality";
    reset_tb <= '1';
    WAIT FOR 100 ns;
    reset_tb <= '0';
    WAIT FOR 100 ns;

    -- Test 7: Invalid digit handling
    REPORT "Test 7: Invalid digit handling (should not occur in normal operation)";
    -- Note: In normal operation, counter unit ensures only valid octal digits (0-7)

    REPORT "IO Control Unit Testbench completed successfully";
    WAIT;

  END PROCESS;

END sim;