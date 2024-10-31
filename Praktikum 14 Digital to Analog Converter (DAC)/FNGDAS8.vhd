LIBRARY ieee,lpm;
USE lpm.lpm_components.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY fngdas8 IS
PORT(	clock,setab,sweep	:in		std_logic;
        frqm				:in 	std_logic_vector(1 downto 0);--wave form setting
		freq				:in 	std_logic_vector(15 downto 0);--frq setting
		a					:in 	std_logic_vector(2 downto 0);--chip selector
		fout,wr,selab,cs	:out	std_logic;
		pdo					:out 	std_logic_vector(7 downto 0)--dac db0-db7	
);
END fngdas8;

ARCHITECTURE fngdas8_arch OF fngdas8 IS
signal sum ,freqs	:std_logic_vector(15 downto 0);
signal cnt			:std_logic_vector(27 downto 0);
signal prom_q		:std_logic_vector(7 downto 0);
signal address      :std_logic_vector(7 downto 0);
signal co,strb,count,cout :std_logic;

BEGIN
prom :altsyncram
    GENERIC MAP ( width_a => 8,	widthad_a => 8,
		          numwords_a => 256,operation_mode => "ROM",outdata_reg_a => "UNREGISTERED",
		          address_aclr_a => "NONE",	outdata_aclr_a => "NONE", width_byteena_a => 1,
		          init_file => "pfgn8.mif",lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		          lpm_type => "altsyncram" )
		
	PORT MAP (clock0 => clock,address_a => address, q_a => prom_q );
	
		
 wr <= not strb ;							 --wr(sample rate setting)
 cs <= not (a(0) and not a(1) and not a(2)) ;--chip addr=01h 
 selab <= setab; 
 
 process (clock,cnt,strb) 
 begin 
   if (clock'event and clock='1')  then 
       cnt <= cnt +1;      
   end if;
 end process;

 process (sweep,cnt) 
 begin 
 if sweep='1'  then 
   freqs <= ("0000" & cnt(17 downto 8) & "11") ; --27/18
 else    
   freqs <= freq;						 --scanning frequency setting,	sweep='0' hardware setting
 end if; 								 --             				sweep='1' counter setting
 end process;

 process (cnt,strb) 
 begin 


 if (cnt(6)'event and cnt(6)='1')  then 
  sum <= sum + freqs;
  co <=sum(15);
 end if; 
 end process;
 

  cout <= (co xor sum(15)) and not cnt(6);

  strb <= cnt(5) and cnt(6);          		
  address <=(frqm & sum(15 downto 10));		--frqm(00,01,10,11)	select waveform by dip switch 
  pdo <= prom_q;  
  fout <=cout; 
 END fngdas8_arch; 
