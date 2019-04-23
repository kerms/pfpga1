library ieee;
use ieee.std_logic_1164.all;


entity TB_DCC_Bit_0 is
end TB_DCC_Bit_0;

architecture TB_DCC_Bit_0_arc of TB_DCC_Bit_0 is

component DCC_Bit_0
	port (
		CLK_100MHz 	: in std_logic;
		CLK_1MHz 	: in std_logic;
		reset		: in std_logic;
		Go_0 		: in std_logic;
		DCC_0 		: out std_logic;
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
signal Go_0 		:  std_logic;
signal DCC_0 		:  std_logic;
signal FIN 			: std_logic;

constant period : time := 10 ns; -- 100 MHz

begin

	clk_inst: Clock_Divider 
	GENERIC MAP (100)
	PORT MAP (
	    clk_in  => CLK_100MHz,
	    reset   => reset,
	    clk_out => CLK_1MHz
	);

	uut : DCC_Bit_0
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go_0 		=> Go_0 		,
		DCC_0 		=> DCC_0 		,
		FIN 		=> FIN 		
	);

    -- Clock definition
    clk_process :process
        begin
        CLK_100MHz <= '0';
        wait for period / 2;
        CLK_100MHz <= '1';
        wait for period / 2;
    end process;

	-- Processing
    stimuli : process
	begin
		reset <= '1';
		wait for 100 ns;

		reset <= '0';
		Go_0 <= '1';
		wait for 19990 us;

	wait;
	end process stimuli;

end TB_DCC_Bit_0_arc;