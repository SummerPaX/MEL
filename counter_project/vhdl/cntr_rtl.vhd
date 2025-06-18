-------------------------------------------------------------------------------
-- MEL Counter Project - Counter Unit RTL Architecture                       --
--                                                                           --
-- Description: RTL implementation of 4-digit octal counter with 1 Hz        --
--              counting frequency. Supports up/down counting with           --
--              wraparound and priority control scheme.                      --
--                                                                           --
-- Author : Summer Paulus, Matthias Brinskelle                               --
-- Date : 18.06.2025                                                         --
-- File : cntr_rtl.vhd                                                       --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.config_pkg.ALL;

ARCHITECTURE rtl OF cntr IS

  -- Clock divider signals  
  SIGNAL clk_div_cnt : unsigned(26 DOWNTO 0); -- 27 bits for count up to max div count
  SIGNAL count_enable : STD_LOGIC;

  -- Counter registers (3 bits each for octal: 0-7)
  SIGNAL digit0_reg : unsigned(2 DOWNTO 0); -- LSB
  SIGNAL digit1_reg : unsigned(2 DOWNTO 0);
  SIGNAL digit2_reg : unsigned(2 DOWNTO 0);
  SIGNAL digit3_reg : unsigned(2 DOWNTO 0); -- MSB

  -- Carry/borrow signals
  SIGNAL carry0 : STD_LOGIC;
  SIGNAL carry1 : STD_LOGIC;
  SIGNAL carry2 : STD_LOGIC;
  SIGNAL borrow0 : STD_LOGIC;
  SIGNAL borrow1 : STD_LOGIC;
  SIGNAL borrow2 : STD_LOGIC;

  -- Control signals with priority
  SIGNAL clear_active : STD_LOGIC;
  SIGNAL count_up : STD_LOGIC;
  SIGNAL count_down : STD_LOGIC;
  SIGNAL hold_count : STD_LOGIC;

BEGIN

  -- Priority control logic
  -- Priority: Clear > Up/Down > Hold
  clear_active <= cntrclear_i;
  count_up <= (NOT cntrclear_i) AND cntrup_i AND (NOT cntrdown_i);
  count_down <= (NOT cntrclear_i) AND (NOT cntrup_i) AND cntrdown_i;
  hold_count <= (NOT cntrclear_i) AND cntrhold_i AND (NOT cntrup_i) AND (NOT cntrdown_i);

  -- Clock divider for 1 Hz counting frequency
  proc_clk_div : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      clk_div_cnt <= (OTHERS => '0');
      count_enable <= '0';
    ELSIF rising_edge(clk_i) THEN
      IF clk_div_cnt = DIV_COUNT THEN
        clk_div_cnt <= (OTHERS => '0');
        count_enable <= '1';
      ELSE
        clk_div_cnt <= clk_div_cnt + 1;
        count_enable <= '0';
      END IF;
    END IF;
  END PROCESS proc_clk_div;

  -- Carry logic for counting up
  carry0 <= '1' WHEN digit0_reg = "111" ELSE
    '0'; -- Carry when digit reaches 7
  carry1 <= carry0 WHEN digit1_reg = "111" ELSE
    '0';
  carry2 <= carry1 WHEN digit2_reg = "111" ELSE
    '0';

  -- Borrow logic for counting down  
  borrow0 <= '1' WHEN digit0_reg = "000" ELSE
    '0'; -- Borrow when digit reaches 0
  borrow1 <= borrow0 WHEN digit1_reg = "000" ELSE
    '0';
  borrow2 <= borrow1 WHEN digit2_reg = "000" ELSE
    '0';

  -- Counter logic for digit 0 (LSB)
  proc_counter0 : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit0_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clear_active = '1' THEN
        digit0_reg <= (OTHERS => '0');
      ELSIF count_enable = '1' THEN
        IF count_up = '1' THEN
          IF digit0_reg = "111" THEN
            digit0_reg <= (OTHERS => '0'); -- Wrap to 0 after 7
          ELSE
            digit0_reg <= digit0_reg + 1;
          END IF;
        ELSIF count_down = '1' THEN
          IF digit0_reg = "000" THEN
            digit0_reg <= "111"; -- Wrap to 7 after 0
          ELSE
            digit0_reg <= digit0_reg - 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_counter0;

  -- Counter logic for digit 1
  proc_counter1 : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit1_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clear_active = '1' THEN
        digit1_reg <= (OTHERS => '0');
      ELSIF count_enable = '1' THEN
        IF count_up = '1' AND carry0 = '1' THEN
          IF digit1_reg = "111" THEN
            digit1_reg <= (OTHERS => '0'); -- Wrap to 0 after 7
          ELSE
            digit1_reg <= digit1_reg + 1;
          END IF;
        ELSIF count_down = '1' AND borrow0 = '1' THEN
          IF digit1_reg = "000" THEN
            digit1_reg <= "111"; -- Wrap to 7 after 0
          ELSE
            digit1_reg <= digit1_reg - 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_counter1;

  -- Counter logic for digit 2
  proc_counter2 : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit2_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clear_active = '1' THEN
        digit2_reg <= (OTHERS => '0');
      ELSIF count_enable = '1' THEN
        IF count_up = '1' AND carry1 = '1' THEN
          IF digit2_reg = "111" THEN
            digit2_reg <= (OTHERS => '0'); -- Wrap to 0 after 7
          ELSE
            digit2_reg <= digit2_reg + 1;
          END IF;
        ELSIF count_down = '1' AND borrow1 = '1' THEN
          IF digit2_reg = "000" THEN
            digit2_reg <= "111"; -- Wrap to 7 after 0
          ELSE
            digit2_reg <= digit2_reg - 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_counter2;

  -- Counter logic for digit 3 (MSB)
  proc_counter3 : PROCESS (clk_i, reset_i)
  BEGIN
    IF reset_i = '1' THEN
      digit3_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk_i) THEN
      IF clear_active = '1' THEN
        digit3_reg <= (OTHERS => '0');
      ELSIF count_enable = '1' THEN
        IF count_up = '1' AND carry2 = '1' THEN
          IF digit3_reg = "111" THEN
            digit3_reg <= (OTHERS => '0'); -- Wrap to 0 after 7 (7777->0000)
          ELSE
            digit3_reg <= digit3_reg + 1;
          END IF;
        ELSIF count_down = '1' AND borrow2 = '1' THEN
          IF digit3_reg = "000" THEN
            digit3_reg <= "111"; -- Wrap to 7 after 0 (0000->7777)
          ELSE
            digit3_reg <= digit3_reg - 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_counter3;

  -- Output assignments
  cntr0_o <= STD_LOGIC_VECTOR(digit0_reg);
  cntr1_o <= STD_LOGIC_VECTOR(digit1_reg);
  cntr2_o <= STD_LOGIC_VECTOR(digit2_reg);
  cntr3_o <= STD_LOGIC_VECTOR(digit3_reg);

END rtl;