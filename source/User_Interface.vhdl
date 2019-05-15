library ieee;
use ieee.std_logic_1164.all;

entity User_Interface is
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		boutons		: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(15 downto 0);
		leds		: out std_logic_vector(15 downto 0);

		-- to reg param
		wdata		: out std_logic_vector(31 downto 0);
		wdata_v 	: out std_logic;
		wdata_addr 	: out std_logic_vector(3 downto 0)
	);

end User_Interface;

architecture User_Interface_arc of User_Interface is

begin

wdata_addr <= "0001" when switch(8) = '1' -- addr
				else "0000"; -- ctrl

wdata <= X"0000" & switch;
wdata_v <= boutons(2);
leds <= switch;



end User_Interface_arc;