LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY stpct4 IS
PORT(	clk,ssclk,clr,ENP,PRS	:in		Std_logic;
        ENO  			:out	std_logic;
		ps				:in		std_logic_vector(15 downto 0);		
		sn				:out	std_logic_vector(3 downto 0);
		mq				:out	std_logic_vector(3 downto 0);
		sd				:out	std_logic_vector(6 downto 0)
	);
END stpct4;

ARCHITECTURE stpct4_arch OF stpct4 IS
signal	cntn_en,cntn_ud	:std_logic;
SIGNAL	scn				:std_logic_vector(8 downto 0);
SIGNAL	dec1_x			:std_logic_vector(3 downto 0);
SIGNAL	PRSD			:std_logic_vector(15 downto 0);
SIGNAL	cntn_op			:std_logic_vector(15 downto 0);
component segd7
port(	x				:in		std_logic_vector(3 downto 0);
		s				:out	std_logic_vector(6 downto 0)
);
end component;
component cnt16
PORT(	clk,clr,en,ud	:in		Std_logic;
		op				:out	std_logic_vector(15 downto 0)
	);
end component;

BEGIN
	cntn:cnt16	port map(clk,clr,cntn_en,cntn_ud,cntn_op);
	dec1:segd7	port map(dec1_x,sd);
	ENO <= cntn_en;

		
	PROCESS (PRS,clk)
	BEGIN
	 if clr='1' then PRSD<="0000000000000000";
	 ELSIF PRS'event and PRS='1' then PRSD <= PS;
	 ELSE PRSD <=PRSD;
	 END IF;
	END PROCESS;
	 
	process(ssclk,scn,cntn_op,ps,clk)
	begin
	if clr='1' then scn<="000000000";
		elsif ssclk'event and ssclk='1' then scn<=scn+1;
		end if;
	end process;
		
	process(scn,cntn_op,ps,PRSD)
	BEGIN			
		case scn(8 downto 7) is
			when "00" =>
				dec1_x<=cntn_op(3 downto 0);
				sn<="0001";
			when "01" =>
				dec1_x<=cntn_op(7 downto 4);
				sn<="0010";
			when "10" =>
				dec1_x<=cntn_op(11 downto 8);
				sn<="0100";
			when "11" =>
				dec1_x<=cntn_op(15 downto 12);
				sn<="1000";
			when others =>
				dec1_x<="0000";
				sn<="0000";
		end case;
		
		case cntn_op(1 downto 0) is
			when "00" => mq<="0101";
			when "01" => mq<="0110";
			when "10" => mq<="1010";
			when "11" => mq<="1001";
			when others=>mq<="0000";
		end case;
	
	
		if PRSD=cntn_op then cntn_en<='0';
		else cntn_en<= ENP;
		end if;
		
		if PRSD>cntn_op then cntn_ud<='1';
		else cntn_ud<='0';
		end if;	
    end process;

END stpct4_arch;
