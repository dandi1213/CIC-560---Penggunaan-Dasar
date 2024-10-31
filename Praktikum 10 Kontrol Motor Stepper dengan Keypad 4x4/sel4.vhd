LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sel4 IS
PORT(	s	:in		Std_logic_vector(1 downto 0);
		d	:in		Std_logic_vector(3 downto 0);
		y	:out	std_logic
	);
END sel4;

ARCHITECTURE sel4_arch OF sel4 IS
BEGIN

	process(s,d)
	begin
		case s is
			when "00" => y<=d(0);		
			when "01" => y<=d(1);	
			when "10" => y<=d(2);	
			when "11" => y<=d(3);	
			when others =>	y<='Z';
		end case;
	end process;
	
END sel4_arch;