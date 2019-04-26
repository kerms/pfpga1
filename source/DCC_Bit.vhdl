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
    FIN         : out std_logic
);
END COMPONENT;

TYPE STATE_TYPE IS (IDLE, LO, HI);
signal state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal reset_counter : std_logic;
signal end_counter : std_logic;
begin

inst_counter : Counter 
    GENERIC MAP (HALF_PERIOD/2-1)
    PORT MAP (
        clk_in  => CLK_1MHz,
        reset   => reset_counter,
        FIN => end_counter
    );



clocked : process (reset, CLK_100MHz)
begin
  if (reset = '1') then
    state <= IDLE;
  elsif (rising_edge(CLK_100MHz)) then
  	state <= next_state;
  end if;
end process clocked;
	
FSM : PROCESS (state, Go, CLK_100MHz)
BEGIN
	if (rising_edge(CLK_100MHz)) then
	case(state) is
		when IDLE => 
			if (Go = '1') then
				next_state <= LO;
			end if;
			reset_counter <= Go;
			DCC <= '0';
			FIN <= '0';
		when LO =>
			if end_counter = '1' then
				next_state <= HI;
				reset_counter <= '1';
			else 
				reset_counter <= '0';
			end if;
			DCC <= '0';
			FIN <= '0';
		when HI =>
			if end_counter = '1' then
				if Go = '0' then
					next_state <= IDLE;
				else 
					next_state <= LO;
					reset_counter <= '1';
				end if;
				FIN <= end_counter;
			else 
				reset_counter <= '0';
			end if;
			DCC <= '1';
	end case;
  	end if;
END PROCESS FSM;

end DCC_Bit_arc;