LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwm10 IS
PORT(	clock,clr,en		:in		Std_logic;
		s				:in		std_logic_vector(9 downto 0);
		pwm		:out	std_logic
		
	);
END pwm10;

ARCHITECTURE pwm10_arch OF pwm10 IS
SIGNAL	cnt		:std_logic_vector(9 downto 0);
SIGNAL	sgn		:std_logic;

BEGIN

	process(clock,clr)
	begin
	if clock'event and clock='1' then
		if clr='0' then  cnt<="0000000000";sgn <='0';
		else
			if en='1' then
				if sgn='1' then cnt<=cnt+1;
				else cnt<=cnt-1;
				end if;
			else cnt<=cnt;
		  	end if;	
		
		    if (cnt=X"3fe" and sgn='1') or (cnt=X"001" and sgn='0')
	                  then sgn<=not sgn;
	        else sgn<=sgn;
	        end if;				
		 end if;		
	 end if;
	end process;
			
	process(s,cnt,clr)
	begin
	 if clr='0' then pwm<='0';
	 else	
	   if s >= cnt then pwm<='1';
	   else pwm<='0';
	   end if;
	 end if;
	end process;	
	  
END pwm10_arch;
