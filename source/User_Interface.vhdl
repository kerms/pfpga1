library ieee;
use ieee.std_logic_1164.all;

entity User_Interface is
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		boutons		: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(15 downto 0);

		leds		: out std_logic_vector(15 downto 0);
		command_dcc : out std_logic_vector(31 downto 0);
		command_dcc_v : out std_logic;
		command_valid : out std_logic
	);

end User_Interface;

architecture User_Interface_arc of User_Interface is


begin


command_valid <= boutons(2);
leds <= switch;
command_dcc(15 downto 0) <= switch;


end User_Interface_arc;