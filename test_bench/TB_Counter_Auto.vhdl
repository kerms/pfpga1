library ieee;
use ieee.std_logic_1164.all;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

entity TB_Counter_Auto is
end TB_Counter_Auto;


architecture Behavioral of TB_Counter_Auto is
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

    -- Inputs
    signal CLK_100MHz  : std_logic := '0';
    signal reset   : std_logic := '0';
    -- Outputs
    signal FIN : std_logic;

    -- simulation 
    signal finished : std_logic := '0';

    -- TEST PARAM
    constant period : time := 10 ns; 
    constant NB_COUNT : integer := 42;

begin
    -- unit under test
    uut: Counter_Auto 
    GENERIC MAP (NB_COUNT)
    PORT MAP (
        CLK_in  => CLK_100MHz,
        reset   => reset,
        FIN => FIN
    );


    -- Clock definition
    CLK_100MHz <= not CLK_100MHz after period/2 when finished /= '1' else '0';

    -- Testing
    test_process : process
    begin
        reset <= '1'; 
        wait for 100 ns;

        wait until rising_edge(CLK_100MHz);
        report "rising edge : ";
        reset <= '0';

        Checking_loop : for i in 0 to 2 loop

            -- Counting
            for ignore in 0 to NB_COUNT-2 loop -- NB_COUNT-1 time
                wait for period;
                check_eq(FIN, '0', "FIN");
            end loop;
            wait for period; -- NB_COUNT-th time

            -- End counting
            if check_eq(FIN, '1', "FIN") then
                report "check iteration of " & to_string(i) & " ok";
            end if;
        end loop;

        finished <= '1';
        check_report;
        wait;
    end process test_process;
end Behavioral;