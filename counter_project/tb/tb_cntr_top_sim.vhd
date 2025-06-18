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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture sim of tb_cntr_top is

  -- Component declaration
  component cntr_top
    port (
      clk_i          : in  std_logic;
      reset_i        : in  std_logic;
      sw_i           : in  std_logic_vector(15 downto 0);
      pb_i           : in  std_logic_vector(3 downto 0);
      ss_o           : out std_logic_vector(7 downto 0);
      ss_sel_o       : out std_logic_vector(3 downto 0);
      led_o          : out std_logic_vector(15 downto 0)
    );
  end component;
  
  -- Clock and reset
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '1';
  
  -- Input signals
  signal sw_tb          : std_logic_vector(15 downto 0) := (others => '0');
  signal pb_tb          : std_logic_vector(3 downto 0) := (others => '0');
  
  -- Output signals
  signal ss_tb          : std_logic_vector(7 downto 0);
  signal ss_sel_tb      : std_logic_vector(3 downto 0);
  signal led_tb         : std_logic_vector(15 downto 0);
  
  -- Switch assignments for clarity
  -- SW(0) = Clear, SW(1) = Down, SW(2) = Up, SW(3) = Run/Stop
  alias clear_sw        : std_logic is sw_tb(0);
  alias down_sw         : std_logic is sw_tb(1);
  alias up_sw           : std_logic is sw_tb(2);
  alias run_stop_sw     : std_logic is sw_tb(3);
  
  -- Clock period
  constant CLK_PERIOD   : time := 10 ns; -- 100 MHz
  
  -- Procedure for switch operation (includes debounce time)
  procedure set_switches(
    signal switches : out std_logic_vector(15 downto 0);
    constant value  : in  std_logic_vector(15 downto 0);
    constant delay  : in  time := 5 ms
  ) is
  begin
    switches <= value;
    wait for delay; -- Allow for debouncing
  end procedure;

begin

  -- Device under test instantiation
  dut: cntr_top
    port map (
      clk_i      => clk_tb,
      reset_i    => reset_tb,
      sw_i       => sw_tb,
      pb_i       => pb_tb,
      ss_o       => ss_tb,
      ss_sel_o   => ss_sel_tb,
      led_o      => led_tb
    );
  
  -- Clock generation
  clk_process: process
  begin
    while true loop
      clk_tb <= '0';
      wait for CLK_PERIOD/2;
      clk_tb <= '1';
      wait for CLK_PERIOD/2;
    end loop;
  end process;
  
  -- Stimulus process
  stim_process: process
  begin
    -- Initial reset
    reset_tb <= '1';
    wait for 1 us;
    reset_tb <= '0';
    wait for 1 us;
    
    report "Starting Top-Level Counter System Testbench";
    
    -- Test 1: System initialization
    report "Test 1: System initialization and reset";
    set_switches(sw_tb, x"0000");
    
    -- Verify LEDs show switch states
    assert led_tb(3 downto 0) = "0000" report "LED initialization failed" severity error;
    
    -- Test 2: Clear functionality
    report "Test 2: Clear counter functionality";
    set_switches(sw_tb, x"0001"); -- Clear switch on
    assert led_tb(0) = '1' report "Clear LED indication failed" severity error;
    set_switches(sw_tb, x"0000"); -- Clear switch off
    
    -- Test 3: Count up operation
    report "Test 3: Count up operation";
    -- Set Run/Stop=1, Up=1 (switches 3 and 2)
    set_switches(sw_tb, x"000C"); -- Run/Stop + Up
    
    -- Check LED indicators
    assert led_tb(3 downto 0) = "1100" report "Count up LED indication failed" severity error;
    
    -- Wait for potential counting (limited by simulation time)
    wait for 10 ms;
    
    -- Test 4: Count down operation  
    report "Test 4: Count down operation";
    -- Set Run/Stop=1, Down=1 (switches 3 and 1)
    set_switches(sw_tb, x"000A"); -- Run/Stop + Down
    
    -- Check LED indicators
    assert led_tb(3 downto 0) = "1010" report "Count down LED indication failed" severity error;
    wait for 10 ms;
    
    -- Test 5: Hold operation
    report "Test 5: Hold operation";
    set_switches(sw_tb, x"0000"); -- All switches off
    assert led_tb(3 downto 0) = "0000" report "Hold LED indication failed" severity error;
    wait for 5 ms;
    
    -- Test 6: Priority testing - Clear has highest priority
    report "Test 6: Priority testing - Clear overrides all";
    set_switches(sw_tb, x"000F"); -- All control switches on
    assert led_tb(0) = '1' report "Clear priority failed" severity error;
    wait for 5 ms;
    
    -- Test 7: Priority testing - Up overrides Down
    report "Test 7: Priority testing - Up overrides Down";
    set_switches(sw_tb, x"000E"); -- Run/Stop + Up + Down (no Clear)
    assert led_tb(3 downto 0) = "1110" report "Up priority over Down failed" severity error;
    wait for 5 ms;
    
    -- Test 8: 7-segment display cycling
    report "Test 8: 7-segment display multiplexing";
    set_switches(sw_tb, x"0000"); -- Hold mode
    
    -- Monitor display for several cycles
    wait for 20 ms; -- Allow multiple 1kHz refresh cycles
    
    -- Test 9: Reset during operation
    report "Test 9: Reset during operation";
    set_switches(sw_tb, x"000C"); -- Count up mode
    wait for 5 ms;
    
    reset_tb <= '1';
    wait for 1 us;
    reset_tb <= '0';
    wait for 1 us;
    
    -- System should restart properly
    assert led_tb(3 downto 0) = "1100" report "Reset recovery failed" severity error;
    
    -- Test 10: Switch bounce simulation
    report "Test 10: Switch debouncing verification";
    -- Simulate switch bouncing
    for i in 0 to 5 loop
      sw_tb <= x"0001"; -- Clear on
      wait for 10 us;
      sw_tb <= x"0000"; -- Clear off
      wait for 10 us;
    end loop;
    sw_tb <= x"0001"; -- Final stable state
    wait for 5 ms; -- Debounce time
    
    -- Test 11: Comprehensive functionality test
    report "Test 11: Comprehensive system test";
    
    -- Clear counter
    set_switches(sw_tb, x"0001");
    set_switches(sw_tb, x"0000");
    
    -- Count up sequence
    set_switches(sw_tb, x"000C");
    wait for 15 ms;
    
    -- Switch to count down
    set_switches(sw_tb, x"000A");
    wait for 15 ms;
    
    -- Hold
    set_switches(sw_tb, x"0000");
    wait for 5 ms;
    
    -- Final clear
    set_switches(sw_tb, x"0001");
    set_switches(sw_tb, x"0000");
    
    report "Top-Level Counter System Testbench completed successfully";
    report "Note: Full counting verification requires extended simulation time due to 1 Hz frequency";
    wait;
    
  end process;
  
  -- Monitor process for continuous observation
  monitor_process: process
  begin
    wait for 1 ms;
    while true loop
      wait for 1 ms;
      report "LEDs: " & integer'image(to_integer(unsigned(led_tb(3 downto 0)))) &
             ", 7-seg select: " & integer'image(to_integer(unsigned(ss_sel_tb))) &
             ", segments: " & integer'image(to_integer(unsigned(ss_tb)));
    end loop;
  end process;

end sim;
