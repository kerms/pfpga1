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
        wait for 42 ns;
        reset <= '0';

         -- Counting
        for ignore in 0 to NB_COUNT-1 loop -- NB_COUNT-1 time
            check_eq(FIN, '0', "FIN " & to_string(ignore));
            wait for period;
        end loop;

        -- End counting
        if check_eq(FIN, '1', "FIN") then
            report "check iteration of " & to_string(0) & " ok";
        end if;
        

        Checking_loop : for i in 0 to 1 loop

            -- from previous count
            check_eq(FIN, '1', "FIN " & to_string(0));
            wait for period;

            -- Counting
            for ignore in 1 to NB_COUNT-1 loop -- NB_COUNT-1 time
                -- from previous count
                check_eq(FIN, '0', "FIN " & to_string(ignore));
                wait for period;
            end loop;

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