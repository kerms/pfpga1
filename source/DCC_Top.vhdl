library ieee;
use ieee.std_logic_1164.all;

entity DCC_Center is
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		buttons 	: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(15 downto 0);
		leds		: out std_logic_vector(15 downto 0);
		dcc_out		: out std_logic
	);
end entity DCC_Center;


architecture behavior of DCC_Center is

component clock_divider
	generic (
			divisor : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		CLK_Out 	: out std_logic
	);
end component;

component tempo is
    generic (
            COUNT : integer
        );
	port (
	    CLK_1MHz    : in std_logic;
	    reset       : in std_logic;
	    COM_TEMPO   : in std_logic;
	    fin          : out std_logic
	);
end component tempo;

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

component DCC_Frame_Generator is
	GENERIC(
		NB_FRAME_BITS : integer := 42
	);
	PORT(
		buttons 	: in std_logic_vector(4 downto 0);
		switch 		: in std_logic_vector(15 downto 0);
		leds 		: out std_logic_vector(15 downto 0);
		CLK_100MHz 	: in std_logic;
		reset 		: in std_logic;
		DCC_Frame 	: out std_logic_vector(NB_FRAME_BITS-1 downto 0)
	);
end component DCC_Frame_Generator;

component dcc_reg is
	generic (
		N_BITS : integer := 50
	);
	port(
		CLK_100MHz	: in std_logic;
		reset 		: in std_logic;
		frame_in	: in std_logic_vector(N_BITS-1 downto 0);
		COM_REG	 	: in std_logic;
		inval_reg	: in std_logic;
		bit_carry	: out std_logic;
		dcc_frame_v : out std_logic
	);
end component dcc_reg;

component fsm is
	generic (
		NB_SHIFT : integer := 42
	);
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		bit_carry	: in std_logic;
		carry_v		: in std_logic;
		COM_REG		: out std_logic;
		inval_reg	: out std_logic;
		FIN_TEMPO	: in std_logic;
		COM_TEMPO	: out std_logic;
		FIN_0		: in std_logic;
		FIN_1		: in std_logic;
		GO_0		: out std_logic;
		GO_1 		: out std_logic
	);
end component fsm;

constant FRAME_NBITS : integer := 42; 

signal CLK_1MHz : std_logic;

-- Frame Gen --> DCC Reg
signal DCC_Frame : std_logic_vector(FRAME_NBITS-1 downto 0);

-- DCC Reg --> FSM
signal reg_carry : std_logic;
signal reg_carry_v : std_logic;
-- FSM 	--> DCC Reg
signal COM_REG : std_logic;
signal reg_inval : std_logic;

-- FSM --> DCC_Bit
signal GO_1 : std_logic;
signal GO_0 : std_logic;

-- DCC Bit --> FSM
signal FIN_1 : std_logic;
signal FIN_0 : std_logic;


-- FSM --> Tempo
signal COM_TEMPO : std_logic;

-- Tempo --> FSM
signal FIN_TEMPO : std_logic;

-- DCC_Bit
signal DCC_0 : std_logic;
signal DCC_1 : std_logic;

begin
    inst_clk_div: Clock_Divider 
    GENERIC MAP (100) -- 1 MHz
    PORT MAP (
        clk_in  => CLK_100MHz	,
        reset   => reset		,
        clk_out => CLK_1MHz
    );

	inst_frame_gen : DCC_Frame_Generator
	generic map (
		FRAME_NBITS
	)
	port map (
		buttons 	=> buttons	,
		switch 		=> switch	,
		leds 		=> leds		,
		CLK_100MHz 	=> CLK_100MHz,
		reset 		=> reset	,
		DCC_Frame 	=> DCC_Frame
	);

	inst_dcc_reg : DCC_Reg
	generic map (
		FRAME_NBITS
	)
	port map(
		CLK_100MHz	=> CLK_100MHz	,
		reset 		=> reset 		,
		frame_in	=> DCC_Frame	,
		COM_REG	 	=> COM_REG	 	,
		inval_reg	=> reg_inval	,
		bit_carry	=> reg_carry	,
		dcc_frame_v => reg_carry_v
	);

	inst_fsm : FSM
	GENERIC MAP (42)
	port map (
		CLK_100MHz  => CLK_100MHz	,
		reset		=> reset 		,
		bit_carry	=> reg_carry	,
		carry_v		=> reg_carry_v	,
		COM_REG		=> COM_REG		,
		inval_reg	=> reg_inval	,
		FIN_TEMPO	=> FIN_TEMPO	,
		COM_TEMPO	=> COM_TEMPO	,
		FIN_0		=> FIN_0		,
		FIN_1		=> FIN_1		,
		GO_0		=> GO_0			,	
		GO_1 		=> GO_1
	);

    inst_tempo: Tempo
    GENERIC MAP (6000+1) -- 6ms
    PORT MAP (
        CLK_1MHz    => CLK_1MHz ,
        reset       => reset    ,
        COM_TEMPO   => COM_TEMPO,
        fin         => FIN_TEMPO
    );

	inst_dcc_bit_0 : DCC_Bit
	GENERIC MAP (100) -- bit 0
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_0 		,
		DCC 		=> DCC_0 		,
		FIN 		=> FIN_0 		
	);

	inst_dcc_bit_1 : DCC_Bit
	GENERIC MAP (58) -- bit 1
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_1 		,
		DCC 		=> DCC_1 		,
		FIN 		=> FIN_1 		
	);

	dcc_out <= DCC_0 or DCC_1;
end architecture behavior;