--********************************
--   Mechanical Scan Key   
--********************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY scankey IS
	PORT(	clk ,htone      :IN  STD_LOGIC;
	        kcol            :in  STD_LOGIC_VECTOR(3 downto 0);
	        krow		    :out STD_LOGIC_VECTOR(3 downto 0);
		
	        musickey        :out STD_LOGIC_VECTOR(5 downto 0);
	        kdata,ltdata    :out STD_LOGIC_VECTOR(3 downto 0);	        
			keypress,intp,strobe  :out STD_LOGIC );
END scankey;

ARCHITECTURE scankey_arch  OF scankey IS
SIGNAL scount  : STD_LOGIC_VECTOR(19 downto 0);--19
SIGNAL krcnt   : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL ltdatap,kdatap : STD_LOGIC_VECTOR(3 downto 0);

SIGNAL kdatab  : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL sclk,dlt,dlt1,dlt2,dlt3,dlt4,ltd  : STD_LOGIC;
signal dlp1,dlp2,dlp3,dlp4,release ,ppsclk : STD_LOGIC;

BEGIN
musickey <= ("00" & kdatap(3 downto 0)) + ('0' & htone & "0000") + "000001";

process (clk,scount)
begin 
 if clk'event and clk='1' then 
         scount <= scount+1;
 else    scount <= scount;
 end if;
end process;

process (sclk,scount)
begin 
if scount = x"00002" then sclk <='1';--x"00000"
else                      sclk <='0';
end if;
if scount = x"00008" then ppsclk <='1' ;
else                      ppsclk <='0';
end if;
end process;

ltd  <= dlt and not dlt1;
intp <= dlt1 and not dlt4;

strobe <= dlt1 and not dlt2;

keypress <= release;
ltdata  <= ltdatap;
release <= kdatab(4) or dlp1 or dlp2 or dlp3 or dlp4;
process (clk,sclk)
begin 
 if clk'event and clk='1' then 
    dlt <=kdatab(4);
    dlt1<=dlt;
    dlt2 <=dlt1;
    dlt3 <=dlt2;
    dlt4 <=dlt3;
    if ltd='1' then kdatap <= kdatab(3 downto 0);    
    elsif       release='0'  then   kdatap <= "0000" ;
    else                            kdatap <= kdatap; 
    end if;

	if ltd='1' then ltdatap <= kdatab(3 downto 0);     
    else            ltdatap <= ltdatap; 
    end if;

    if sclk='1' then krcnt <= krcnt+1;
    else             krcnt <= krcnt;
    end if;      
    
    if ppsclk='1' then 
                dlp1 <=kdatab(4);
				dlp2 <=dlp1;
				dlp3 <=dlp2;
				dlp4 <=dlp3;
				
	else        dlp1 <=dlp1;
				dlp2 <=dlp2;
				dlp3 <=dlp3;
				dlp4 <=dlp4;
	end if;			
 end if;
end process;

process (krcnt)
begin 
 case krcnt is when "00" => krow <="0001";
			   when "01" => krow <="0010";
			   when "10" => krow <="0100";
			   when "11" => krow <="1000";
 end case;
end process;
			
kdata <=kdatap(3 downto 0);


process (krcnt,kcol)
begin 
case kcol  is when "0000" => kdatab <=('0' & "0000");
		      when "0001" => kdatab <=('1' & krcnt & "00");
			  when "0010" => kdatab <=('1' & krcnt & "01");
		      when "0100" => kdatab <=('1' & krcnt & "10");
              when "1000" => kdatab <=('1' & krcnt & "11" );
			  when others => kdatab <=('0' & "0000");
end case;
end process;
 
end scankey_arch;
