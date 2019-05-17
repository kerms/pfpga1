LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.random_pkg.all;
use work.check_pkg.all;
use work.conversion_pkg.all;

ENTITY Simple_TB_Tempo IS
END Simple_TB_Tempo;

ARCHITECTURE behavior OF Simple_TB_Tempo IS 
    COMPONENT Tempo
    generic (
            COUNT : integer
        );
    PORT(
        CLK_1MHz    : in std_logic;
        reset       : in std_logic;
        COM_TEMPO   : in std_logic;
        fin          : out std_logic
    );
    END COMPONENT;

    
    signal CLK_1MHz  : std_logic := '0';
    signal reset   : std_logic := '0';
    signal COM_TEMPO : std_logic;
    signal fin : std_logic;

    
    signal finished : std_logic := '0';
    constant period : time := 1 us;  -- 1MHz

BEGIN 
    -- unit under test
    uut: Tempo 
    GENERIC MAP (6000)
    PORT MAP (
        CLK_1MHz    => CLK_1MHz ,
        reset       => reset    ,
        COM_TEMPO   => COM_TEMPO,
        fin         => fin
    );

    -- Clock definition
    CLK_1MHz <= not CLK_1MHz after period/2 when finished /= '1' else '0';

    -- Processing
    stimuli: process
    begin
        -- Init
        reset <= '1';
        COM_TEMPO <= '0';
        wait for 100 ns;
        reset <= '0';

        COM_TEMPO <= '1';
        wait for 6000 * period;
        

        COM_TEMPO <= '1', '0' after period;
        wait for 6000 * period;

        COM_TEMPO <= '1', '0' after period;
        wait for 6000 * period;


        finished <= '1';
        wait;
    end process;
END;