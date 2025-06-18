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

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE rtl OF io_ctrl IS

  -- Clock divider signals
  SIGNAL clk_div_cnt : unsigned(16 DOWNTO 0); -- 17 bits for count up to max div count
  SIGNAL clk_1khz : STD_LOGIC;

  -- Debouncing signals
  SIGNAL sw_sync1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sw_sync2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sw_debounced : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL pb_sync1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL pb_sync2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL pb_debounced : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- 7-segment display signals
  SIGNAL digit_sel : unsigned(1 DOWNTO 0); -- 2 bits for 4 digits (0-3)
  SIGNAL current_digit : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL segments : STD_LOGIC_VECTOR(7 DOWNTO 0);

  -- 7-segment decoder ROM (for octal digits 0-7)
  TYPE seg_rom_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  CONSTANT SEG_ROM : seg_rom_type := (
    "11000000", -- 0: segments a,b,c,d,e,f (CA-CF active low)
    "11111001", -- 1: segments b,c
    "10100100", -- 2: segments a,b,g,e,d
    "10110000", -- 3: segments a,b,g,c,d
    "10011001", -- 4: segments f,g,b,c
    "10010010", -- 5: segments a,f,g,c,d
    "10000010", -- 6: segments a,f,g,e,d,c
    "11111000" -- 7: segments a,b,c
  );

BEGIN

  -- Clock divider process for 1 kHz generation
  proc_clk_div : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      clk_div_cnt <= (OTHERS => '0');
      clk_1khz <= '0';
    ELSIF rising_edge(clk_i) THEN
      IF clk_div_cnt = IO_DIV_COUNT THEN
        clk_div_cnt <= (OTHERS => '0');
        clk_1khz <= '1';
      ELSE
        clk_div_cnt <= clk_div_cnt + 1;
        clk_1khz <= '0';
      END IF;
    END IF;
  END PROCESS proc_clk_div;

  -- Switch debouncing process (double synchronizer + 1 kHz sampling)
  proc_switch_debounce : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      sw_sync1 <= (OTHERS => '0');
      sw_sync2 <= (OTHERS => '0');
      sw_debounced <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clk_1khz = '1' THEN
        sw_sync1 <= sw_i;
        sw_sync2 <= sw_sync1;
        sw_debounced <= sw_sync2;
      END IF;
    END IF;
  END PROCESS proc_switch_debounce;

  -- Push button debouncing process
  proc_button_debounce : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      pb_sync1 <= (OTHERS => '0');
      pb_sync2 <= (OTHERS => '0');
      pb_debounced <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clk_1khz = '1' THEN
        pb_sync1 <= pb_i;
        pb_sync2 <= pb_sync1;
        pb_debounced <= pb_sync2;
      END IF;
    END IF;
  END PROCESS proc_button_debounce;

  -- 7-segment display multiplexer
  proc_7seg_mux : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit_sel <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clk_1khz = '1' THEN
        digit_sel <= digit_sel + 1;
      END IF;
    END IF;
  END PROCESS proc_7seg_mux;

  -- Current digit selection
  proc_digit_select : PROCESS (digit_sel, cntr0_i, cntr1_i, cntr2_i, cntr3_i)
  BEGIN
    CASE digit_sel IS
      WHEN "00" =>
        current_digit <= cntr0_i; -- LSB digit
      WHEN "01" =>
        current_digit <= cntr1_i;
      WHEN "10" =>
        current_digit <= cntr2_i;
      WHEN "11" =>
        current_digit <= cntr3_i; -- MSB digit
      WHEN OTHERS =>
        current_digit <= "000";
    END CASE;
  END PROCESS proc_digit_select;

  -- 7-segment decoder
  proc_7seg_decode : PROCESS (current_digit)
  BEGIN
    IF to_integer(unsigned(current_digit)) <= 7 THEN
      segments <= SEG_ROM(to_integer(unsigned(current_digit)));
    ELSE
      segments <= "11111111"; -- All segments off for invalid values
    END IF;
  END PROCESS proc_7seg_decode;

  -- Output assignments
  swsync_o <= sw_debounced;
  pbsync_o <= pb_debounced;
  led_o <= led_i;
  ss_o <= segments;

  -- 7-segment selection (active low, only one digit active at a time)
  proc_ss_select : PROCESS (digit_sel)
  BEGIN
    ss_sel_o <= "1111"; -- Default: all off
    CASE digit_sel IS
      WHEN "00" =>
        ss_sel_o <= "1110"; -- Digit 0 active
      WHEN "01" =>
        ss_sel_o <= "1101"; -- Digit 1 active
      WHEN "10" =>
        ss_sel_o <= "1011"; -- Digit 2 active
      WHEN "11" =>
        ss_sel_o <= "0111"; -- Digit 3 active
      WHEN OTHERS =>
        ss_sel_o <= "1111"; -- All off
    END CASE;
  END PROCESS proc_ss_select;

END rtl;