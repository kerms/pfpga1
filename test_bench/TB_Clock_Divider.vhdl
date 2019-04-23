LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

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
    constant period : time := 10 ns;  -- 100 MHz
BEGIN 
    -- unit under test
    uut: Clock_Divider 
    GENERIC MAP (100)
    PORT MAP (
        clk_in  => clk_in,
        reset   => reset,
        clk_out => clk_out
    );

    -- Clock definition
    clk_process :process
        begin
        clk_in <= '0';
        wait for period / 2;
        clk_in <= '1';
        wait for period / 2;
    end process;

    -- Processing
    stimuli: process
    begin
        -- Init
        reset <= '1'; 
        wait for 100 ns;


        reset <= '0';
        wait;
    end process;
END;