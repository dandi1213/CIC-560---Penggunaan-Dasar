LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY segb13a IS
PORT(	js					:in		std_logic_vector(5 downto 0);
        sel					:in     std_logic;       
        sclk ,clr			:in     std_logic;
        scndp				:out	std_logic_vector(5 downto 0);        
		s					:out	std_logic_vector(0 to 15)
);
END segb13a;

ARCHITECTURE segb13a_arch OF segb13a IS

SIGNAL scount	:std_logic_vector(29 downto 0);
signal j		:std_logic_vector(5 downto 0);


BEGIN

process (sclk)
begin
if (sclk'event and sclk='1') then
 if clr='1' then scount <="000000000000000000000000000000";
 elsif scount="110111111111111111111111111111" 
  then  scount <="000000000000000000000000000000";
 else scount <= scount+1;
 end if;
end if;
end process;
scndp <= scount(29 downto 24);
process(sel)
begin
  if   sel='1'  then j <= scount(29 downto 24);
  else                j <= js;
  end if;
end process;

-----A1,A2,B1,B2,C1,C2,D1,D2,E1,E2,F1,F2,H1,H2,G1,G2     (G H F)
s <= 	"1111111100000000" when j="000000" else--0
		"0011000000000000" when j="000001" else--1
		"1110111011000000" when j="000010" else--2
		"1111110011000000" when j="000011" else--3
		"0011000111000000" when j="000100" else--4
		"1101110111000000" when j="000101" else--5
		"1101111111000000" when j="000110" else--6
		"1111000000000000" when j="000111" else--7
		"1111111111000000" when j="001000" else--8
		"1111110111000000" when j="001001" else--9
		"1111001111000000" when j="001010" else--a
		"0001111111000000" when j="001011" else--b
		"1100111100000000" when j="001100" else--c
		"0011111011000000" when j="001101" else--d
		"1100111111000000" when j="001110" else--e
		"1100001111000000" when j="001111" else--f
		"1100111110000100" when j="010000" else--g
		"0011001111000000" when j="010001" else--h
		"0000000000000100" when j="010010" else--i 		
		"0000010000001100" when j="010011" else--j
		"0000000000101101" when j="010100" else--k		
		"0000111100000000" when j="010101" else--l		
		"0010000100100010" when j="010110" else--m
		"0000001010000100" when j="010111" else--n
		"0001111011000000" when j="011000" else--o
		"1110001111000000" when j="011001" else--p
		"1110000111010000" when j="011010" else--q		
		"1110001111000001" when j="011011" else--r		
		"1001100111000000" when j="011100" else--s
		"1100000000001100" when j="011101" else--t
		"0011111100000000" when j="011110" else--u
		"0011000000000011" when j="011111" else--v
		"0001001000010001" when j="100000" else--w
		"0000000000110011" when j="100001" else--x
		"0000000000100110" when j="100010" else--y
		"1100110000110000" when j="100011" else--z
		"0000000011110011" when j="100100" else--(X)
		"0000000011001100" when j="100101" else--(+)
		"0000000011000000" when j="100110" else--(-)
		"0000000000000011" when j="100111" else--(/)
		"1000000000000000" when j="101000" else--A1 Segment
		"0100000000000000" when j="101001" else--A2 Segment
		"0010000000000000" when j="101010" else--B1 Segment
		"0001000000000000" when j="101011" else--B2 Segment
		"0000100000000000" when j="101100" else--C1 Segment 
		"0000010000000000" when j="101101" else--C2 Segment 
		"0000001000000000" when j="101110" else--D1 Segment 
		"0000000100000000" when j="101111" else--D2 Segment
		"0000000010000000" when j="110000" else--E1 Segment 
		"0000000001000000" when j="110001" else--E2 Segment 
		"0000000000100000" when j="110010" else--F1 Segment  
		"0000000000010000" when j="110011" else--F2 Segment 
		"0000000000001000" when j="110100" else--G1 Segment  
		"0000000000000100" when j="110101" else--G2 Segment  
		"0000000000000010" when j="110110" else--H1 Segment   
		"0000000000000001" when j="110111" else--H2 Segment  
		"ZZZZZZZZZZZZZZZZ"; 

END segb13a_arch; 