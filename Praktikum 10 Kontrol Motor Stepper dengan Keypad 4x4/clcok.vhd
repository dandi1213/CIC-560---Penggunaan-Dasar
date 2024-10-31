LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY clock IS
PORT(	clk,exclk				:in		std_logic;
        sel 					:in		std_logic_vector(2 downto 0);
		ssclko					:out	std_logic
);	
END clock;

ARCHITECTURE clock_arch OF clock IS
SIGNAL scount	:std_logic_vector(23 downto 0);
signal ssclk    :std_logic; 

BEGIN  
   process(clk)
   begin
      if clk'event and clk='1' then
            scount <= scount + 1 ;
      else  scount <= scount  ;
      end if;
      

	
  end process;
 
   process(sel,scount)
   begin
   case sel is when "000" => ssclk <= exclk;
               when "001" => ssclk <= scount(15);
			   when "010" => ssclk <= scount(16);
			   when "011" => ssclk <= scount(17);
		       when "100" => ssclk <= scount(18);
			   when "101" => ssclk <= scount(20);
			   when "110" => ssclk <= scount(22);
			   when "111" => ssclk <= scount(23);
   end case;
   end process;
ssclko<=ssclk;

END clock_arch;
