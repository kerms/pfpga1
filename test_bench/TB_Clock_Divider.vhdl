LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

ENTITY TB_Clock_Divider IS
END TB_Clock_Divider;

ARCHITECTURE behavior OF TB_Clock_Divider IS 
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

    -- Inputs
    signal clk_in  : std_logic := '0';
    signal reset   : std_logic := '0';
    -- Outputs
    signal clk_out : std_logic;

    -- simulation
    signal finished : std_logic := '0';
    -- TEST PARAM
    constant period : time := 10 ns;  -- 100 MHz
    constant CLK_DIVISION : integer := 100; 

BEGIN 
    -- unit under test
    uut: Clock_Divider 
    GENERIC MAP (CLK_DIVISION)
    PORT MAP (
        clk_in  => clk_in,
        reset   => reset,
        clk_out => clk_out
    );

    -- Clock definition
    clk_in <= not clk_in after period/2 when finished /= '1' else '0';


    -- Processing
    stimuli: process
    begin
        -- Init
        reset <= '1'; 
        wait for 100 ns;
        wait until rising_edge(clk_in);
        reset <= '0';

        -- begin test
        check_eq(clk_out, '0', "clock_out");
        for i in 0 to 2 loop
            -- LOW
            for ignored in 0 to CLK_DIVISION/2-1 loop
                wait for period;
                check_eq(clk_out, '0', "clock_out");
            end loop;

            -- HIGH
            for ignored  in 0 to CLK_DIVISION/2-1 loop
                wait for period;
                check_eq(clk_out, '1', "clock_out");
            end loop;
        end loop;

        finished <= '1';
        check_report;
        wait;
    end process;
END;