LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwm16 IS
PORT(	clock,clr,en,prs,dir		:in		Std_logic;
		s				:in		std_logic_vector(15 downto 0);
		sn,pwm,fr		:out	std_logic;
		d				:out	std_logic_vector(15 downto 0)
	);
END pwm16;

ARCHITECTURE pwm16_arch OF pwm16 IS
SIGNAL	cnt		:std_logic_vector(15 downto 0);
SIGNAL	prd		:std_logic_vector(15 downto 0);
SIGNAL	sgn		:std_logic;

BEGIN
	process(prs)
		begin
		if prs'event and prs='1' then
			 prd <=s;
		else prd <=prd;
		end if;
	end process;	

	process(clock,clr)
	begin
	if clock'event and clock='1' then
		if clr='0' then  cnt<=X"0000";sgn <='0';
		else
			if en='1' then
				if sgn='1' then cnt<=cnt+1;
				else cnt<=cnt-1;
				end if;
			else cnt<=cnt;
		  	end if;	
		
		    if (cnt=X"fffe" and sgn='1') or (cnt=X"0001" and sgn='0')
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
	   if en='1' and prd >= cnt then pwm<='1';
	   else pwm<='0';
	   end if;
	 end if;
	end process;
	
	d <= cnt;
	sn <= sgn;
    fr <=dir; 
END pwm16_arch;
