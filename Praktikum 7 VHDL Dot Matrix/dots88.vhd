LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY dots88 IS
PORT(	exclk,clr,clks,en,dsps  :in		Std_logic;
        sel                 :in	    std_logic_vector(2 downto 0);
		dg,dr,s				:out	std_logic_vector(8 downto 1));
END dots88;

ARCHITECTURE dots88_arch OF dots88 IS
SIGNAL	dtab			:std_logic_vector(5 downto 0);
SIGNAL	scount    		:std_logic_vector(29 downto 0);
SIGNAL	dgdr			:std_logic_vector(1 to 16);
SIGNAL	scnt			:std_logic_vector(2 downto 0);
SIGNAL	scan			:std_logic_vector(5 downto 0);
SIGNAL  ssclk   	    :std_logic ;

BEGIN	
   process(clks)
   begin
	if clks'event and clks='1' then
		scount <=scount+1;
    end if;
   end process;

   process(sel,exclk)
   begin
   case sel is when "000" => ssclk <= exclk;
               when "001" => ssclk <= scount(11);
			   when "010" => ssclk <= scount(20);
			   when "011" => ssclk <= scount(22);
		       when "100" => ssclk <= scount(24);
			   when "101" => ssclk <= scount(25);
			   when "110" => ssclk <= scount(27);
			   when "111" => ssclk <= scount(28);
   end case;
   end process;

   process(scount(8))
   begin
	if scount(8)'event and scount(8)='1' then	--40m/2^8
		scnt <=scnt+1;							--scan display freq--
		end if;
   end process;	

   process(ssclk)
   begin
	if ssclk 'event and ssclk='1' then
		if clr='1' then scan<="000000";
		else
		  if en ='1' then						--next figure frequency
			 	scan<=scan+1;
		  else 	scan<=scan;
		  end if;
		end if;
	end if;
	end process;


   process(scnt)
   begin
	case scnt is
				when "000" => s<="10000000";			--scan display 
				if dsps='1' then dtab <= (scan(5 downto 3) & "000") + scan(2 downto 0);
				else dtab <= scan(2 downto 0) & "000" ;	--select shift display or change figure
				end if;
				when "001" => s<="01000000";
				if dsps='1' then dtab <= (scan(5 downto 3) & "001") + scan(2 downto 0);	    	          
				else dtab <= scan(2 downto 0) & "001" ;
                end if;					 
				when "010" => s<="00100000";
	            if dsps='1' then dtab <= (scan(5 downto 3) & "010") + scan(2 downto 0);
				else dtab <= scan(2 downto 0) & "010" ;
	            end if;
				when "011" => s<="00010000";
				if dsps='1' then dtab <= (scan(5 downto 3) & "011") + scan(2 downto 0);			    	
				else dtab <= scan(2 downto 0) & "011" ;
				end if;	
				when "100" => s<="00001000";
				if dsps='1' then dtab <= (scan(5 downto 3) & "100") + scan(2 downto 0);			    	
				else dtab <= scan(2 downto 0) & "100" ;
				end if;
				when "101" => s<="00000100";
				if dsps='1' then dtab <= (scan(5 downto 3) & "101") + scan(2 downto 0);			    	
				else dtab <= scan(2 downto 0) & "101" ;
				end if;
				when "110" => s<="00000010";
				if dsps='1' then dtab <= (scan(5 downto 3) & "110") + scan(2 downto 0);			    	
				else dtab <= scan(2 downto 0) & "110" ;
				end if;	
				when "111" => s<="00000001";
				if dsps='1' then dtab <= (scan(5 downto 3) & "111") + scan(2 downto 0);			  		
				else dtab <= scan(2 downto 0) & "111" ;
				end if;		
	        	when others =>	s<="00000000";
				                dtab<="000000";
				end case;
 				end process;	

				----------table of figure------
	dgdr<=  "0000000001101100" when dtab="000000" else
			"0110110011111110" when dtab="000001" else	
			"0111110011010110" when dtab="000010" else	
			"0111110011000110" when dtab="000011" else	
			"0011100001101100" when dtab="000100" else	
			"0001000000111000" when dtab="000101" else	
			"0000000000010000" when dtab="000110" else	
			"0000000000000000" when dtab="000111" else	
			"0001000000010000" when dtab="001000" else	
			"0010100000010000" when dtab="001001" else	
			"0110110000111000" when dtab="001010" else	
			"1000001011111110" when dtab="001011" else	
			"0110110000111000" when dtab="001100" else	
			"0010100000010000" when dtab="001101" else	
			"0001000000010000" when dtab="001110" else	
			"0000000000000000" when dtab="001111" else	--0f
		   --|green || red	|--
			"0000000000010000" when dtab="010000" else
			"0000000000111000" when dtab="010001" else
			"0000000000010000" when dtab="010010" else	
			"0100010001000100" when dtab="010011" else	
			"1111111011111110" when dtab="010100" else	
			"0101010001000100" when dtab="010101" else	
			"0001000000000000" when dtab="010110" else	
			"0011100000000000" when dtab="010111" else	
			"0011100000111000" when dtab="011000" else	
			"0101010000010000" when dtab="011001" else	
			"1011101001010100" when dtab="011010" else	
			"1000001001111100" when dtab="011011" else	
			"1011101001111100" when dtab="011100" else	
			"0101010000111000" when dtab="011101" else	
			"0010100000010000" when dtab="011110" else	
			"0001000000000000" when dtab="011111" else	--1f
			
			"0000000000010000" when dtab="100000" else
			"0000000000111000" when dtab="100001" else
			"0001000001111100" when dtab="100010" else	
			"0011100011111110" when dtab="100011" else	
			"0011100000111000" when dtab="100100" else	
			"0011100000101000" when dtab="100101" else	
			"0011100000000000" when dtab="100110" else	
			"0011100000000000" when dtab="100111" else	
			"0000000000010000" when dtab="101000" else	
			"0001000000101000" when dtab="101001" else	
			"0011100001101100" when dtab="101010" else	
			"1011101011101110" when dtab="101011" else	
			"1001001010111010" when dtab="101100" else	
			"1000001010010010" when dtab="101101" else	
			"0011100000010000" when dtab="101110" else	
			"0010100000000000" when dtab="101111" else	--2f
			
			"1111110000111111" when dtab="110000" else
			"1111111001111111" when dtab="110001" else
			"1111111111111111" when dtab="110010" else	
			"0111111111111110" when dtab="110011" else	
			"0011111111111100" when dtab="110100" else	
			"0001111111111000" when dtab="110101" else	
			"0000111111110000" when dtab="110110" else	
			"0000011111100000" when dtab="110111" else	
			"1111110000111111" when dtab="111000" else	
			"1111111001111111" when dtab="111001" else	
			"1111111111111111" when dtab="111010" else	
			"0111111111111110" when dtab="111011" else	
			"0011111111111100" when dtab="111100" else	
			"0001111111111000" when dtab="111101" else	
			"0000111111110000" when dtab="111110" else	
			"0000011111100000" when dtab="111111" else	--3f
			"ZZZZZZZZZZZZZZZZ";
	dg<= dgdr(1 to 8);			
	dr<= dgdr(9 to 16);			
END dots88_arch;
