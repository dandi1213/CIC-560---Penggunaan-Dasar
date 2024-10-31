LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FourDigitDisplay IS
    PORT(
        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(3 downto 0)
    );
END FourDigitDisplay;

ARCHITECTURE Behavioral OF FourDigitDisplay IS
    COMPONENT SEGMENT7
        PORT(
            i   : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    END COMPONENT;

    SIGNAL digits : std_logic_vector(15 downto 0) := "0001001000110100"; -- 1234 in BCD
    SIGNAL current_digit : std_logic_vector(3 downto 0);
    SIGNAL digit_counter : integer := 0;
    SIGNAL clk_div : integer := 0;

BEGIN
    process
    begin
        while True loop
            wait for 1 ms; -- Adjust this value to get a reasonable refresh rate
            clk_div <= clk_div + 1;
            if clk_div = 1000 then
                clk_div <= 0;
                digit_counter <= (digit_counter + 1) mod 4;
                case digit_counter is
                    when 0 =>
                        an <= "1110";
                        current_digit <= digits(3 downto 0);
                    when 1 =>
                        an <= "1101";
                        current_digit <= digits(7 downto 4);
                    when 2 =>
                        an <= "1011";
                        current_digit <= digits(11 downto 8);
                    when 3 =>
                        an <= "0111";
                        current_digit <= digits(15 downto 12);
                    when others =>
                        an <= "1111";
                        current_digit <= "0000";
                end case;
            end if;
        end loop;
    end process;

    segment7_inst : SEGMENT7
        PORT MAP (
            i   => current_digit,
            seg => seg
        );

END Behavioral;
