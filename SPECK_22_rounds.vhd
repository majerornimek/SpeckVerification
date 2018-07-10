library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

entity SPECK_22_rounds is
	generic(
		WORD_SIZE	: integer := 16;
		ALPHA_SHIFT	: integer := 8;
		BETA_SHIFT	: integer := 3;
		NUM_ROUNDS	: integer := 22
	);
	port(
		data_in 	: in std_logic_vector(0 to 2*WORD_SIZE-1);
		key 		: in std_logic_vector(0 to 2*WORD_SIZE-1);
		data_out	: out std_logic_vector(0 to 2*WORD_SIZE-1)
	);
end entity;


architecture a1 of SPECK_22_rounds is

component SPECK_Round is
	generic(
		WORD_SIZE	: integer := 16;
		ALPHA_SHIFT	: integer := 8;
		BETA_SHIFT	: integer := 3
	);
	port(
		data_in : in std_logic_vector(0 to 2*WORD_SIZE-1);
		round_key : in std_logic_vector(0 to WORD_SIZE-1);
		data_out: out std_logic_vector(0 to 2*WORD_SIZE-1)
	);
end component;



type VEC is array (natural range<>) of std_logic_vector(0 to 2*WORD_SIZE-1);
signal douts : VEC(0 to NUM_ROUNDS);
signal round_key_sig : VEC(0 to NUM_ROUNDS);
begin
s: for i in 0 to NUM_ROUNDS generate 
		
		first: if i=0 generate
			sp :SPECK_Round port map(
				data_in => data_in,
				round_key => key(WORD_SIZE to 2*WORD_SIZE-1),
				data_out => douts(0)
			);
		end generate first;
		
		
		middle: if i>0 generate 
			sm : SPECK_Round port map(
				data_in => douts(i-1),
				round_key => round_key_sig(i)(WORD_SIZE to 2*WORD_SIZE-1),
				data_out =>douts(i)
			);
		end generate middle;
		
end generate s;

data_out <= douts(NUM_ROUNDS-1);

keyg: for i in 0 to NUM_ROUNDS generate
		
		firstk: if i=0 generate
			kp: SPECK_Round port map(
				data_in => key,
				round_key => key(WORD_SIZE to 2*WORD_SIZE-1),
				data_out => round_key_sig(0)
			);
		end generate firstk;
		
		
		middlek: if i>0 generate 
			km: SPECK_Round port map(
				data_in => round_key_sig(i-1),
				round_key => std_logic_vector(to_unsigned(i,WORD_SIZE)),
				data_out => round_key_sig(i)
			);
		end generate middlek;

end generate keyg;
end a1;