 library ieee;
use ieee.std_logic_1164.all;
use work.vector_pkg.all;

entity frame_generator is
	generic (
		N_BIT : integer := 50
	);
	port (
		CLK_100MHz 	: in std_logic;
		RESET 		: in std_logic;

		-- dcc param_0
		dcc_addr	: in std_logic_vector(31 downto 0);

		dcc_control : in std_logic_vector(31 downto 0);
		dcc_frame_v : in std_logic;

		dcc_frame	: out std_logic_vector(N_BIT-1 downto 0)
	);
end frame_generator;

architecture frame_generator_arc of frame_generator is


begin

-- 14 bits preambule + 1 Start bit = 15
dcc_frame(13 downto 0) <= vector_n_bits( '1', 14);
dcc_frame(14) <= '0';

-- 8 bits train address + 1 Start bit = 9, now 9+15=24
dcc_frame(22 downto 15) <= dcc_addr(7 downto 0);
dcc_frame(23) <= '0';

-- 8 bits command first byte + 1 = 9, now 24+9 = 33
dcc_frame(31 downto 24) <= dcc_control(7 downto 0);
dcc_frame(32) <= '0';

-- 8 bits command second byte or ctl + 1 = 9, now 33+9=42
dcc_frame(40 downto 33) <= 
		"11011110" when dcc_control(8) = '1' else
		(dcc_addr(7 downto 0) xor dcc_control(7 downto 0));

dcc_frame(41) <= '0' when dcc_control(8) = '1' else '1';

-- control
dcc_frame(49 downto 42) <= (dcc_addr(7 downto 0) xor dcc_control(7 downto 0))
							xor "11011110" when dcc_control(8) = '1' else
							vector_n_bits( '0', 8);
    
end frame_generator_arc;