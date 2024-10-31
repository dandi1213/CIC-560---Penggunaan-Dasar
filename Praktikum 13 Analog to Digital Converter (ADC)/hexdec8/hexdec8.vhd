--The circuitry following describes that DATA output of ADC is connected
--to HEXDEC8 module in order to convert it into 10-digit decimal number:

LIBRARY ieee,lpm,altera;
USE altera.maxplus2.all;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY hexdec8 IS
PORT(	sysclk,sta	:in		Std_logic;
		hin			:in		Std_logic_vector(7 downto 0);
		donf		:out	std_logic;
		dout		:out	Std_logic_vector(9 downto 0)
	);
END hexdec8;

ARCHITECTURE hexdec8_arch OF hexdec8 IS
SIGNAL	nrst,stab,sft,chk,done,bcov,dly,a,ldn,ent		:std_logic;
SIGNAL	dsr,tdo			:std_logic_vector(9 downto 0);
SIGNAL	hsr			:std_logic_vector(7 downto 0);
SIGNAL	stas		:std_logic_vector(1 downto 0);
SIGNAL	resultm,resultl,bcnt,num	:std_logic_vector(3 downto 0);
BEGIN
	num<="0011";
	a<='1'; 
	ldn<='1'; ent <='1';
	madd:lpm_add_sub 	generic map(lpm_width=>4,lpm_direction=>"ADD")
						port map(dataa=>num,datab=>dsr(7 downto 4),result=>resultm);
	ladd:lpm_add_sub 	generic map(lpm_width=>4,lpm_direction=>"ADD")
						port map(dataa=>num,datab=>dsr(3 downto 0),result=>resultl);
	bcnt1:a_74163	port map(clk=>sysclk,ldn=>ldn,clrn=>nrst,enp=>sft,ent=>ent,d=>a,c=>a,
								b=>a,a=>a,qd=>bcnt(3),qc=>bcnt(2),qb=>bcnt(1),qa=>bcnt(0));
	nrst<=not(stab and (not stas(1)));

process(sysclk)
	begin
		if sysclk'event and sysclk='1' then
			stab<=sta;
			stas(0)<=stab and (not stas(1));
			stas(1)<=stab;
			dly<=done;
			donf<=done and (not dly);
			dout<=tdo;
			if nrst='0' then
				dsr<="0000000000";
				sft<='0';
				chk<='0';
				done<='0';
			else
				sft<=stas(0);
				for i in 7 downto 1 loop
					hsr(i)<=(stas(0) and hin(i)) or ((not stas(0)) and ( (sft and hsr(i-1)) or ((not sft) and hsr(i)) ));
				end loop;
				hsr(0)<=stas(0) and hin(0);
				
				if sft='1' then
					for j in 9 downto 1 loop
						dsr(j)<=dsr(j-1);
					end loop;
					dsr(0)<=hsr(7);
				elsif chk='1' then
					dsr(9 downto 8)<=dsr(9 downto 8);
					dsr(7 downto 4)<=((resultm(3)& resultm(3)& resultm(3)& resultm(3)) and resultm)
										or ((not (resultm(3)& resultm(3)& resultm(3)& resultm(3))) and dsr(7 downto 4));
					dsr(3 downto 0)<=((resultl(3)& resultl(3)& resultl(3)& resultl(3)) and resultl)
										or ((not (resultl(3)& resultl(3)& resultl(3)& resultl(3))) and dsr(3 downto 0));
				else
					dsr<=dsr;
				end if;
				
				if bcnt="0111" then bcov<='1';
				else bcov<='0';
				end if;
								
				if sft='1' then
					if bcov='1' then
						done<='1';
					else chk<='1';
					end if;				
				elsif chk='1' then 
					sft<='1'; chk<='0';
				elsif done='1' then
					done<='1';chk<='0';
				end if; 
				
				if (done='1' and (not dly='1')) then
					tdo<=dsr;
				else tdo<=tdo;
				end if;
			end if;
		end if;
	end process;
END hexdec8_arch;
