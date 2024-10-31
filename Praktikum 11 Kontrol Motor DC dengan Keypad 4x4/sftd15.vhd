LIBRARY ieee,altera;
LIBRARY altera;
USE altera.maxplus2.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sftd15 IS
PORT(	pulse,pls4,clr	:in		Std_logic;
		d			:in		std_logic_vector(3 downto 0);
		sdo			:out	std_logic;
		sftd		:out	std_logic_vector(15 downto 0);
		sfto		:out	std_logic_vector(3 downto 0)
	);
END sftd15;

ARCHITECTURE sftd15_arch OF sftd15 IS
signal dataq,datad	:std_logic_vector(15 downto 0);
signal dinq,dind,clrn,prn,clrns,prns :std_logic_vector(3 downto 0);
signal pls4n	:std_logic;
----------------4bit & 16bit²¾¦ì¼È¦s¾¹----------
BEGIN   
	pls4n<=not pls4;
	din:for i in 0 to 3 generate
		prn(i)<= not (d(i) and pulse);
		clrn(i)<=not (not d(i) and pulse );
	dff1:dff port map(d=> dind(i),clk => pls4n,clrn=>clrn(i),prn=>prn(i),q=>dinq(i));
	end generate; 

   sft:for k in 0 to 2 generate
		dind(k+1)<=dinq(k);
	   end generate;
		dind(0)<='0';
  
	data: for j in 0 to 14 generate
         datad(j+1)<=dataq(j);
	      end generate;
	datad(0)<=dinq(3);
	sdo<=dinq(3);

	sftd<=dataq;
	sfto<=dinq;

process(pls4n)
begin
    if clr='1' then dataq <= "0000000000000000";
	elsif pls4n'event and pls4n='1' then
	  dataq<=datad;		
	end if;
end process;

END sftd15_arch;
