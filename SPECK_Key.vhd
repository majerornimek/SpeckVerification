library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity SPECK_Key is
	generic(
		WORD_SIZE	: integer := 32;
		ALPHA_SHIFT	: integer := 8;
		BETA_SHIFT	: integer := 3
	);
	port(
		data_in : in std_logic_vector(0 to 2*WORD_SIZE-1);
		--data_in_b : std_logic_vector(0 to WORD_SIZE-1);
		round_key : in std_logic_vector(0 to WORD_SIZE-1);
		data_out: out std_logic_vector(0 to 2*WORD_SIZE-1)
		--data_out_b: std_logic_vector(0 to WORD_SIZE-1)
	);
end entity;

architecture a1 of SPECK_Key is
signal data_in_a, data_in_b, adder, key_xor, data_out_a, data_out_b,  r_shift_alfa, l_shift_beta : std_logic_vector(0 to WORD_SIZE-1);



begin
data_in_a <= data_in(0 to WORD_SIZE-1);
data_in_b <= data_in(WORD_SIZE to 2*WORD_SIZE-1);


r_shift_alfa <= data_in_a(WORD_SIZE-ALPHA_SHIFT- 1 to WORD_SIZE-1) & data_in_a(0 to WORD_SIZE-ALPHA_SHIFT);
l_shift_beta <= data_in_b(BETA_SHIFT to WORD_SIZE-BETA_SHIFT-1) & data_in_b(0 to BETA_SHIFT-1);

adder <= unsigned(r_shift_alfa) + unsigned(data_in_b);
key_xor <= round_key xor adder;
data_out_b <= key_xor xor l_shift_beta;

data_out <= data_out_a & data_out_b;


end a1;