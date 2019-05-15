library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

entity Simple_TB_Frame_Builder is
end Simple_TB_Frame_Builder;

architecture Simple_TB_Frame_Builder_arc of Simple_TB_Frame_Builder is

component frame_builder is
	generic (
		N_BIT : integer := 50
	);
	port (
		CLK_100MHz 	: in std_logic;
		RESET 		: in std_logic;
		rdata_addr 	: out std_logic_vector(3 downto 0);
		rdata_v 	: out std_logic;
		dcc_control	: in std_logic_vector(31 downto 0); -- only for 1st v
		dcc_control_v 	: in std_logic;
		dcc_addr : in std_logic_vector(31 downto 0); -- addr in v1
		dcc_addr_v : in std_logic; -- addr_c in v1,
		dcc_frame_out	: out std_logic_vector(N_BIT-1 downto 0)
	);
end component;


constant N_BIT : integer := 42; 

signal rdata_addr : std_logic_vector(3 downto 0);
signal rdata_v : std_logic;
signal dcc_control : std_logic_vector(31 downto 0);
signal dcc_control_v : std_logic;
signal dcc_addr : std_logic_vector(31 downto 0);
signal dcc_addr_v : std_logic;
signal dcc_frame_out : std_logic_vector(N_BIT-1 downto 0);

-- global interface
signal CLK_100MHz	: std_logic:='0';
signal reset 		: std_logic;

-- TB
constant period : time := 10 ns; -- 100 MHz
signal finished : std_logic := '0';

begin
	uut : frame_builder
	generic map(
		42
	)
	port map (
		CLK_100MHz		=> CLK_100MHz 	,
		RESET			=> RESET 		,
		rdata_addr		=> rdata_addr 	,
		rdata_v			=> rdata_v 		,
		dcc_control		=> dcc_control 	,
		dcc_control_v	=> dcc_control_v,
		dcc_addr		=> dcc_addr 	,
		dcc_addr_v		=> dcc_addr_v 	,
		dcc_frame_out	=> dcc_frame_out
	);

    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

	-- Processing
    stimuli : process
	begin
		reset <= '1';
		dcc_addr <= X"000000" & "10011001";
		dcc_addr_v <= '1';
		dcc_control <= X"000000" & "10011001";
		dcc_control_v <= '1';
		wait for 100 ns;


		wait for period * 200;

		finished <= '1';
	wait;
	end process stimuli;

end Simple_TB_Frame_Builder_arc;