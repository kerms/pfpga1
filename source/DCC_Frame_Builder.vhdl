 library ieee;
use ieee.std_logic_1164.all;
use work.vector_pkg.all;

entity frame_builder is
	generic (
		N_BIT : integer := 50
	);
	port (
		CLK_100MHz 		: in std_logic;
		RESET 			: in std_logic;

		-- read param
		rdata_addr 		: out std_logic_vector(3 downto 0);
		rdata_v 		: out std_logic;

		-- dcc param_1
		dcc_control		: in std_logic_vector(31 downto 0); -- only for 1st v
		dcc_control_v 	: in std_logic;
		din 			: in std_logic_vector(31 downto 0);
		dcc_frame_out	: out std_logic_vector(N_BIT-1 downto 0)
	);
end frame_builder;

architecture frame_builder_arc of frame_builder is

-- for build frame
signal frame_build : std_logic_vector(N_BIT-1 downto 0);

-- frame out, change if frame is validate on clock
signal r_dcc_frame : std_logic_vector(N_BIT-1 downto 0);


begin

-- 14 bits preambule + 1 Start bit = 15
frame_build(13 downto 0) <= vector_n_bits( '1', 14);
frame_build(14) <= '0';

-- 8 bits train address + 1 Start bit = 9, now 9+15=24
frame_build(22 downto 15) <= din(7 downto 0);
frame_build(23) <= '0';

-- 8 bits command first byte + 1 = 9, now 24+9 = 33
frame_build(31 downto 24) <= dcc_control(7 downto 0);
frame_build(32) <= '0';

-- 8 bits command second byte or ctl + 1 = 9, now 33+9=42
frame_build(40 downto 33) <= 
	(din(7 downto 0) xor dcc_control(7 downto 0));

frame_build(41) <= '1';-- when dcc_control(8) = '1' else '0';

-- control ont used in v1
--frame_build(49 downto 42) <= (din(7 downto 0) xor dcc_control(7 downto 0))
--							xor "11011110" when dcc_control(8) = '1' else
--							vector_n_bits( '0', 8);

dcc_frame_out <= r_dcc_frame;

rdata_v <= '1';
rdata_addr <= "0000"; -- always read control;

process (reset, CLK_100MHz)
begin
  if (reset = '1')  then
    r_dcc_frame <= vector_n_bits( '0', 42); -- vector 42;
  elsif (rising_edge(CLK_100MHz)) then
  	-- modify here if want to send idle
  	--if dcc_control_v = '1' and din_v = '1' then
  		r_dcc_frame <= frame_build;
  	--end if;
  end if;
end process ;


end frame_builder_arc;