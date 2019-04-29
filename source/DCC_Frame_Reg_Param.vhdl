LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY frame_reg IS
	PORT(
		din		: in std_logic_vector(32 downto 0);
		din_addr: in std_logic(3 downto 0);
		push	: in std_logic;

		command_dcc : in std_logic_vector(31 downto 0);
		command_dcc_v : in std_logic;

		dout	: out std_logic_vector(32 downto 0)
	);
END frame_reg;

architecture dataflow of frame_reg is

signal r_param_0 : std_logic; -- addr train
signal r_param_1 : std_logic; -- direction and  train speed
signal r_param_2 : std_logic;
signal r_param_3 : std_logic;
signal r_param_4 : std_logic;
signal r_param_5 : std_logic;
signal r_param_6 : std_logic;
signal r_control : std_logic;

begin
	process(din, push)
		begin
		if push = '1' then
			fifo_d <= din;
		end if;
	end process;
	dout <= fifo_d;
end dataflow;
