library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	generic (
		NB_SHIFT : integer := 42
	);
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;

		-- DCC reg
		bit_carry	: in std_logic;
		carry_v		: in std_logic;
		COM_REG		: out std_logic;
		inval_reg	: out std_logic;

		-- TEMPO
		FIN_TEMPO	: in std_logic;
		COM_TEMPO	: out std_logic;

		-- DCC Bit
		FIN_0		: in std_logic;
		FIN_1		: in std_logic;
		GO_0		: out std_logic;
		GO_1 		: out std_logic
	);

end FSM;

architecture FSM_arc of FSM is


COMPONENT Counter_Up
generic (
        N : integer
    );
port (
    CLK_In      : in std_logic;
    reset       : in std_logic;
	COM_COUNTER	: in std_logic;
    FIN         : out std_logic
);
END COMPONENT;

TYPE STATE_TYPE IS (FSM_IDLE, FSM_BIT_GO, FSM_BIT_FIN, FSM_INVAL_REG, FSM_TEMPO_FIN);
signal state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal end_counter : std_logic;
signal COM_COUNTER : std_logic;
begin

inst_counter : Counter_Up
    GENERIC MAP (NB_SHIFT)
    PORT MAP (
        clk_in  => CLK_100MHz,
        reset   => reset,
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
			inval_reg <= '0';
			COM_TEMPO <= '0';
			COM_REG <= '0';
			COM_COUNTER <= '0';
			GO_1 <= '0';
			GO_0 <= '0';

		when FSM_BIT_GO =>
			inval_reg <= '0';
			GO_1 <= bit_carry;
			GO_0 <= NOT bit_carry;
			COM_TEMPO <= '0';
			COM_REG <= '1';
			COM_COUNTER <= '1';

		when FSM_BIT_FIN =>
			inval_reg <= '0';
			GO_1 <= '0';
			GO_0 <= '0';
			COM_TEMPO <= '0';
			COM_REG <= '0';
			COM_COUNTER <= '0';

		when FSM_INVAL_REG =>
			GO_1 <= '0';
			GO_0 <= '0';
			COM_TEMPO <= '0';
			COM_REG <= '0';
			COM_COUNTER <= '0';
			inval_reg <= '1';

		when FSM_TEMPO_FIN =>
			GO_1 <= '0';
			GO_0 <= '0';
			COM_TEMPO <= '1';
			COM_REG <= '0';
			COM_COUNTER <= '0';
			inval_reg <= '0';

	end case;
END PROCESS out_put_dec;

next_state_dec : process (state, FIN_0, 
	FIN_1, end_counter, carry_v, FIN_TEMPO) 
begin 
	next_state <= state;
      case (state) is 
		when FSM_IDLE =>
			if carry_v = '1' then
				next_state <= FSM_BIT_GO;
			end if;

		when FSM_BIT_GO =>
			next_state <= FSM_BIT_FIN;

		when FSM_BIT_FIN =>
			-- check if we had sent all DCC bit
			-- else next round of DCC bit
			if (FIN_0 or FIN_1) = '1' then
				if end_counter = '1' then
					next_state <= FSM_INVAL_REG;
				else
					next_state <= FSM_BIT_GO;
				end if;
			end if;

		when FSM_INVAL_REG =>
			next_state <= FSM_TEMPO_FIN;

		when FSM_TEMPO_FIN =>
			if FIN_TEMPO = '1' then
				next_state <= FSM_IDLE;
			end if;
      end case; 
end process; 

end FSM_arc;