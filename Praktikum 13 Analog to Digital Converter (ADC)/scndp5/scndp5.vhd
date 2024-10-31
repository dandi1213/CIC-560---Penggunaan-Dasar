--The circuitry below indicates that hexadecimal DATAO[7..0]
--and decimal DOUT[9..0] are outputted to SCNDP module and 
--decoded as output to scan five 7-segment LEDs display:

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY scndp5 IS
PORT(	scnclk      	:in		Std_logic;
		datai			:in		Std_logic_vector(9 downto 0);
		datah			:in		Std_logic_vector(7 downto 0);		
		scan			:out	Std_logic_vector(4 downto 0);		
		s				:out	std_logic_vector(0 to 6)	
	);
END scndp5;

ARCHITECTURE scndp5_arch OF scndp5 IS

SIGNAL	scnt		   :std_logic_vector(2 downto 0);
SIGNAL	hexd		   :std_logic_vector(3 downto 0);

BEGIN 

 process(scnclk)--25kHz
 begin
      if scnclk'event and scnclk='1' then
        if scnt="100" then scnt <="000";
        else  scnt <= scnt+1;
        end if; 
      end if;
 end process;


	
	process(scnt,datai)
	begin
	        case scnt is when "000"=> 
				            hexd<=("0"&"0"& datai(9 downto 8));
				            scan<="00001";
						 when "001"=> 
				            hexd<=(datai(7 downto 4));
				            scan<="00010";
						 when "010"=> 
				            hexd<=(datai(3 downto 0));
				            scan<="00100";
				        when  "011"=>
				  			hexd<=(datah(7 downto 4));
				            scan<="01000";
						when  "100"=>
				  			hexd<=(datah(3 downto 0));
				            scan<="10000";
				        when  others=>
							hexd<=(datai(7 downto 4));
				            scan<="00000";
			end case;		
	end process;
	
					
		s(0 to 6)<= "1111110" when hexd="0000" else
					"0110000" when hexd="0001" else
					"1101101" when hexd="0010" else
					"1111001" when hexd="0011" else
					"0110011" when hexd="0100" else
					"1011011" when hexd="0101" else
					"1011111" when hexd="0110" else
					"1110000" when hexd="0111" else
					"1111111" when hexd="1000" else
					"1111011" when hexd="1001" else
					"1110111" when hexd="1010" else
					"0011111" when hexd="1011" else
					"1001110" when hexd="1100" else
					"0111101" when hexd="1101" else
					"1001111" when hexd="1110" else
					"1000111" when hexd="1111" else
					"ZZZZZZZ";
END scndp5_arch;
