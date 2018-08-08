library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

entity SPECK_22_rounds is
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
end entity;


architecture a1 of SPECK_22_rounds is

component SPECK_Round is
	generic(
		WORD_SIZE	: integer := 16;
		ALPHA_SHIFT	: integer := 7;
		BETA_SHIFT	: integer := 2
	);
	port(
		data_in : in std_logic_vector(0 to 2*WORD_SIZE-1);
		round_key : in std_logic_vector(0 to WORD_SIZE-1);
		data_out: out std_logic_vector(0 to 2*WORD_SIZE-1)
	);
end component;


component SPECK_Key is
	generic(
		WORD_SIZE	: integer := 16;
		ALPHA_SHIFT	: integer := 7;
		BETA_SHIFT	: integer := 2
	);
	port(
		data_in_a : in std_logic_vector(0 to WORD_SIZE-1);
		data_in_b : in std_logic_vector(0 to WORD_SIZE-1);
		round_key : in std_logic_vector(0 to WORD_SIZE-1);
		data_out_a: out std_logic_vector(0 to WORD_SIZE-1);
		data_out_b: out std_logic_vector(0 to WORD_SIZE-1)
	);
end component;


type VEC is array (natural range<>) of std_logic_vector(0 to 2*WORD_SIZE-1);
signal douts : VEC(0 to NUM_ROUNDS);
type Subkey is array(natural range<>) of std_logic_vector(0 to WORD_SIZE-1);
signal key_l : Subkey(0 to 3);
signal key_feedback : Subkey(0 to 3);
signal first_subkey : std_logic_vector(0 to 2*WORD_SIZE-1);


signal round_key_sig : Subkey(0 to NUM_ROUNDS+3);
signal key_tmp 		: Subkey(0 to 3*NUM_ROUNDS);


begin
s: for i in 0 to NUM_ROUNDS generate 
		
		first: if i=0 generate
			sp :SPECK_Round port map(
				data_in => data_in,
				round_key => key(3*WORD_SIZE to 4*WORD_SIZE-1),
				data_out => douts(0)
			);
		end generate first;
		
		
		middle: if i>0 generate 
			sm : SPECK_Round port map(
				data_in => douts(i-1),
				round_key => round_key_sig(i),
				data_out =>douts(i)
			);
		end generate middle;
		
end generate s;



data_out <= douts(NUM_ROUNDS-1);

key_tmp(1) <= key(WORD_SIZE to 2*WORD_SIZE-1);
key_tmp(2) <= key(0 to WORD_SIZE-1);

keyg: for i in 0 to NUM_ROUNDS generate
		
		firstk: if i=0 generate
			kp: SPECK_Key port map(
				data_in_a => key(3*WORD_SIZE to 4*WORD_SIZE-1),
				data_in_b => key(2*WORD_SIZE to 3*WORD_SIZE-1),
				round_key => std_logic_vector(to_unsigned(i,WORD_SIZE)),
				data_out_a => key_tmp(3),
				data_out_b => round_key_sig(i+1)
			);
		end generate firstk;
		
		
		middlek: if i>0 generate 
			km: SPECK_Key port map(
				data_in_a => key_tmp(i),
				data_in_b => round_key_sig(i),
				round_key => std_logic_vector(to_unsigned(i,WORD_SIZE)),
				data_out_a => key_tmp(i+3),
				data_out_b => round_key_sig(i+1)
			);
		end generate middlek;

end generate keyg;







end a1;