library ieee;
use ieee.std_logic_1164.all;

entity Clock_Divider is
	generic (
			divisor : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		CLK_Out 	: out std_logic
	);
end Clock_Divider;


architecture Behavioral of Clock_Divider is
    signal temporal: STD_LOGIC;
    signal counter : integer range 0 to divisor/2-1 := 0;
begin
    frequency_divider: process (reset, CLK_In) begin
        if (reset = '1') then
            temporal <= '0';
            counter <= 0;
        elsif rising_edge(CLK_In) then
            if (counter = divisor/2-1 ) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    CLK_Out <= temporal;
end Behavioral;