LIBRARY ieee,altera;
USE altera.maxplus2.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY scankdpp4 IS
PORT(	clk,clr	:in		Std_logic;
		colk		:in		std_logic_vector(3 downto 0);
		s			:out	std_logic_vector(6 downto 0);
		keydata		:out	std_logic_vector(15 downto 0);
		rowk,det,selout		:out	std_logic_vector(3 downto 0)
	);
END scankdpp4;

ARCHITECTURE scankdpp4_arch OF scankdpp4 IS
signal divd		:std_logic_vector(6 downto 0);
signal sftd		:std_logic_vector(15 downto 0);
signal sel		:std_logic_vector(1 downto 0);
signal cntout,key_d,sfto :std_logic_vector(3 downto 0);
signal pulse,pls4,sclk,sdo	:std_logic;


component keybpg
	PORT(	clk		:in 	std_logic;
			strobe,pck4		:out 	std_logic;
			col		:in		std_logic_vector(3 downto 0);
			row,d	:out	std_logic_vector(3 downto 0) 
		);
END component;
component sftd15
PORT(	pulse,pls4,clr	:in		Std_logic;
		d			:in		std_logic_vector(3 downto 0);
		sdo			:out	std_logic;
		sftd		:out	std_logic_vector(15 downto 0);
		sfto		:out	std_logic_vector(3 downto 0)
	);
END component;
BEGIN
	
	key:keybpg port map(clk,pulse,pls4,colk,rowk,key_d);
	sft:sftd15 port map(pulse,pls4,clr,key_d,sdo,sftd,sfto);
	det<=key_d;  				--det :afer press button, counter sent data to det
	keydata <=sftd;				--sftd[15..0]
	
	----------scan display--------
	process(clk,sel,sftd)
	begin
		if clk'event and clk='1' then
			divd<=divd+1;
			sel<=divd(5 downto 4);
		end if;
						
		case sel is
			when "00" =>
				selout<="1000";
				cntout<=sftd(3 downto 0);
			when "01" =>
				selout<="0100";
				cntout<=sftd(7 downto 4);
			when "10" =>
				selout<="0010";
				cntout<=sftd(11 downto 8);
			when "11" =>
				selout<="0001";
				cntout<=sftd(15 downto 12);
			when others=>
		end case;
	end process;  
	-----------------7-segment display table------------
	s <= 	"0111111" when cntout="0000" else
			"0000110" when cntout="0001" else
			"1011011" when cntout="0010" else
			"1001111" when cntout="0011" else
			"1100110" when cntout="0100" else
			"1101101" when cntout="0101" else
			"1111101" when cntout="0110" else
			"0000111" when cntout="0111" else
			"1111111" when cntout="1000" else
			"1101111" when cntout="1001" else
			"1110111" when cntout="1010" else
			"1111100" when cntout="1011" else
			"0111001" when cntout="1100" else
			"1011110" when cntout="1101" else
			"1111001" when cntout="1110" else
			"1110001" when cntout="1111" else
			"0000000";
END scankdpp4_arch;
