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
    TYPE STATE_TYPE IS (FSM_COUNT, FSM_FIN);
    signal counter : integer range 0 to N-1 := 0;
    signal state, next_state : STATE_TYPE;

begin
    clocked: process (reset, CLK_In) begin
        if (reset = '1') then
            state <= FSM_COUNT;
            counter <= 0;

        elsif rising_edge(CLK_In) then
            state <= next_state;
            if (counter = N-1 ) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    FSM_dec : process (state) begin

        case(state) is
            when FSM_COUNT =>
                FIN <= '0';

            WHEN FSM_FIN => 
                FIN <= '1';

        end case;
    end process;

    next_state_dec : process(state, counter) begin
        case(state) is
            when FSM_COUNT =>
                if (counter = N-1 ) then
                    next_state <= FSM_FIN;
                end if;

            WHEN FSM_FIN => 
                next_state <= FSM_COUNT;

        end case;
    end process;

end Behavioral;