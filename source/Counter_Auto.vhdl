library ieee;
use ieee.std_logic_1164.all;

entity Counter_Auto is
	generic (
			N : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		FIN        	: out std_logic
	);
end Counter_Auto;


architecture Behavioral of Counter_Auto is
    signal counter : integer range 0 to N-1 := 0;

begin
    clocked: process (reset, CLK_In) begin
        if (reset = '1') then
            counter <= 0;

        elsif rising_edge(CLK_In) then
            if (counter = N-1 ) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    FIN <= '1' when counter = N-1 else '0';
end Behavioral;