library ieee;
use ieee.std_logic_1164.all;


entity TB_DCC_Reg is
end TB_DCC_Reg;

architecture TB_DCC_Reg_arc of TB_DCC_Reg is

component DCC_Reg
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
end component;


signal CLK_100MHz	: std_logic;
signal reset 		: std_logic;
signal frame_in	: std_logic_vector(49 downto 0);
signal COM_REG	 	: std_logic;
signal inval_reg	: std_logic;
signal bit_carry	:  std_logic;
signal dcc_frame_v :  std_logic;

constant period : time := 10 ns; -- 100 MHz

begin
	uut : DCC_Reg
	port map(
		CLK_100MHz	=> CLK_100MHz	,
		reset 		=> reset 		,
		frame_in	=> frame_in		,
		COM_REG	 	=> COM_REG	 	,
		inval_reg	=> inval_reg	,
		bit_carry	=> bit_carry	,
		dcc_frame_v => dcc_frame_v 
	);

    -- Clock definition
    clk_process :process
        begin
        CLK_100MHz <= '0';
        wait for period / 2;
        CLK_100MHz <= '1';
        wait for period / 2;
    end process;

	-- Processing
    stimuli : process
	begin
		reset <= '1';
		wait for 100 ns;

		reset <= '0';
		frame_in <= "10101010101010101010101010101010101010101010101010";
		wait for period;

		COM_REG <= '1';
		wait for period;
		wait for 100 ns;

		COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for period;
		COM_REG <= '0';
		wait for 100 ns;

				COM_REG <= '1';
		wait for 100 ns;


	wait;
	end process stimuli;

end TB_DCC_Reg_arc;