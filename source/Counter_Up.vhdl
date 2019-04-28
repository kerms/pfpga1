library ieee;
use ieee.std_logic_1164.all;

entity Counter_Up is
    generic (
            N : integer := 100
        );
    port (
        CLK_In      : in std_logic;
        reset       : in std_logic;
        COM_COUNTER : in std_logic;
        FIN         : out std_logic
    );
end Counter_Up;


architecture Behavioral of Counter_Up is
    TYPE STATE_TYPE IS (FSM_IDLE, FSM_COUNT, FSM_FIN);
    signal counter : integer range 0 to N-1 := 0;
    signal state, next_state : STATE_TYPE;

begin
    clocked: process (reset, CLK_In, COM_COUNTER) begin
        if (reset = '1') then
            counter <= 0;

        elsif rising_edge(CLK_In) then

            if counter = N-1 then
                counter <= 0;
            elsif COM_COUNTER = '1' then
                counter <= counter + 1;
            end if;

        end if;
    end process;

    FIN <= '1' when counter = N-1 else '0';
end Behavioral;