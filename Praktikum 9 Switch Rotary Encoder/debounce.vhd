LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY DEBOUNCE IS
	PORT ( CLK,SAMPLE,BTNA 	: in  STD_LOGIC;
           DEBN             : OUT STD_LOGIC);
END DEBOUNCE;

ARCHITECTURE DEBOUNCE_ARCH OF DEBOUNCE IS
       SIGNAL D1,D0,FLT  :STD_LOGIC;

   BEGIN
	PROCESS(CLK)
     BEGIN
      IF CLK' EVENT AND CLK ='1' THEN
	     IF SAMPLE ='1' THEN
            D1<= D0 ; D0<= BTNA;
            FLT <=(( D0 AND D1) OR FLT) AND (D0 OR D1);
         END IF;
       END IF;
     END PROCESS;
     DEBN <= FLT;
END DEBOUNCE_ARCH;

