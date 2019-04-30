library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity tempo is
  port (
    CLK_1MHz    : in std_logic;
    reset       : in std_logic;
    COM_TEMPO   : in std_logic;
    fin          : out std_logic
  ) ;
end tempo;

architecture behac of tempo is
    signal fin_s: std_logic;
    signal cpt : integer range 0 to 5999 := 0; -- 1MHz = 1us, 6ms / 1us = 6000
begin
    p0 : process( CLK_1MHz, reset )
    begin
        if reset = '1' then
            fin_s <= '0';
            cpt <= 0;
        elsif rising_edge(CLK_1MHz) then
            if cpt = 5999 and COM_TEMPO = '0' then
                cpt <= 0;
                fin_s <= '0';
            elsif COM_TEMPO = '1' then
                if cpt = 5999 then 
                    fin_s <= '1';
                    cpt <= 0;
                else 
                    cpt <= cpt + 1;
                    fin_s <= '0';
                end if;
            else
                fin_s <= '0';
            end if ;
        end if;
    end process ; -- p0
    fin <= fin_s;


end behac ; -- behac