library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity SPECK_22_rounds_tb is
end entity;

architecture a1 of SPECK_22_rounds_tb is

component SPECK_22_rounds is
	generic(
		WORD_SIZE	: integer := 16;
		ALPHA_SHIFT	: integer := 7;
		BETA_SHIFT	: integer := 2;
		NUM_ROUNDS	: integer := 22
	);
	port(
		data_in 	: in std_logic_vector(0 to 2*WORD_SIZE-1);
		key 		: in std_logic_vector(0 to 4*WORD_SIZE-1);
		data_out	: out std_logic_vector(0 to 2*WORD_SIZE-1)
	);
end component;


signal DataIN, DataOut : std_logic_vector(0 to 31);
signal KeyIn : std_logic_vector(0 to 63)
signal clk : std_logic := '0';
constant clk_period : time := 10 ps;
begin

uut: SPECK_22_rounds is
	port map(
		data_in 	=> DataIN,
		key 		=> KeyIn,
		data_out	DataOut
	);

   Clk_process :process
   begin
        Clk <= '0';
        wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
        Clk <= '1';
        wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
   end process;
	
	
	stim_proc: process
   begin        
        wait for CLK_PERIOD;
        DataIn <= x"65656877";
		  KeyIn <= x" 1918111009080100"
        wait for CLK_PERIOD*20;
        wait;
  end process;


end a1;