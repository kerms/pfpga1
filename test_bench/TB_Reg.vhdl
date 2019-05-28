library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

entity TB_Reg is
end TB_Reg;


architecture Behavioral of TB_Reg is
	component DCC_Reg
	generic (
		N_BITS : integer := 50
	);
	port(
		-- global definition
		CLK_100MHz	: in std_logic;
		reset 		: in std_logic;

		-- from frame generator
		frame_in	: in std_logic_vector(N_BITS-1 downto 0);

		-- from FSM
		COM_REG	 	: in std_logic;
		inval_reg	: in std_logic;

		-- output to FSM
		bit_carry	: out std_logic;
		dcc_frame_v : out std_logic
	);
	end component;

    COMPONENT Counter_Auto
    generic (
            N : integer := 100
        );
    port (
        CLK_in      : in std_logic;
        reset       : in std_logic;
        FIN         : out std_logic
    );
    END COMPONENT;


    -- TEST BENCH
    constant period : time := 10 ns; 
    constant N_BITS : integer := 50; 
    signal finished : std_logic := '0';

    -- Inputs
	signal CLK_100MHz  : std_logic := '0';
   	signal reset   : std_logic := '0';
    signal frame_in	: std_logic_vector(N_BITS-1 downto 0);
	signal COM_REG	 	: std_logic;
	signal inval_reg	: std_logic;
	signal bit_carry	:  std_logic;
	signal dcc_frame_v :  std_logic;



begin
	uut : DCC_Reg
	generic map(N_BITS)
	port map(
		CLK_100MHz	=> CLK_100MHz	,
		reset 		=> reset 		,
		frame_in	=> frame_in		,
		COM_REG	 	=> COM_REG	 	,
		inval_reg	=> inval_reg	,
		bit_carry	=> bit_carry	,
		dcc_frame_v => dcc_frame_v 
	);

    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

    -- Testing
    test_process : process
    variable copy_reg : std_logic_vector(N_BITS-1 downto 0);
    variable ran : integer;
    begin
        reset <= '1';
        COM_REG <= '0';
        inval_reg <= '0';
        wait for 100 ns;
        reset <= '0';

        for i in 0 to 2 loop
        	copy_reg := random(N_BITS);
        	frame_in <= copy_reg;
        	inval_reg <= '1', '0' after period*2;
        	wait until rising_edge(CLK_100MHz);
        	report to_bstring(frame_in);
        	report to_bstring(copy_reg);
            wait for period *2 + 42 ns;

            /* check if each carry is ok with the copy */
        	for j in 0 to N_BITS-1 loop
        		check_eq(bit_carry, copy_reg(j), "DCC_Reg(" & to_string(j) & ")");
        		--report "value of copy : " & to_string(copy_reg(j));
        		--report "value of carry : " & to_string(bit_carry);
        		COM_REG <= '1';--, '0' after period;
        		wait for period;
        	end loop;
        	COM_REG <= '0';
        end loop;

        check_report;
        finished <= '1';
        wait;
    end process test_process;
end Behavioral;