----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2019 09:53:26
-- Design Name: 
-- Module Name: CLK_1MHz - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_1MHz is
    Port (
        CLK_100MHz : in std_logic;
        reset : in std_logic;
        CLK_1MHz : out std_logic
    );
end clock_1MHz;

architecture Behavioral of clock_1MHz is
--signal clk : std_logic_vector(6 downto 0);
signal clk : integer range 0 to 49 :=0;
signal temp : std_logic := '0';
begin
process (CLK_100MHz, reset)

begin
    if reset = '0' then clk <= 0;
    elsif rising_edge(CLK_100MHz) then
    
        if (clk = 49) then
           temp <= not temp;
           clk <= 0;
       else 
          clk <= clk + 1;
       end if;
       
    end if;
    
end process;
CLK_1MHz <= temp;

end Behavioral;
