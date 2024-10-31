LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adc8i IS
PORT(	clk,int     	:in		Std_logic;
		dati			:in		Std_logic_vector(7 downto 0);
		a				:in		Std_logic_vector(2 downto 0);
		sel				:in		Std_logic_vector(1 downto 0);		
		wr,rd,cs,conv_done,scandp		:out	Std_logic;		
		dato			:out	Std_logic_vector(7 downto 0)
	);
END adc8i;

ARCHITECTURE adc8i_arch OF adc8i IS
SIGNAL	data		:std_logic_vector(7 downto 0);
SIGNAL	stks,stkp	:std_logic_vector(1 downto 0);
SIGNAL	sftd,sftp	:std_logic_vector(2 downto 0);
SIGNAL	cnt			:std_logic_vector(8 downto 0);
SIGNAL	hexd		:std_logic_vector(3 downto 0);
SIGNAL  scount		:std_logic_vector(21 downto 0);
signal  sampclk     :std_logic;

BEGIN 
process(clk)	--scount(0)=10m (4)=1m (8)=100k (12)=10k (16)=1k  (20)=100hz
	begin		--scont decimal counter --
		if clk'event and clk='1' then		  
		  if scount(3 downto 0)="1001" then scount(3 downto 0)<="0000";
		  else scount(3 downto 0)  <= scount(3 downto 0)+1;
		  end if;
		  
		  if scount(3 downto 0)="1001" then 
		     if scount(7 downto 4)="1001" then scount(7 downto 4)<="0000";
		     else scount(7 downto 4)  <= scount(7 downto 4)+1;
		     end if;
		  else scount(7 downto 4)  <= scount(7 downto 4);
		  end if;
				 
		  if (scount(3 downto 0)="1001"  and scount(7 downto 4)="1001") then 
		     if scount(11 downto 8)="1001" then scount(11 downto 8)<="0000";
		     else scount(11 downto 8)  <= scount(11 downto 8)+1;
		     end if;
		  else scount(11 downto 8)  <= scount(11 downto 8);
		  end if;		
		  
          if (scount(3 downto 0)="1001"  and scount(7 downto 4)="1001") 
              and scount(11 downto 8)="1001" 
             then 
		     if scount(15 downto 12)="1001" then scount(15 downto 12)<="0000";
		     else scount(15 downto 12)  <= scount(15 downto 12)+1;
		     end if;
		  else scount(15 downto 12)  <= scount(15 downto 12);
		  end if;		
		  
          if (scount(3 downto 0)="1001"  and scount(7 downto 4)="1001" 
              and scount(11 downto 8)="1001" and scount(15 downto 12)="1001") then 
		     if scount(19 downto 16)="1001" then scount(19 downto 16)<="0000";
		     else scount(19 downto 16)  <= scount(19 downto 16)+1;
		     end if;
		  else scount(19 downto 16)  <= scount(19 downto 16);
		  end if;
		 
		  if (scount(3 downto 0)="1001" and scount(7 downto 4)="1001" and scount(11 downto 8)="1001"
		    and scount(15 downto 12)="1001" and scount(19 downto 16)="1001") 		 
		  then scount(21 downto 20)<= scount(21 downto 20)+1;
		  else  scount(21 downto 20)<=scount(21 downto 20);
		  end if;
end if;		
end process;
  	
 process(sel,scount)		--sample rate selector--
  begin
  case sel is when b"00" => sampclk <= scount(13);--5k
      		  when b"01" => sampclk <= scount(14);--2k
			  when b"10" => sampclk <= scount(16);--1k
			  when b"11" => sampclk <= scount(20);--100hz			  
  end case;
 end process;

	process(scount(7))
	begin		
		if scount(7)'event and scount(7)='1' then --pulser width 10m/80=125k
			case stkp is
				when "00"	=>
					if int='0' then stkp<="01";
					else stkp<="00";
					end if;
				when "01"	=> stkp<="10";
				when "10"	=> 
					if int='1' then stkp<="00";
					else stkp<="10";
					end if;
				when "11"	=> stkp<="00";
				when others=>
			end case;
			
		    sftp(0) <=sampclk;
		    sftp(1) <=sftp(0);
		    sftp(2) <=sftp(1);--
		
			sftd(0) <=stkp(0);
			sftd(1) <=sftd(0);
			sftd(2) <=sftd(1);--
			rd<=not (sftd(0) or sftd(1) or sftd(2));			--int=0 rd=0 a pluse--   int=1 rd=1--		
			if sftd(1)='1' then data<=dati;
			else data<=data;
			end if;		
		end if;
	end process;	
	
	    scandp <=scount(10);									--Scan displaying rate --
		wr <= not (sftp(0) and not sftp(2));					--Sample and convert
		cs<=a(0)or a(1)or a(2);									--
		dato<= data;											--output captured data--
		conv_done <= sftd(2);
END adc8i_arch;
