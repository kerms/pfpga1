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

signal CLK_100MHz 	:  std_logic := '0';
signal CLK_1MHz 	:  std_logic;
signal reset		:  std_logic;

-- DCC Bit 0
signal Go_0 		:  std_logic:= '0';
signal DCC_0 		:  std_logic;
signal FIN_0		: std_logic;

-- DCC Bit 1
signal Go_1 		:  std_logic:= '0';
signal DCC_1 		:  std_logic;
signal FIN_1		: std_logic;

-- Testing definition
signal test_begin : std_logic := '0';
signal finished : std_logic := '0';
signal finished_1 : std_logic := '0';
signal finished_0 : std_logic := '0';
signal stop_0 : std_logic := '0';
signal stop_1 : std_logic := '0';

constant period : time := 10 ns; -- 100 MHz
constant bit_1_count : integer := 58;
constant bit_0_count : integer := 100;

procedure check (
	count : in integer;
	name : in string;
	signal Clk_100MHz : in std_logic;
	signal CLK_1MHz : in std_logic;
	signal GO : out std_logic;
	signal DCC, FIN : in std_logic
) is

begin
	---- test 1 ----
	wait for random(0 ns, 1023 ns);
	GO <= '1', '0' after period;
	
	-- LOW
	report name & " check low";
	if rising_edge(CLK_1MHz) then 
		wait for period;
	end if;

	for i in 0 to count-2 loop -- -2 because at edge value is 1;
		wait until rising_edge(CLK_1MHz);
		check_eq(DCC, '0', name);
	end loop;
	
	-- HIGH
	report name & " check high";
	for i in 0 to count-1 loop 	
		wait until rising_edge(CLK_1MHz);
		check_eq(DCC, '1', name);
	end loop;
	


	---- test 2 ----
	-- sync
	wait until rising_edge(CLK_1MHz);
	GO <= '1','0' after period;
	-- LOW

	report "end check";
end check;


begin

	clk_inst: Clock_Divider 
	GENERIC MAP (100) -- 100Mhz -> 1MHz
	PORT MAP (
	    clk_in  => CLK_100MHz,
	    reset   => reset,
	    clk_out => CLK_1MHz
	);

	uut : DCC_Bit
	GENERIC MAP (bit_0_count) -- bit 0 - 100
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_0 		,
		DCC 		=> DCC_0 		,
		FIN 		=> FIN_0 		
	);

	uut2 : DCC_Bit
	GENERIC MAP (bit_1_count) -- bit 1 - 58
	port map(
		CLK_100MHz 	=> CLK_100MHz 	,
		CLK_1MHz 	=> CLK_1MHz 	,
		reset		=> reset		,
		Go 		    => Go_1 		,
		DCC 		=> DCC_1 		,
		FIN 		=> FIN_1 		
	);

    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';
	
	-- Processing
    stimuli : process
	begin
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
		test_begin <= '1', '0' after period;
		wait until finished_0 = '1' and finished_1 = '1';
		
		finished <= '1';
		check_report;
	wait;
	end process stimuli;

	test_bit_0 : process
	begin
		wait until test_begin = '1';
		check(bit_0_count, "DCC_0",CLK_100MHz, CLK_1MHz, Go_0, DCC_0, FIN_0);
		finished_0 <= '1';
	wait;
	end process test_bit_0;

	test_bit_1 : process
	begin
		wait until test_begin = '1';
		check(bit_1_count, "DCC_1",CLK_100MHz, CLK_1MHz, Go_1, DCC_1, FIN_1);
		finished_1 <= '1';
	wait;
	end process test_bit_1;


end TB_Bit_arc;