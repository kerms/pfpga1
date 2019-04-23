library ieee;
use ieee.std_logic_1164.all;

entity Clock_Divider is
	generic (
			divisor : integer := 100
		);
	port (
		CLK_In 		: in std_logic;
		reset		: in std_logic;
		CLK_Out 	: out std_logic
	);
end Clock_Divider;


architecture Behavioral of Clock_Divider is

    COMPONENT Counter
    generic (
            N : integer := 100
        );
    port (
        CLK_In      : in std_logic;
        reset       : in std_logic;
        FIN         : out std_logic
    );
    END COMPONENT;

    signal temporal: STD_LOGIC;
    signal fin : STD_LOGIC;
begin

    counter_inst : Counter 
    GENERIC MAP (divisor/2)
    PORT MAP (
        clk_in  => clk_in,
        reset   => reset,
        FIN => FIN
    );


    frequency_divider: process (reset, CLK_In) begin
        if (reset = '1') then
            temporal <= '0';
        elsif rising_edge(CLK_In) then
            if fin = '1' then
                temporal <= NOT(temporal);
            end if;
        end if;
    end process;
    
    CLK_Out <= temporal;
end Behavioral;