library ieee;
use ieee.std_logic_1164.all;

entity DCC_Reg is
	generic (
		N_BITS : integer := 50
	);
	port(
		-- global definition
		CLK_100MHz	: in std_logic;
		reset 		: in std_logic;

		-- from frame generator
		frame_in	: in std_logic_vector(N_BITS-1 downto 0);

		-- from FSM
		COM_REG	 	: in std_logic;
		inval_reg	: in std_logic;

		-- output to FSM
		bit_carry	: out std_logic;
		dcc_frame_v : out std_logic
	);
end DCC_Reg;

architecture DCC_Reg_arc of DCC_Reg is

signal r_dcc_frame : std_logic_vector(N_BITS-1 downto 0);
signal r_dcc_frame_v : std_logic := '0';

begin
	process (reset, CLK_100MHz)
	begin
		if (reset = '1') then
			r_dcc_frame_v <= '0';
		elsif (rising_edge(CLK_100MHz)) then
			if r_dcc_frame_v = '0' then
				r_dcc_frame <= frame_in;
				r_dcc_frame_v <= '1';

			elsif COM_REG = '1' then
				r_dcc_frame <= r_dcc_frame(N_BITS-2 downto 0) & '0';-- sll 1
			end if;

			-- invalidate from FSM
			if inval_reg = '1' then
				r_dcc_frame_v <= '0';
			end if;
		end if;
	end process ;

	-- output the first bit
	bit_carry <= r_dcc_frame(N_BITS-1);
	dcc_frame_v <= r_dcc_frame_v;

end DCC_Reg_arc;