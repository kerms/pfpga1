library ieee;
use ieee.std_logic_1164.all;

entity Counter is
	generic (
			N : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
        COM_COUNTER : in std_logic;
		FIN        	: out std_logic
	);
end Counter;


architecture Behavioral of Counter is
    TYPE STATE_TYPE IS (FSM_IDLE, FSM_COUNT, FSM_FIN);
    signal counter : integer range 0 to N-1 := 0;
    signal state, next_state : STATE_TYPE;

begin
    clocked: process (reset, CLK_In) begin
        if (reset = '1') then
            state <= FSM_IDLE;

        elsif rising_edge(CLK_In) then
            state <= next_state;
            if counter = N-1 or COM_COUNTER = '1' then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;

        end if;
    end process;

    FSM_dec : process (state) begin

        case(state) is
            when FSM_IDLE => 
                FIN <= '0';

            when FSM_COUNT =>
                FIN <= '0';

            WHEN FSM_FIN => 
                FIN <= '1';

        end case;
    end process;

    next_state_dec : process(state, counter, COM_COUNTER) begin
        next_state <= state; -- default value, state not changing
        case(state) is
            when FSM_IDLE => 
                if COM_COUNTER = '1' then
                    next_state <= FSM_COUNT;
                end if;

            when FSM_COUNT =>
                if (counter = N-1 ) then
                    next_state <= FSM_FIN;
                end if;

            WHEN FSM_FIN => 
                next_state <= FSM_IDLE;
                if COM_COUNTER = '1' then
                    next_state <= FSM_COUNT;
                end if;

        end case;
    end process;

end Behavioral;