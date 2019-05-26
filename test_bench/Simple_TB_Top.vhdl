library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;
use work.vector_pkg.all;

entity Simple_TB_Top is
end entity Simple_TB_Top;

architecture test_bench of Simple_TB_Top is
component dcc_center is
	port (
		CLK_100MHz 	: in std_logic;
		reset		: in std_logic;
		button 	: in std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(14 downto 0);
		led		: out std_logic_vector(15 downto 0);
		dcc_out		: out std_logic
	);
end component dcc_center;

signal CLK_100MHz 	: std_logic := '0';
signal reset		: std_logic;
signal button 		: std_logic_vector(4 downto 0);
signal switch		: std_logic_vector(14 downto 0);
signal led			:  std_logic_vector(15 downto 0);
signal dcc_out		:  std_logic;

constant period : time := 10 ns; -- 100 MHz
signal finished : std_logic := '0';

begin

	uut : dcc_center
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		reset		=> reset		,
		button     	=> button 		,
		switch		=> switch		,
		led   		=> led     		,
		dcc_out		=> dcc_out
	);

	-- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';
	
    process
    begin
		reset <= '1';
		button <= "00000";
		switch  <= vector_n_bits( '0', 15);
		wait for 100 ns;
		reset <= '0';
		switch <= vector_n_bits( '0', 7) & "01100010";
		button <= "00100", "00000" after period;
		wait for 20 ns;

		switch <= vector_n_bits( '0', 6) & '1' & X"02";
		button <= "00100", "00000" after period;


		wait for 1 sec;
		finished <= '1';
		wait;
    end process;

	
end architecture;