LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY clock2 IS
PORT(	clk,exclk				:in		std_logic;
        sel 					:in		std_logic_vector(2 downto 0);
		ssclko					:out	std_logic
);	
END clock2;

ARCHITECTURE clock2_arch OF clock2 IS
SIGNAL scount	:std_logic_vector(23 downto 0);
SIGNAL ssclk	:std_logic_vector(1 downto 0);
SIGNAL CA		:std_logic_vector(23 downto 0);


BEGIN  
   process(clk)
   begin
      if clk'event and clk='1' then
		    if scount >= CA then	scount<=x"000000";
								 	ssclk <= ssclk +1;
			else  scount <= scount + 1;
  			end if;
      else  scount <= scount  ;
      end if;
      

	
  end process;
 
   process(sel)
   begin
   case sel is when "000" => CA <= x"00e000";
               when "001" => CA <= x"03f000";
			   when "010" => CA <= x"09e111";
			   when "011" => CA <= x"0Fe000";
		       when "100" => CA <= x"10e0ff";
			   when "101" => CA <= x"4Ae999";
			   when "110" => CA <= x"9Befff";
			   when "111" => CA <= x"F0e0ff";
   end case;
   end process;
ssclko<=ssclk(0);

END clock2_arch;
