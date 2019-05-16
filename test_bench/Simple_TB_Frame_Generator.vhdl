library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;
use work.vector_pkg.all;

ENTITY Simple_TB_Frame_Generator IS
END Simple_TB_Frame_Generator;

architecture dataflow of Simple_TB_Frame_Generator is

component DCC_Frame_Generator IS
	GENERIC(
		NB_FRAME_BITS : integer := 42
	);
	PORT(
		buttons : in std_logic_vector(4 downto 0);
		switch : in std_logic_vector(15 downto 0);
		leds : out std_logic_vector(15 downto 0);
		CLK_100MHz : in std_logic;
		reset : in std_logic;
		DCC_Frame : out std_logic_vector(NB_FRAME_BITS-1 downto 0)
	);
END component;

constant NB_FRAME_BITS : integer := 42; 

signal buttons : std_logic_vector(4 downto 0);
signal switch : std_logic_vector(15 downto 0);
signal leds : std_logic_vector(15 downto 0);
signal DCC_Frame : std_logic_vector(NB_FRAME_BITS-1 downto 0);

-- global interface
signal CLK_100MHz	: std_logic := '0';
signal reset 		: std_logic;

-- TB
constant period : time := 10 ns; -- 100 MHz
signal finished : std_logic := '0';

begin

	-- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

	uut : DCC_Frame_Generator
	generic map (
		NB_FRAME_BITS
	)
	port map (
		buttons 	=> buttons	,
		switch 		=> switch	,
		leds 		=> leds		,
		CLK_100MHz 	=> CLK_100MHz,
		reset 		=> reset	,
		DCC_Frame 	=> DCC_Frame
	);

	process
	begin
	  	reset <= '1';
		switch <= vector_n_bits( '0', 16);
		buttons <= vector_n_bits( '0', 5);
		wait for 100 ns;
		reset <= '0';

		switch(8 downto 0) <= "1" & vector_n_bits( '1', 8);
		buttons <= "00100", "00000" after period;
		wait for 100 ns;

		switch(8 downto 0) <= "0" & "10011001";
		buttons <= "00100", "00000" after period;

		wait for 100 ns;
		finished <= '1';

		wait ;
	end process ;


end dataflow;
