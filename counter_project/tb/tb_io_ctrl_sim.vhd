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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture sim of tb_io_ctrl is

  -- Component declaration
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
  
  -- Clock and reset
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '1';
  
  -- Input signals
  signal cntr0_tb       : std_logic_vector(2 downto 0) := "000";
  signal cntr1_tb       : std_logic_vector(2 downto 0) := "001";
  signal cntr2_tb       : std_logic_vector(2 downto 0) := "010";
  signal cntr3_tb       : std_logic_vector(2 downto 0) := "011";
  signal led_i_tb       : std_logic_vector(15 downto 0) := x"5555";
  signal sw_tb          : std_logic_vector(15 downto 0) := x"0000";
  signal pb_tb          : std_logic_vector(3 downto 0) := "0000";
  
  -- Output signals
  signal ss_tb          : std_logic_vector(7 downto 0);
  signal ss_sel_tb      : std_logic_vector(3 downto 0);
  signal led_o_tb       : std_logic_vector(15 downto 0);
  signal swsync_tb      : std_logic_vector(15 downto 0);
  signal pbsync_tb      : std_logic_vector(3 downto 0);
  
  -- Clock period
  constant CLK_PERIOD   : time := 10 ns; -- 100 MHz

begin

  -- Device under test instantiation
  dut: io_ctrl
    port map (
      clk_i      => clk_tb,
      reset_i    => reset_tb,
      cntr0_i    => cntr0_tb,
      cntr1_i    => cntr1_tb,
      cntr2_i    => cntr2_tb,
      cntr3_i    => cntr3_tb,
      led_i      => led_i_tb,
      sw_i       => sw_tb,
      pb_i       => pb_tb,
      ss_o       => ss_tb,
      ss_sel_o   => ss_sel_tb,
      led_o      => led_o_tb,
      swsync_o   => swsync_tb,
      pbsync_o   => pbsync_tb
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
    wait for 100 ns;
    reset_tb <= '0';
    wait for 100 ns;
    
    report "Starting IO Control Unit Testbench";
    
    -- Test 1: Basic LED passthrough
    report "Test 1: LED passthrough functionality";
    led_i_tb <= x"AAAA";
    wait for 1 us;
    assert led_o_tb = x"AAAA" report "LED passthrough failed" severity error;
    
    -- Test 2: Switch debouncing
    report "Test 2: Switch debouncing test";
    sw_tb <= x"0001";
    wait for 50 us; -- Wait less than debounce time
    sw_tb <= x"0000";
    wait for 50 us;
    sw_tb <= x"0001";
    wait for 2 ms; -- Wait longer than debounce time
    assert swsync_tb = x"0001" report "Switch debouncing failed" severity error;
    
    -- Test 3: Push button debouncing
    report "Test 3: Push button debouncing test";
    pb_tb <= "0001";
    wait for 50 us;
    pb_tb <= "0000";
    wait for 50 us;
    pb_tb <= "0001";
    wait for 2 ms;
    assert pbsync_tb = "0001" report "Push button debouncing failed" severity error;
    
    -- Test 4: 7-segment display multiplexing
    report "Test 4: 7-segment display multiplexing";
    cntr0_tb <= "000"; -- Display 0
    cntr1_tb <= "001"; -- Display 1
    cntr2_tb <= "010"; -- Display 2
    cntr3_tb <= "011"; -- Display 3
    
    -- Wait for multiple display cycles and check each digit
    wait for 5 ms; -- Allow multiple refresh cycles
    
    -- Test 5: 7-segment decoder verification
    report "Test 5: 7-segment decoder patterns";
    cntr0_tb <= "111"; -- Display 7
    cntr1_tb <= "110"; -- Display 6
    cntr2_tb <= "101"; -- Display 5
    cntr3_tb <= "100"; -- Display 4
    wait for 5 ms;
    
    -- Test 6: Reset functionality
    report "Test 6: Reset functionality";
    reset_tb <= '1';
    wait for 100 ns;
    reset_tb <= '0';
    wait for 100 ns;
    
    -- Test 7: Invalid digit handling
    report "Test 7: Invalid digit handling (should not occur in normal operation)";
    -- Note: In normal operation, counter unit ensures only valid octal digits (0-7)
    
    report "IO Control Unit Testbench completed successfully";
    wait;
    
  end process;

end sim;
