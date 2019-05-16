library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;
use work.vector_pkg.all;

entity Simple_TB_Frame_Reg_Param is
end Simple_TB_Frame_Reg_Param;

architecture Simple_TB_Frame_Reg_Param_arc of Simple_TB_Frame_Reg_Param is

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
	dout		: out std_logic_vector(31 downto 0)
	);
END component;


signal wdata : std_logic_vector(31 downto 0);
signal wdata_addr : std_logic_vector(3 downto 0);
signal wdata_v : std_logic;
signal rdata_addr : std_logic_vector(3 downto 0);
signal rdata_v : std_logic;
signal dcc_control_out : std_logic_vector(31 downto 0);
signal dout : std_logic_vector(31 downto 0);

-- global interface
signal CLK_100MHz	: std_logic := '0';
signal reset 		: std_logic;

-- TB
constant period : time := 10 ns; -- 100 MHz
signal finished : std_logic := '0';

begin

    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

    uut : frame_reg
    port map (
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

	-- Processing
    stimuli : process
	begin
		wdata <= vector_n_bits( '0', 32);
		wdata_v <= '0';
		wdata_addr <= "0000";
		reset <= '1';
		wait for 100 ns;
		reset <= '0';

		wdata <= vector_n_bits( '0', 24) & X"FF";
		wdata_addr <= "0001";
		wdata_v <= '1', '0' after period;

		wait for 100 ns;

		wdata <= vector_n_bits( '0', 24) & X"F0";
		wdata_addr <= "0000";
		wdata_v <= '1', '0' after period;

		wait for 100 ns;
		finished <= '1';
	wait;
	end process stimuli;

end Simple_TB_Frame_Reg_Param_arc;