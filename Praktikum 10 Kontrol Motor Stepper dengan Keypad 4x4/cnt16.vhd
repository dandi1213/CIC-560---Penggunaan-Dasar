LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY cnt16 IS
PORT(	clk,clr,en,ud	:in		Std_logic;
		op				:out	std_logic_vector(15 downto 0)
	);
END cnt16;

ARCHITECTURE cnt16_arch OF cnt16 IS
SIGNAL	ct	:std_logic_vector(15 downto 0);
BEGIN
	process(clk,en,ud,ct)
	begin
		if clk'event and clk='1' then
			if clr='1' then ct<=X"0000";
			elsif en='1' then
				if ud='1' then ct<=ct+1;
				else ct<=ct-1;
				end if;
			else ct<=ct;
			end if;			
		end if;
	op<=ct;
	end process;

END cnt16_arch;