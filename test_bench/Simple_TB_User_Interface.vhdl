library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

entity Simple_TB_User_Interface is
end Simple_TB_User_Interface;

architecture Simple_TB_User_Interface_arc of Simple_TB_User_Interface is

component user_interface IS
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		buttons		: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(15 downto 0);
		leds		: out std_logic_vector(15 downto 0);

		-- to reg param
		wdata		: out std_logic_vector(31 downto 0);
		wdata_v 	: out std_logic;
		wdata_addr 	: out std_logic_vector(3 downto 0)
	);
END component;


signal buttons		  : std_logic_vector(4 downto 0);
signal switch		  : std_logic_vector(15 downto 0);
signal leds		  : std_logic_vector(15 downto 0);
signal wdata	: std_logic_vector(31 downto 0);
signal wdata_v 	: std_logic;
signal wdata_addr : std_logic_vector(3 downto 0);

-- global interface
signal CLK_100MHz	: std_logic:='0';
signal reset 		: std_logic;

-- TB
constant period : time := 10 ns; -- 100 MHz
signal finished : std_logic := '0';

begin
	uut : user_interface
	port map (
		CLK_100MHz 	  => CLK_100MHz		,
		reset		  => reset			,
		buttons		  => buttons		,
		switch		  => switch			,
  		leds		  => leds			,
		wdata   	  => wdata 			,
		wdata_v 	  => wdata_v 		,
		wdata_addr 	  => wdata_addr
	);

    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

	-- Processing
    stimuli : process
	begin
		reset <= '1';
		switch <= X"0000";
		buttons <= "00000";
		wait for 100 ns;
		reset <= '0';

		switch <= X"001F"; -- write addr
		buttons <= "00100", "00000" after period;
		wait for period * 20;


		switch <= X"000F"; -- write command
		buttons <= "00100", "00000" after period;
		wait for period;

		wait for period * 20;
		finished <= '1';
	wait;
	end process stimuli;

end Simple_TB_User_Interface_arc;