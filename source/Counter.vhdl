library ieee;
use ieee.std_logic_1164.all;

entity Counter is
	generic (
			N : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		FIN        	: out std_logic
	);
end Counter;


architecture Behavioral of Counter is
    signal counter : integer range 0 to N-1 := 0;
begin
    frequency_divider: process (reset, CLK_In) begin
        if (reset = '1') then
            FIN <= '0';
            counter <= 0;
        elsif rising_edge(CLK_In) then
            if (counter = N-1 ) then
                FIN <= '1';
                counter <= 0;
            else
                counter <= counter + 1;
                FIN <= '0';
            end if;
        end if;
    end process;
end Behavioral;