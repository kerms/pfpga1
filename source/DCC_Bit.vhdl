library ieee;
use ieee.std_logic_1164.all;

entity DCC_Bit is
	generic (
		PERIOD : integer := 58
	);
	port (
		CLK_100MHz 	: in std_logic;
		CLK_1MHz 	: in std_logic;
		reset		: in std_logic;
		Go 		: in std_logic;
		DCC 		: out std_logic;
		FIN 		: out std_logic
	);
end DCC_Bit;

architecture DCC_Bit_arc of DCC_Bit is

COMPONENT Counter
generic (
        N : integer
    );
port (
    CLK_In      : in std_logic;
    reset       : in std_logic;
    COM_COUNTER : in std_logic;
    FIN         : out std_logic
);
END COMPONENT;

TYPE STATE_TYPE IS (FSM_IDLE, FSM_LO, FSM_HI, FSM_FIN);
signal state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal reset_counter : std_logic;
signal end_counter : std_logic;
signal COM_COUNTER : std_logic;
begin

inst_counter : Counter 
    GENERIC MAP (PERIOD/2-1)
    PORT MAP (
        clk_in  => CLK_1MHz,
        reset   => reset_counter,
        COM_COUNTER => COM_COUNTER,
        FIN => end_counter
    );



clocked : process (reset, CLK_100MHz)
begin
  if (reset = '1') then
    state <= FSM_IDLE;
  elsif (rising_edge(CLK_100MHz)) then
  	state <= next_state;
  end if;
end process clocked;
	
out_put_dec : PROCESS (state)
BEGIN
	case(state) is
		when FSM_IDLE => 
			COM_COUNTER <= Go;
			DCC <= '0';
			FIN <= '0';

		when FSM_LO =>
			DCC <= '0';
			FIN <= '0';
			COM_COUNTER <= end_counter;

		when FSM_HI =>
			DCC <= '1';
			FIN <= '0';
			COM_COUNTER <= end_counter;

		when FSM_FIN => 
			FIN <= '1';
			DCC <= '0';
			COM_COUNTER <= '0';

	end case;
END PROCESS out_put_dec;

next_state_dec : process (state, Go, end_counter) 
begin 
    case(state) is
		when FSM_IDLE => 
			if (Go = '1') then
				next_state <= FSM_LO;
			end if;

		when FSM_LO =>
			if end_counter = '1' then
				next_state <= FSM_HI;
			end if;
			
		when FSM_HI =>
			if end_counter = '1' then
				next_state <= FSM_FIN;
			end if;

		when FSM_FIN => 
			if Go = '1' then
				next_state <= FSM_LO;
			else 
				next_state <= FSM_IDLE;
			end if;

	end case;
end process next_state_dec; 

end DCC_Bit_arc;