-------------------------------------------------------------------------------
-- MEL Counter Project - IO Control Unit RTL Architecture                    --
--                                                                           --
-- Description: RTL implementation of the IO control unit including          --
--              switch debouncing, 7-segment display multiplexing,           --
--              and LED control.                                             --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : io_ctrl_rtl.vhd                                                    --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE rtl OF io_ctrl IS

  -- Constants
  CONSTANT IO_DIV_COUNT : INTEGER := CLK_FREQ / REFRESH_FREQ - 1; -- 99999 for 1 kHz refresh at 100 MHz Clock

  -- Clock divider signals
  SIGNAL clk_en_cnt : INTEGER RANGE 0 TO IO_DIV_COUNT;
  SIGNAL clk_1khz_en : STD_LOGIC;

  -- Debouncing signals
  SIGNAL swsync : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL pbsync : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- 7-segment display signals
  SIGNAL digit_sel : STD_LOGIC_VECTOR(3 DOWNTO 0); -- 2 bits for 4 digits (0-3)
  SIGNAL current_digit : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

  -- Clock divider process for 1 kHz generation
  proc_clk_div : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      clk_en_cnt <= 0;
      clk_1khz_en <= '0';
    ELSIF rising_edge(clk_i) THEN
      IF clk_en_cnt = IO_DIV_COUNT THEN
        clk_en_cnt <= 0;
        clk_1khz_en <= '1';
      ELSE
        clk_en_cnt <= clk_en_cnt + 1;
        clk_1khz_en <= '0';
      END IF;
    END IF;
  END PROCESS proc_clk_div;

  -- Switch and button debouncing process (simple approach)
  proc_debounce : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      swsync <= (OTHERS => '0');
      pbsync <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clk_1khz_en = '1' THEN
        swsync <= sw_i;
        pbsync <= pb_i;
      END IF;
    END IF;
  END PROCESS proc_debounce;

  -- 7-segment display multiplexer
  proc_7seg_mux : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit_sel <= "1111";
    ELSIF rising_edge(clk_i) THEN

      IF clk_1khz_en = '1' THEN
        IF digit_sel = "0111" OR digit_sel = "1111" THEN
          digit_sel <= "1110";
        ELSE
          digit_sel <= digit_sel(2 DOWNTO 0) & "1";
        END IF;

      END IF;
    END IF;
  END PROCESS proc_7seg_mux;

  -- Output assignments
  swsync_o <= swsync;
  pbsync_o <= pbsync;
  led_o <= led_i;
  ss_sel_o <= digit_sel; -- Default to all off if invalid

  -- Determine current digit based on digit selection
  proc_current_digit : PROCESS (digit_sel)
  BEGIN
    CASE digit_sel IS
      WHEN "1110" => current_digit <= cntr0_i; -- LSB digit
      WHEN "1101" => current_digit <= cntr1_i;
      WHEN "1011" => current_digit <= cntr2_i;
      WHEN "0111" => current_digit <= cntr3_i; -- MSB digit
      WHEN OTHERS => current_digit <= "000";
    END CASE;
  END PROCESS proc_current_digit;

  -- 7-segment decoder
  proc_7seg_decode : PROCESS (current_digit)
  BEGIN
    CASE current_digit IS
      WHEN "000" => ss_o <= "11000000"; -- 0: segments a,b,c,d,e,f
      WHEN "001" => ss_o <= "11111001"; -- 1: segments b,c
      WHEN "010" => ss_o <= "10100100"; -- 2: segments a,b,g,e,d
      WHEN "011" => ss_o <= "10110000"; -- 3: segments a,b,g,c,d
      WHEN "100" => ss_o <= "10011001"; -- 4: segments f,g,b,c
      WHEN "101" => ss_o <= "10010010"; -- 5: segments a,f,g,c,d
      WHEN "110" => ss_o <= "10000010"; -- 6: segments a,f,g,e,d,c
      WHEN "111" => ss_o <= "11111000"; -- 7: segments a,b,c
      WHEN OTHERS => ss_o <= "11111111"; -- All segments off
    END CASE;
  END PROCESS proc_7seg_decode;

END rtl;