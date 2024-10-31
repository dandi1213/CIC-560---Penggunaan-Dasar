library ieee;
use ieee.std_logic_1164.all;

--Deklarasi Entity
entity gerbang_logika is
	port (In1_AND, In2_AND : in std_logic;
		  Out_AND : out std_logic);
end entity gerbang_logika; 
		  
--Deklarasi Arsitektur
architecture data_flow of gerbang_logika is
begin
	Out_AND <= In1_AND AND In2_AND;
end data_flow; 