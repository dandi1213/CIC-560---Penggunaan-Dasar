LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY segb13a IS
PORT(	js					:in		std_logic_vector(5 downto 0);
        sel					:in     std_logic;       
        sclk  				:in     std_logic;
		s					:out	std_logic_vector(0 to 16)
);
END segb13a;

ARCHITECTURE segb13a_arch OF segb13a IS
SIGNAL scount	:std_logic_vector(26 downto 0);
signal j		:std_logic_vector(5 downto 0);

BEGIN

process (sclk)
begin
scount <= scount+1;
end process;

process(sel)
begin
  if sel then j <= scount[26..21];
  else        j <= js;
  end if;
end process;

s <= 	"11111111000000000" when j="000000" else
		"00110000000000000" when j="000001" else
		"11101110110000000" when j="000010" else
		"11111100110000000" when j="000011" else
		"00110001001100000" when j="000100" else
		"11011101110000000" when j="000101" else
		"11011111110000000" when j="000110" else
		"11110000000000000" when j="000111" else
		"11111111110000000" when j="001000" else
		"11111101110000000" when j="001001" else
		"11110011110000000" when j="001010" else
		"00011111110000000" when j="001011" else
		"11001111000000000" when j="001100" else
		"00111110110000000" when j="001101" else
		"11001111110000000" when j="001110" else
		"11000011110000000" when j="001111" else
		"11001111100001001" when j="010000" else
		"00110011110000001" when j="010001" else
		"00000000000100001" when j="010010" else
		"00000100001100001" when j="010011" else
		"00000000001101101" when j="010100" else
		"00001111000000001" when j="010101" else
		"00100001000010101" when j="010110" else
		"00000010100100001" when j="010111" else
		"00011110110000001" when j="011000" else
		"11100011110000001" when j="011001" else
		"11100001110001001" when j="011010" else 
		"11100011110001001" when j="011011" else 
		"10011001110000001" when j="011100" else 
		"11000000001100001" when j="011101" else 
		"00111111000000001" when j="011110" else 
		"00110000000011001" when j="011111" else 
		"00010010000001011" when j="100000" else 
		"00000000000011110" when j="100001" else 
		"00000000000110101" when j="100010" else 
		"11001100000000110" when j="100011" else 
		"00000000110011111" when j="100100" else 
		"00000000111100001" when j="100101" else 
		"00000000110000001" when j="100110" else 
		"00000000000000111" when j="100111" else
		"ZZZZZZZZZZZZZZZZZ"; 

END segb13a_arch; 