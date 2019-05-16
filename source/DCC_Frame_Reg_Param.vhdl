LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY frame_reg IS
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
END frame_reg;

architecture dataflow of frame_reg is

signal r_control : std_logic_vector (31 downto 0);
signal r_param_1 : std_logic_vector (31 downto 0); 
signal r_param_2 : std_logic_vector (31 downto 0);
signal r_param_3 : std_logic_vector (31 downto 0);
signal r_param_4 : std_logic_vector (31 downto 0);
signal r_param_5 : std_logic_vector (31 downto 0);
signal r_param_6 : std_logic_vector (31 downto 0);

-- signal r_control_v : std_logic; -- for v2

begin
	process(CLK_100MHz, reset)
	begin
	if reset = '1' then
		r_control <= X"00000000";
		r_param_1 <= X"00000000";
	elsif rising_edge(CLK_100MHz) then
		if wdata_v = '1' then
		case wdata_addr is
			when "0000" => r_control <= wdata;
			when "0001" => r_param_1 <= wdata;
			when others => NULL;
		end case;
		end if;
	end if;

	end process;
dcc_control_out <= r_control;
dout <= r_param_1;
end dataflow;
