LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY lcdmpddr IS
PORT(	sclk,sclkm,start,clear,mode		:in		std_logic;
		datai,prom_data					:in 	std_logic_vector(8 downto 0);
		sel								:in 	std_logic_vector(1 downto 0);
		en,r_w,d_i,tmdt					:out	std_logic;
		promadr							:out 	std_logic_vector(7 downto 0);
		db								:out	std_logic_vector(7 downto 0)
);
END lcdmpddr;

ARCHITECTURE lcdmpddr_arch OF lcdmpddr IS
signal stks			:std_logic_vector(3 downto 0);
signal ssk,d,c		:std_logic_vector(1 downto 0);
signal cntd			:std_logic_vector(4 downto 0);
signal cntm			:std_logic_vector(8 downto 0);
signal cntp			:std_logic_vector(2 downto 0);
signal prom_q		:std_logic_vector(8 downto 0);
signal dbnc,b,lcden		:std_logic;

signal scount		:std_logic_vector(26 downto 0);
signal clk,clkm		:std_logic;

BEGIN
    

  	process(clk,sclk,scount)
	begin
	if clear='0' then
		if (sclk'event and sclk='1')  then	scount <= scount +1 ;
		else scount <= scount;
	    end if;
	else scount<="000000000000000000000000000";
	end if;
	end process;
	
	clk <= scount(15); 										--32768/40M=0.8192ms
	 
	process(sel,scount,sclkm,clkm)
    begin
    case  sel is when "00" => clkm <= scount(18);			--6.5536ms (40M)
     			 when "01" => clkm <= scount(20);			--26.2144ms
    			 when "10" => clkm <= scount(21);
				 when "11" => clkm <= sclkm;
    end case;
    end process;



	process (cntm)      --PROM address output--
	 begin
	  IF	(cntm  >= "001000101" and cntm < "101000110" )	then 
			promadr <= "01000101";lcden <= '0';			--show page 1 hold on time. ;"001000101" to "101000110"
	  elsif	(cntm >= "110001100" )	then 
			promadr <= "10001100";lcden <= '0';			--show page 2 hold on time. ;"110001100" to "000000000"
	  else	promadr <= cntm(7 DOWNTO 0) ;
			lcden <= '1';    							--cntm count prom address. lcd enable
	  end if;
	end process;

    prom_q  <= prom_data; 										--prom data in
	
process(clk,clkm)
begin
	if (clkm'event and clkm='1')  then 							--memory address coutner --
		if clear='1' or mode='1' then cntm<="000000000";
		elsif   (mode = '0' and cntp="101") then 
			if cntm ="111111111" then cntm<="000000000";
			else cntm<=cntm+1;
			end if;
		else cntm<=cntm;
		end if;
	end if;
	
	if clk'event and clk='1' then 								--LCM start and display --0.8192ms
			if clear='1' then
								stks<="0000";
								cntp<="000";
								ssk<="00";
								d<="00";
								cntd<="00000";
			else
				cntd(2 downto 0)<=cntd(2 downto 0)+1;
				cntd(3)<=cntd(2);
				cntd(4)<=cntd(3);
				
				tmdt<=cntd(2) and (not cntd(4));				--delay until cntd4 show on led
																
																
				d(0)<= ((start and mode) or (clkm and (not mode)) or clear );				
				d(1)<= d(0);
				
				dbnc<=((d(0) and d(1)) or dbnc) and (d(0) or d(1));	--
								
				r_w<= not (stks(0) or stks(1) or stks(2)); 		--R/W control
				en<=stks(1) and lcden  ;				   		--LCDEN
				
				case ssk is
					when "00" =>
						if dbnc='1' then ssk<="01";
						else ssk<="00";
						end if;
					when "01" => ssk<="10";
					
					when "10" =>
						if dbnc='0' then ssk<="00";
						else ssk<="10";
						end if;
					when "11" =>
						ssk<="00";
					when others=>
				end case;
				
				case stks is
					when "0000" =>
						if ssk(0)='1' then stks<="0001";
						else stks<="0000";
						end if;
					when "0001" => stks<="0010";
					
					when "0010" => stks<="0100";
					when "0100" => stks<="1000";
					when "1000" =>
						if (cntp="000" or cntp="001" or cntp="010" or cntp="011") then
							stks<="0001";
						elsif cntp="101" then stks<="0000";
						else stks<="1000";
						end if;
					when others=> stks<="0000";
				end case;
			end if;
		
			if (stks(3)='1' and cntp/="101") then cntp<=cntp+1;
			else cntp<=cntp;
			end if;	
			
			if (cntp="101") and ((mode='1' and datai(8)='0') or (mode='0' and prom_q(8)='0')) then 
				d_i<=(stks(0) or stks(1) or stks(2));      	--R/S control
			else  d_i<=not (stks(0) or stks(1) or stks(2));
			end if;
			
			case cntp is
				when "000" => db<="00111000";				--lcm start
				when "001" => db<="00001110";
				when "010" => db<="00000110";
				when "011" => db<="00000001";
				when "100" => db<="10000000";				
				when "101" => 								--lcm display 
							if mode='0' then db<=prom_q(7 DOWNTO 0);							
							else db<=datai(7 DOWNTO 0);
							end if;							
			   	when others=> 
			 end case;
	end if;
 end process;
	
END lcdmpddr_arch; 
