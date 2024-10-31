--********************************
--   Mechanical Switch Debouncer   
--********************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY debounceg IS
	PORT(	clk,key_pressed :IN STD_LOGIC;
			pulse:OUT STD_LOGIC);
END debounceg;

ARCHITECTURE debounceg_arch  OF debounceg IS
SIGNAL count : STD_LOGIC_VECTOR(15 downto 0);
BEGIN
process (clk)
begin 
 if clk'event and clk='1' then
      if key_pressed = '1' then 
            count <="1111111111111111";
      elsif count="0000000000000000" then        
            count<= count ;
      else  count <= count -1 ;
      end if;
 end if;
 end process;
 process(count)
 begin
  if count="0000000000000001"
     then pulse <='1';
  else    pulse <='0';
  end if;
 end process;
END debounceg_arch;
