-------------------------------------------------------------------------------
--                                                                      
--                        Fulladder VHDL Class Example
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_fulladder
--
-- FILENAME:       tb_fulladder_sim.vhd
-- 
-- ARCHITECTURE:   sim
-- 
-- ENGINEER:       Roland Höller
--
-- DATE:           30. June 2000
--
-- VERSION:        1.0
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the architecture of the fulladder testbench
--                 for the fulladder VHDL class example.
--
--
-------------------------------------------------------------------------------
--
-- REFERENCES:     (none)
--
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGES:       std_logic_1164 (IEEE library)
--
-------------------------------------------------------------------------------
--                                                                      
-- CHANGES:        Version 2.0 - RH - 30 June 2000
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture sim of tb_fulladder is

  component fulladder
    port (a_i   : in  std_logic;  -- first data bit
          b_i   : in  std_logic;  -- second data bit
          cy_i  : in  std_logic;  -- carry input
          cy_o  : out std_logic;  -- carry output
          sum_o : out std_logic); -- sum output
  end component;
  
  -- Declare the signals used stimulating the design's inputs.
  signal a_i : std_logic;
  signal b_i : std_logic;
  signal cy_i : std_logic;
  signal sum_o : std_logic;
  signal cy_o : std_logic;
  
begin

  -- Instantiate the fulladder design for testing
  i_fulladder : fulladder
    port map (a_i   => a_i,
              b_i   => b_i,
              cy_i  => cy_i,
              cy_o  => cy_o,
              sum_o => sum_o);

  p_test : process
  begin
    -- ZERO
    a_i <= '0';
    b_i <= '0';
    cy_i <= '0';
    wait for 200 ns;
    -- ONE
    a_i <= '1';
    b_i <= '0';
    cy_i <= '0';
    wait for 200 ns;
    -- TWO
    a_i <= '0';
    b_i <= '1';
    cy_i <= '0';
    wait for 200 ns;
    -- THREE
    a_i <= '1';
    b_i <= '1';
    cy_i <= '0';
    wait for 200 ns;
    -- FOUR
    a_i <= '0';
    b_i <= '0';
    cy_i <= '1';
    wait for 200 ns;
    -- FIVE
    a_i <= '1';
    b_i <= '0';
    cy_i <= '1';
    wait for 200 ns;
    -- SIX
    a_i <= '0';
    b_i <= '1';
    cy_i <= '1';
    wait for 200 ns;
    -- SEVEN
    a_i <= '1';
    b_i <= '1';
    cy_i <= '1';
    wait;
  end process;

end sim;

