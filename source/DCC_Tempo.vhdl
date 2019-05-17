library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tempo is 
    generic (
        COUNT : integer := 6000
    );
  port (
    CLK_1MHz    : in std_logic;
    reset       : in std_logic;
    COM_TEMPO   : in std_logic;
    fin          : out std_logic
  ) ;
end tempo;

architecture behac of tempo is
    signal cpt : integer range 0 to COUNT-1 := 0; -- 1MHz = 1us, 6ms / 1us = 6000

begin
    p0 : process( CLK_1MHz, reset )
    begin
        if reset = '1' then
            cpt <= 0;
            fin <= '0';
        elsif rising_edge(CLK_1MHz) then
            if cpt = COUNT-1 and COM_TEMPO = '0' then
                cpt <= 0;
                fin <= '0';
            elsif COM_TEMPO = '1' then
                if cpt = COUNT-1 then 
                    fin <= '1';
                    cpt <= 0;
                else 
                    cpt <= cpt + 1;
                    fin <= '0';
                end if;
            else
                fin <= '0';
                cpt <= 0;
            end if ;
        end if;
    end process ; -- p0

end behac ; -- behac