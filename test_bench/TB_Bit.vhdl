library ieee;
use ieee.std_logic_1164.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

entity TB_Bit is
end TB_Bit;

architecture TB_Bit_arc of TB_Bit is

component DCC_Bit
    generic (
		PERIOD : integer
	);
	port (
		CLK_100MHz 	: in std_logic;
		CLK_1MHz 	: in std_logic;
		reset		: in std_logic;
		Go 		: in std_logic;
		DCC 		: out std_logic;
		FIN 		: out std_logic
	);
end component;

COMPONENT Clock_Divider
generic (
        divisor : integer
    );
PORT(
    clk_in : IN  std_logic;
    reset  : IN  std_logic;
    clk_out: OUT std_logic
);
END COMPONENT;

signal CLK_100MHz 	:  std_logic;
signal CLK_1MHz 	:  std_logic;
signal reset		:  std_logic;

-- DCC Bit 0
signal Go_0 		:  std_logic;
signal DCC_0 		:  std_logic;
signal FIN_0		: std_logic;

-- DCC Bit 1
signal Go_1 		:  std_logic;
signal DCC_1 		:  std_logic;
signal FIN_1		: std_logic;


constant period : time := 10 ns; -- 100 MHz

begin

	clk_inst: Clock_Divider 
	GENERIC MAP (100) -- 100Mhz -> 1MHz
	PORT MAP (
	    clk_in  => CLK_100MHz,
	    reset   => reset,
	    clk_out => CLK_1MHz
	);

	uut : DCC_Bit
	GENERIC MAP (100) -- bit 0
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_0 		,
		DCC 		=> DCC_0 		,
		FIN 		=> FIN_0 		
	);

	uut2 : DCC_Bit
	GENERIC MAP (58) -- bit 1
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_1 		,
		DCC 		=> DCC_1 		,
		FIN 		=> FIN_1 		
	);

    -- Clock definition
 	CLK_100MHz <= not CLK_100MHz after period / 2;

	-- Processing
    stimuli : process
	begin
		reset <= '1';
		Go_0 <= '0';
		Go_1 <= '0';
		wait for 100 ns;

		reset <= '0';
		Go_0 <= '1';
		Go_1 <= '1';
		wait for 19990 us;

	wait;
	end process stimuli;

end TB_Bit_arc;