LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY DCC_Frame_Generator IS
	GENERIC(
		NB_FRAME_BITS : integer := 42
	);
	PORT(
		-- User Interface
		button	 	: in std_logic_vector(4 downto 0);
		switch 		: in std_logic_vector(14 downto 0);
		led	 		: out std_logic_vector(15 downto 0);

		-- Global Interface
		CLK_100MHz 	: in std_logic;
		reset 		: in std_logic;

		-- To Reg DCC
		DCC_Frame 	: out std_logic_vector(NB_FRAME_BITS-1 downto 0)
	);
END DCC_Frame_Generator;

architecture dataflow of DCC_Frame_Generator is

component user_interface IS
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		button		: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(14 downto 0);
		led			: out std_logic_vector(15 downto 0);

		-- to reg param
		wdata		: out std_logic_vector(31 downto 0);
		wdata_v 	: out std_logic;
		wdata_addr 	: out std_logic_vector(3 downto 0)
	);
END component;

component frame_builder is
	generic (
		N_BIT : integer := 50
	);
	port (
		CLK_100MHz 		: in std_logic;
		RESET 			: in std_logic;
		rdata_addr 		: out std_logic_vector(3 downto 0);
		rdata_v 		: out std_logic;
		dcc_control		: in std_logic_vector(31 downto 0); -- only for 1st v
		dcc_control_v 	: in std_logic;
		din 			: in std_logic_vector(31 downto 0);
		dcc_frame_out	: out std_logic_vector(N_BIT-1 downto 0)
	);
end component;

component frame_reg IS
	PORT(
		CLK_100MHz 		: in std_logic;
		reset       	: in std_logic;
		wdata			: in std_logic_vector(31 downto 0);
		wdata_addr		: in std_logic_vector(3 downto 0);
		wdata_v			: in std_logic;
		rdata_addr		: in std_logic_vector(3 downto 0);
		rdata_v			: in std_logic;
		dcc_control_out	: out std_logic_vector(31 downto 0);
		dout			: out std_logic_vector(31 downto 0)
	);
END component;

-- to User Interface

-- User Interface to Fram Param
signal wdata_v : std_logic;
signal wdata_addr : std_logic_vector(3 downto 0);
signal wdata : std_logic_vector(31 downto 0);

-- Reg Param to Frame builder
signal dcc_control_out : std_logic_vector(31 downto 0);
signal dcc_control_v : std_logic;
signal dout : std_logic_vector(31 downto 0);

-- Frame Builder to Reg Param
signal rdata_v : std_logic;
signal rdata_addr : std_logic_vector(3 downto 0);


begin

	inst_ui : user_interface
	port map (
		CLK_100MHz 	  => CLK_100MHz		,
		reset		  => reset			,
		button		  => button			,
		switch		  => switch			,
  		led			  => led			,
		wdata   	  => wdata 			,
		wdata_v 	  => wdata_v		,
		wdata_addr    => wdata_addr
	);

	inst_reg : frame_reg
	PORT map(
		CLK_100MHz 		=> CLK_100MHz 		,
		reset       	=> reset       		,
		wdata			=> wdata			,
		wdata_addr		=> wdata_addr		,
		wdata_v			=> wdata_v			,
		rdata_addr		=> rdata_addr		,
		rdata_v			=> rdata_v			,
		dcc_control_out	=> dcc_control_out	,
		dout		=> dout
	);

	inst_builder : 	Frame_Builder
	generic map(
		N_BIT => NB_FRAME_BITS
	)
	port map(
		CLK_100MHz 		=> CLK_100MHz 		,
		RESET 			=> RESET 			,
		rdata_addr 		=> rdata_addr 		,
		rdata_v 		=> rdata_v 			,
		dcc_control		=> dcc_control_out	,
		dcc_control_v 	=> dcc_control_v 	,
		din 			=> dout				,
		dcc_frame_out	=> dcc_frame
	);

end dataflow;
