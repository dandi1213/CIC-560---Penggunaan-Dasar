LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

entity musicsound is
port(sysclk,play     :in std_logic;
     freq            :in std_logic_vector(11 downto 0);--music table 
    
     sound      	 :out std_logic );
end entity;

architecture music of musicsound is

signal scount :std_logic_vector(4 downto 0);
signal count  :std_logic_vector(11 downto 0);
signal sclk,clkp  :std_logic;

begin 
sound <= clkp and play  ;
  process(sysclk)
  begin
    if sysclk'event and sysclk='1' then
      if scount="10100" then scount<="00000";sclk<='1';--40mhz/20=2mhz
      else scount <= scount+1;sclk<='0';
      end if;   
    end if;
  end process;
 
  process(sysclk,sclk)
  begin
    if sysclk'event and sysclk='1' then
      if sclk='1' and play='1' then        
	    if count=x"000" then
		   count <= freq; 
		else
		  count <= count-1;  
		end if;
	  else count <=count;
	  end if;	  
	end if;
  end process;  

  process(sysclk)
  begin
	if sysclk'event and sysclk='1' then
	 if sclk='1'  then
	  if (count=x"000" and play='1')  then clkp <= not clkp;
	  else                                 clkp <= clkp;
	  end if;
	 else clkp <= clkp;
	 end if;
	end if;
  end process;	
  end music;