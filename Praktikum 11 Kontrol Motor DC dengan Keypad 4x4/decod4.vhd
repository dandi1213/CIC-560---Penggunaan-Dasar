LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY decod4 IS
PORT(	a,b			:in		Std_logic;
		d0,d1,d2,d3	:out	Std_logic
	);
END decod4;

ARCHITECTURE decod4_arch OF decod4 IS
BEGIN

d0<=not a and not b;
d1<=a and not b;
d2<=not a and b;
d3<=a and b;
	
END decod4_arch;