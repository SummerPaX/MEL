-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit RTL Architecture                      --
--                                                                           --
-- Description: RTL implementation of 4-digit octal counter with 1 Hz       --
--              counting frequency. Supports up/down counting with          --
--              wraparound and priority control scheme.                     --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : cntr_rtl.vhd                                                      --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of cntr is

  -- Constants for frequency generation
  constant CLK_FREQ     : integer := 100_000_000; -- 100 MHz system clock
  constant COUNT_FREQ   : integer := 1;           -- 1 Hz counting frequency
  constant DIV_COUNT    : integer := CLK_FREQ / COUNT_FREQ - 1; -- 99999999
  
  -- Clock divider signals  
  signal clk_div_cnt    : unsigned(26 downto 0); -- 27 bits for count up to 99999999
  signal count_enable   : std_logic;
  
  -- Counter registers (3 bits each for octal: 0-7)
  signal digit0_reg     : unsigned(2 downto 0); -- LSB
  signal digit1_reg     : unsigned(2 downto 0);
  signal digit2_reg     : unsigned(2 downto 0);
  signal digit3_reg     : unsigned(2 downto 0); -- MSB
  
  -- Carry/borrow signals
  signal carry0         : std_logic;
  signal carry1         : std_logic;
  signal carry2         : std_logic;
  signal borrow0        : std_logic;
  signal borrow1        : std_logic;
  signal borrow2        : std_logic;
  
  -- Control signals with priority
  signal clear_active   : std_logic;
  signal count_up       : std_logic;
  signal count_down     : std_logic;
  signal hold_count     : std_logic;

begin

  -- Priority control logic
  -- Priority: Clear > Up/Down > Hold
  clear_active <= cntrclear_i;
  count_up <= (not cntrclear_i) and cntrup_i and (not cntrdown_i);
  count_down <= (not cntrclear_i) and (not cntrup_i) and cntrdown_i;
  hold_count <= (not cntrclear_i) and cntrhold_i and (not cntrup_i) and (not cntrdown_i);
  
  -- Clock divider for 1 Hz counting frequency
  proc_clk_div: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      clk_div_cnt <= (others => '0');
      count_enable <= '0';
    elsif rising_edge(clk_i) then
      if clk_div_cnt = DIV_COUNT then
        clk_div_cnt <= (others => '0');
        count_enable <= '1';
      else
        clk_div_cnt <= clk_div_cnt + 1;
        count_enable <= '0';
      end if;
    end if;
  end process proc_clk_div;
  
  -- Carry logic for counting up
  carry0 <= '1' when digit0_reg = "111" else '0'; -- Carry when digit reaches 7
  carry1 <= carry0 when digit1_reg = "111" else '0';
  carry2 <= carry1 when digit2_reg = "111" else '0';
  
  -- Borrow logic for counting down  
  borrow0 <= '1' when digit0_reg = "000" else '0'; -- Borrow when digit reaches 0
  borrow1 <= borrow0 when digit1_reg = "000" else '0';
  borrow2 <= borrow1 when digit2_reg = "000" else '0';
  
  -- Counter logic for digit 0 (LSB)
  proc_counter0: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      digit0_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      if clear_active = '1' then
        digit0_reg <= (others => '0');
      elsif count_enable = '1' then
        if count_up = '1' then
          if digit0_reg = "111" then
            digit0_reg <= (others => '0'); -- Wrap to 0 after 7
          else
            digit0_reg <= digit0_reg + 1;
          end if;
        elsif count_down = '1' then
          if digit0_reg = "000" then
            digit0_reg <= "111"; -- Wrap to 7 after 0
          else
            digit0_reg <= digit0_reg - 1;
          end if;
        end if;
      end if;
    end if;
  end process proc_counter0;
  
  -- Counter logic for digit 1
  proc_counter1: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      digit1_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      if clear_active = '1' then
        digit1_reg <= (others => '0');
      elsif count_enable = '1' then
        if count_up = '1' and carry0 = '1' then
          if digit1_reg = "111" then
            digit1_reg <= (others => '0'); -- Wrap to 0 after 7
          else
            digit1_reg <= digit1_reg + 1;
          end if;
        elsif count_down = '1' and borrow0 = '1' then
          if digit1_reg = "000" then
            digit1_reg <= "111"; -- Wrap to 7 after 0
          else
            digit1_reg <= digit1_reg - 1;
          end if;
        end if;
      end if;
    end if;
  end process proc_counter1;
  
  -- Counter logic for digit 2
  proc_counter2: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      digit2_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      if clear_active = '1' then
        digit2_reg <= (others => '0');
      elsif count_enable = '1' then
        if count_up = '1' and carry1 = '1' then
          if digit2_reg = "111" then
            digit2_reg <= (others => '0'); -- Wrap to 0 after 7
          else
            digit2_reg <= digit2_reg + 1;
          end if;
        elsif count_down = '1' and borrow1 = '1' then
          if digit2_reg = "000" then
            digit2_reg <= "111"; -- Wrap to 7 after 0
          else
            digit2_reg <= digit2_reg - 1;
          end if;
        end if;
      end if;
    end if;
  end process proc_counter2;
  
  -- Counter logic for digit 3 (MSB)
  proc_counter3: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      digit3_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      if clear_active = '1' then
        digit3_reg <= (others => '0');
      elsif count_enable = '1' then
        if count_up = '1' and carry2 = '1' then
          if digit3_reg = "111" then
            digit3_reg <= (others => '0'); -- Wrap to 0 after 7 (7777->0000)
          else
            digit3_reg <= digit3_reg + 1;
          end if;
        elsif count_down = '1' and borrow2 = '1' then
          if digit3_reg = "000" then
            digit3_reg <= "111"; -- Wrap to 7 after 0 (0000->7777)
          else
            digit3_reg <= digit3_reg - 1;
          end if;
        end if;
      end if;
    end if;
  end process proc_counter3;
  
  -- Output assignments
  cntr0_o <= std_logic_vector(digit0_reg);
  cntr1_o <= std_logic_vector(digit1_reg);
  cntr2_o <= std_logic_vector(digit2_reg);
  cntr3_o <= std_logic_vector(digit3_reg);

end rtl;
