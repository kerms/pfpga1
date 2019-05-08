library ieee;
use ieee.std_logic_1164.all;

entity TB_Counter is
end TB_Counter;


architecture Behavioral of TB_Counter is
    COMPONENT Counter
    generic (
            N : integer := 100
        );
    port (
        CLK_In      : in std_logic;
        reset       : in std_logic;
        COM_COUNTER : in std_logic;
        FIN         : out std_logic
    );
    END COMPONENT;

    -- Inputs
    signal clk_in  : std_logic := '0';
    signal reset   : std_logic := '0';
    signal COM_COUNTER  : std_logic;
    -- Outputs
    signal FIN : std_logic;
    constant period : time := 20 ns; 

    signal cpt : integer range 0 to 20 := 0;
begin
    -- unit under test
    uut: Counter 
    GENERIC MAP (20)
    PORT MAP (
        clk_in  => clk_in,
        reset   => reset,
        COM_COUNTER => COM_COUNTER,
        FIN => FIN
    );


    -- Clock definition
    clo_process :process
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

    -- Testing
    test_process : process (reset, clk_in)
    begin
        if (reset = '1') then
          cpt <= 0;
          COM_COUNTER <= '0';
          assert FIN='0' report "[ERROR] value has to be 0" severity ERROR;
        elsif (rising_edge(clk_in)) then
        if cpt = 19 then
            cpt <= 0;
            COM_COUNTER <= '1';
            assert FIN='1' report "[ERROR] cpt : value has to be 1 " severity ERROR;
        else 
            cpt <= cpt + 1;
            COM_COUNTER <= '0';
            assert FIN='0' report "ERROR" severity ERROR;
        end if;
        end if;
    end process test_process;
end Behavioral;