LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY DCC_Frame_Genetator IS
	GENERIC(
		NB_FRAME_BITS : integer := 50;
	);
	PORT(
		-- User Interface
		buttons : in std_logic_vector(4 downto 0);
		switch : in std_logic_vector(15 downto 0);
		leds : out std_logic_vector(15 downto 0);

		-- Global Interface
		CLK_100MHz : in std_logic;
		reset : in std_logic;

		-- To Reg DCC
		DCC_Frame : out std_logic_vector(NB_FRAME_BITS-1 downto 0)

	);
END DCC_Frame_Genetator;

architecture dataflow of DCC_Frame_Genetator is

component user_interface IS
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		boutons		: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(15 downto 0);
		leds		: out std_logic_vector(15 downto 0);

		-- to reg param
		wdata		: out std_logic_vector(31 downto 0);
		wdata_v 	: out std_logic;
		wdata_addr 	: out std_logic(3 downto 0)
	);
END component;

component frame_builder is
	generic (
		N_BIT : integer := 50
	);
	port (
		CLK_100MHz 	: in std_logic;
		RESET 		: in std_logic;
		dcc_control	: in std_logic_vector(31 downto 0); -- only for 1st v
		dcc_control_v 	: in std_logic_vector(31 downto 0);
		dcc_addr : in std_logic_vector(31 downto 0); -- addr in v1
		dcc_addr_v : in std_logic; -- addr_c in v1,

		dcc_frame_out	: out std_logic_vector(N_BIT-1 downto 0)
	);
end component;

component dcc_framce_reg_param IS
	PORT(
		din		: in std_logic_vector(32 downto 0);
		din_addr: in std_logic(3 downto 0);
		push	: in std_logic;

		command_dcc : in std_logic_vector(31 downto 0);
		command_dcc_v : in std_logic;

		dout	: out std_logic_vector(32 downto 0)
	);
END component;

-- User Interface to Fram Param
signal wdata_v : std_logic;
signal wdata_addr : std_logic_vector(3 downto 0);
signal wdata : std_logic_vector(31 downto 0);

-- Reg Param to Frame builder
signal dcc_control : std_logic_vector(31 downto 0);
signal dcc_control_v : std_logic;
signal dcc_addr : std_logic_vector(31 downto 0); -- for 1st version
signal dcc_addr_v : std_logic; -- for 1st version

-- Frame Builder to Reg Param
signal rdata_v : std_logic;
signal rdata_addr : std_logic(3 downto 0);



begin

	inst_ui : user_interface
	port map (
		CLK_100MHz 	  => CLK_100MHz		,
		reset		  => reset			,
		boutons		  => boutons		,
		switch		  => switch			,
  		leds		  => leds			,
		wdata   	  => wdata 			,
		wdata_v 	  => wdata_v		,
		wdata_addr    => wdata_addr
	);

	inst_reg : frame_reg
	PORT map(
	    CLK_100MHz 		=> CLK_100MHz 	,
        reset        	=> reset        ,
		din				=> wdata		,
		din_addr		=> wdata_addr	,
		push			=> wdata_v		,
		dcc_control_out	=> dcc_control	,
        dout			=> dout	
	);


	inst_builder : 	DCC_Frame_Builder
	generic map(
		N_BIT => 42
	)
	port map(
		CLK_100MHz 		=> CLK_100MHz 		,
		RESET 			=> RESET 			,
		rdata_addr		=> rdata_addr		,
		rdata_v			=> rdata_v			,
		dcc_control 	=> dcc_control 		,
		dcc_control_v 	=> dcc_control_v	,
		dcc_addr 		=> dcc_addr 		,
		dcc_addr_v 		=> dcc_addr_v 		,
		dcc_frame_out 	=> dcc_frame_out
	);

	


end dataflow;
