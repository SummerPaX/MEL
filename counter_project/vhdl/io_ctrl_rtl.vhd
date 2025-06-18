-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit RTL Architecture                   --
--                                                                           --
-- Description: RTL implementation of the IO control unit including         --
--              switch debouncing, 7-segment display multiplexing,          --
--              and LED control with 1 kHz refresh rate.                    --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                              --
-- Date : 18.06.2025                                                        --
-- File : io_ctrl_rtl.vhd                                                   --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of io_ctrl is

  -- Constants for frequency generation
  constant CLK_FREQ     : integer := 100_000_000; -- 100 MHz system clock
  constant REFRESH_FREQ : integer := 1_000;       -- 1 kHz for debouncing and 7-seg refresh
  constant DIV_COUNT    : integer := CLK_FREQ / REFRESH_FREQ - 1; -- 99999
  
  -- Clock divider signals
  signal clk_div_cnt    : unsigned(16 downto 0); -- 17 bits for count up to 99999
  signal clk_1khz       : std_logic;
  
  -- Debouncing signals
  signal sw_sync1       : std_logic_vector(15 downto 0);
  signal sw_sync2       : std_logic_vector(15 downto 0);
  signal sw_debounced   : std_logic_vector(15 downto 0);
  signal pb_sync1       : std_logic_vector(3 downto 0);
  signal pb_sync2       : std_logic_vector(3 downto 0);
  signal pb_debounced   : std_logic_vector(3 downto 0);
  
  -- 7-segment display signals
  signal digit_sel      : unsigned(1 downto 0); -- 2 bits for 4 digits (0-3)
  signal current_digit  : std_logic_vector(2 downto 0);
  signal segments       : std_logic_vector(7 downto 0);
  
  -- 7-segment decoder ROM (for octal digits 0-7)
  type seg_rom_type is array (0 to 7) of std_logic_vector(7 downto 0);
  constant SEG_ROM : seg_rom_type := (
    "11000000",  -- 0: segments a,b,c,d,e,f (CA-CF active low)
    "11111001",  -- 1: segments b,c
    "10100100",  -- 2: segments a,b,g,e,d
    "10110000",  -- 3: segments a,b,g,c,d
    "10011001",  -- 4: segments f,g,b,c
    "10010010",  -- 5: segments a,f,g,c,d
    "10000010",  -- 6: segments a,f,g,e,d,c
    "11111000"   -- 7: segments a,b,c
  );

begin

  -- Clock divider process for 1 kHz generation
  proc_clk_div: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      clk_div_cnt <= (others => '0');
      clk_1khz <= '0';
    elsif rising_edge(clk_i) then
      if clk_div_cnt = DIV_COUNT then
        clk_div_cnt <= (others => '0');
        clk_1khz <= '1';
      else
        clk_div_cnt <= clk_div_cnt + 1;
        clk_1khz <= '0';
      end if;
    end if;
  end process proc_clk_div;
  
  -- Switch debouncing process (double synchronizer + 1 kHz sampling)
  proc_switch_debounce: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      sw_sync1 <= (others => '0');
      sw_sync2 <= (others => '0');
      sw_debounced <= (others => '0');
    elsif rising_edge(clk_i) then
      if clk_1khz = '1' then
        sw_sync1 <= sw_i;
        sw_sync2 <= sw_sync1;
        sw_debounced <= sw_sync2;
      end if;
    end if;
  end process proc_switch_debounce;
  
  -- Push button debouncing process
  proc_button_debounce: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      pb_sync1 <= (others => '0');
      pb_sync2 <= (others => '0');
      pb_debounced <= (others => '0');
    elsif rising_edge(clk_i) then
      if clk_1khz = '1' then
        pb_sync1 <= pb_i;
        pb_sync2 <= pb_sync1;
        pb_debounced <= pb_sync2;
      end if;
    end if;
  end process proc_button_debounce;
  
  -- 7-segment display multiplexer
  proc_7seg_mux: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      digit_sel <= (others => '0');
    elsif rising_edge(clk_i) then
      if clk_1khz = '1' then
        digit_sel <= digit_sel + 1;
      end if;
    end if;
  end process proc_7seg_mux;
  
  -- Current digit selection
  proc_digit_select: process(digit_sel, cntr0_i, cntr1_i, cntr2_i, cntr3_i)
  begin
    case digit_sel is
      when "00" =>
        current_digit <= cntr0_i; -- LSB digit
      when "01" =>
        current_digit <= cntr1_i;
      when "10" =>
        current_digit <= cntr2_i;
      when "11" =>
        current_digit <= cntr3_i; -- MSB digit
      when others =>
        current_digit <= "000";
    end case;
  end process proc_digit_select;
  
  -- 7-segment decoder
  proc_7seg_decode: process(current_digit)
  begin
    if to_integer(unsigned(current_digit)) <= 7 then
      segments <= SEG_ROM(to_integer(unsigned(current_digit)));
    else
      segments <= "11111111"; -- All segments off for invalid values
    end if;
  end process proc_7seg_decode;
  
  -- Output assignments
  swsync_o <= sw_debounced;
  pbsync_o <= pb_debounced;
  led_o <= led_i;
  ss_o <= segments;
  
  -- 7-segment selection (active low, only one digit active at a time)
  proc_ss_select: process(digit_sel)
  begin
    ss_sel_o <= "1111"; -- Default: all off
    case digit_sel is
      when "00" =>
        ss_sel_o <= "1110"; -- Digit 0 active
      when "01" =>
        ss_sel_o <= "1101"; -- Digit 1 active
      when "10" =>
        ss_sel_o <= "1011"; -- Digit 2 active
      when "11" =>
        ss_sel_o <= "0111"; -- Digit 3 active
      when others =>
        ss_sel_o <= "1111"; -- All off
    end case;
  end process proc_ss_select;

end rtl;
