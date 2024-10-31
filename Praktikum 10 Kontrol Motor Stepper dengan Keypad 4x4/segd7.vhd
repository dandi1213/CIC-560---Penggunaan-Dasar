LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY segd7 IS
PORT(	x				:in		std_logic_vector(3 downto 0);
		s				:out	std_logic_vector(6 downto 0)
);
END segd7;

ARCHITECTURE segd7_arch OF segd7 IS
BEGIN
s <=	"1111110" when x="0000" else
		"0110000" when x="0001" else
		"1101101" when x="0010" else
		"1111001" when x="0011" else
		"0110011" when x="0100" else
		"1011011" when x="0101" else
		"1011111" when x="0110" else
		"1110000" when x="0111" else
		"1111111" when x="1000" else
		"1111011" when x="1001" else
		"1110111" when x="1010" else
		"0011111" when x="1011" else
		"1001110" when x="1100" else
		"0111101" when x="1101" else
		"1001111" when x="1110" else
		"1000111" when x="1111" else
		"0000000";
END segd7_arch; 