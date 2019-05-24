----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 10:39:25
-- Design Name: 
-- Module Name: DCC_BIT_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCC_BIT_1 is
  Port (GO_1 : in std_logic;
        reset : in std_logic;
        CLK_1MHz : in std_logic;
        CLK_100MHz : in std_logic;
        FIN_1 : out std_logic;
        DCC_1 : out std_logic 
   );
end DCC_BIT_1;

architecture Behavioral of DCC_BIT_1 is

signal cpt : integer range 0 to 57 :=0; --pour avoir 58microsecond
signal temp : std_logic := '0';
type etat is (IDLE, LO, HI); --LO : etat bas, HI : etat haut
signal EP, EF : etat;
begin
-----------------------------------------------MAE
process (reset, CLK_100MHz) 
    begin
    if reset='0' then EP <= IDLE;
    elsif rising_edge (CLK_100MHz) then EP<=EF;
    end if;
end process;

process (EP, GO_1 ) --MAE
    begin
    FIN_1<='0'; DCC_1<='0';
    case (EP) is
    when IDLE => FIN_1<='0'; DCC_1<='0';
        EF <= IDLE; if GO_1 ='1' then EF<=LO; end if;
    when LO => FIN_1<='0'; DCC_1<='0';
        EF <= LO; if cpt = 57 then EF<=HI; end if;
    when HI => FIN_1<='1'; DCC_1<='1';
        EF <= HI; if cpt = 57 then EF<=IDLE; end if;
    end case;
end process;
-----------------------------------------------------------compteur 
process (reset, CLK_1MHz) 
    begin
    if reset = '0' then cpt <= 0;
        elsif rising_edge(CLK_1MHz) then
        
            if (cpt = 57) then
               temp <= not temp;
               cpt <= 0;
           else 
              cpt <= cpt + 1;
           end if;
           
        end if;
end process;


end Behavioral;
