library ieee;
use ieee.std_logic_1164.all;

entity frame_generator is
	port (
		CLK_100MHz 	: in std_logic;
		RESET 		: in std_logic;
		boutons		: in std_logic_vector(4 downto 0);
		leds		: out std_logic_vector(15 downto 0);
		dcc 		: out std_logic_vector(7 downto 0);
	);
end frame_generator;

architecture frame_generator_arc of frame_generator is
begin

end frame_generator_arc;