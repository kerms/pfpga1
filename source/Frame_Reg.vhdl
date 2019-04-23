LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY frame_reg IS
	generic (
		N_BIT : integer := 50
	);
	PORT(
		din		: in std_logic_vector(N_BIT downto 0);
		push	: in std_logic;

		dout	: out std_logic_vector(N_BIT downto 0)
	);
END frame_reg;

architecture dataflow of frame_reg is

signal fifo_d	: std_logic_vector(N_BIT downto 0);

begin
	process(din, push)
		begin
		if push = '1' then
			fifo_d <= din;
		end if;
	end process;
	dout <= fifo_d;
end dataflow;
