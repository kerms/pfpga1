library ieee;
use ieee.std_logic_1164.all;


entity Simple_TB_FSM is
end Simple_TB_FSM;

architecture Simple_TB_FSM_arc of Simple_TB_FSM is

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

component FSM is
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
end component FSM;

component DCC_Bit
	generic (
		PERIOD : integer := 58
	);
	port (
		CLK_100MHz 	: in std_logic;
		CLK_1MHz 	: in std_logic;
		reset		: in std_logic;
		Go 			: in std_logic;
		DCC 		: out std_logic;
		FIN 		: out std_logic
	);
end component;

component Clock_Divider
	generic (
			divisor : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		CLK_Out 	: out std_logic
	);
end component;



signal CLK_100MHz	: std_logic;
signal CLK_1MHz 	: std_logic;
signal reset 		: std_logic;

-- DCC REG
signal frame_in		: std_logic_vector(49 downto 0);
signal COM_REG	 	: std_logic;
signal inval_reg	: std_logic;
signal bit_carry	:  std_logic;
signal dcc_frame_v 	:  std_logic;

-- FSM
signal FIN_TEMPO	: std_logic;
signal COM_TEMPO	: std_logic;
signal FIN_0		: std_logic;
signal FIN_1		: std_logic;
signal GO_0			: std_logic;
signal GO_1 		: std_logic;
signal DCC_0 		: std_logic;
signal DCC_1 		: std_logic;

constant period : time := 10 ns; -- 100 MHz

begin
	inst_dcc_reg : DCC_Reg
	port map(
		CLK_100MHz	=> CLK_100MHz	,
		reset 		=> reset 		,
		frame_in	=> frame_in		,
		COM_REG	 	=> COM_REG	 	,
		inval_reg	=> inval_reg	,
		bit_carry	=> bit_carry	,
		dcc_frame_v => dcc_frame_v 
	);

	clk_inst: Clock_Divider 
	GENERIC MAP (100)
	PORT MAP (
	    clk_in  => CLK_100MHz,
	    reset   => reset,
	    clk_out => CLK_1MHz
	);

	inst_dcc_bit0 : DCC_Bit
	GENERIC MAP (100) -- bit 0
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_0 		,
		DCC 		=> DCC_0 		,
		FIN 		=> FIN_0 		
	);

	inst_dcc_bit1 : DCC_Bit
	GENERIC MAP (58) -- bit 1
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_1 		,
		DCC 		=> DCC_1 		,
		FIN 		=> FIN_1 		
	);

	uut : FSM
	port map (
		CLK_100MHz  => CLK_100MHz	,
		reset		=> reset 		,
		bit_carry	=> bit_carry	,
		carry_v		=> dcc_frame_v	,
		COM_REG		=> COM_REG		,
		inval_reg	=> inval_reg	,
		FIN_TEMPO	=> FIN_TEMPO	,
		COM_TEMPO	=> COM_TEMPO	,
		FIN_0		=> FIN_0		,
		FIN_1		=> FIN_1		,
		GO_0		=> GO_0			,	
		GO_1 		=> GO_1 
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
		FIN_TEMPO <= '0';
		wait for 100 ns;

		reset <= '0';
		FIN_TEMPO <= '0';
		frame_in <= "10101010101010101010101010101010101010101010101010";
		wait for period;

		wait for 19990 ns;


	wait;
	end process stimuli;

end Simple_TB_FSM_arc;