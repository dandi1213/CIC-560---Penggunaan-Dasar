LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY keyps4 IS
PORT(	kb,clk			:in		Std_logic;
		ps,ltdp			:out	Std_logic
	);
END keyps4;

ARCHITECTURE keyps4_arch OF keyps4 IS
signal	stk 		:std_logic_vector(2 downto 0);
signal	stdp		:std_logic_vector(1 downto 0);
BEGIN

ltdp<=stdp(0);
ps<=stk(0);
process(stk,stdp,kb,clk)
begin
	if clk'event and clk='1' then
		case stdp is
			when "00" =>
				if kb='1' then stdp<="01";
				else stdp<="00";
				end if;
			when "01" => stdp<="10";
			when "10" =>
				if kb='0' then stdp<="00";
				else stdp<="10";
				end if;
			when "11" =>
				stdp<="00";
			when others => stdp<="00";
		end case;
		case stk is
			when "000" =>
				if stdp(0)='1' then stk<="001";
				else stk<="000";
				end if;
			when "001" => stk<="010";
			when "010" => stk<="011";
			when "011" => stk<="100";
			when "100" => stk<="101";
			when "101" => stk<="110";
			when "110" => stk<="111";
			when "111" =>
				if stdp(0)='0' then stk<="000";
				else stk<="111";
				end if;
			when others =>
				stk<="000";
		end case;
	end if;
end process;	
END keyps4_arch;