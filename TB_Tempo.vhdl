library ieee;
use ieee.std_logic_1664.all;
use work.Tempo.all;

entity tb_tempo is
end tb_tempo;

architecture behac of tb_tempo is

component Tempo 
port (
    CLK_1MHz    : in std_logic;
    reset       : in std_logic;
    COM_TEMPO   : in std_logic;
    fin         : out std_logic
    );
end component;

signal CLK_1MHz    :  std_logic;
signal reset       :  std_logic;
signal COM_TEMPO   :  std_logic;
signal fin         :  std_logic;

begin
    ins_1 : Tempo port map(
        CLK_1MHz    => CLK_1MHz,
        reset       => reset,
        COM_TEMPO   => COM_TEMPO,
        fin         => fin
    );

p0 : process
-- process
variable tmp : integer := 0;
begin
-- begin
    
reset <= '1';
CLK_1MHz <= '0';
COM_TEMPO <= '0';
wait 2 ns;
CLK_1MHz <= '1';
reset <= '0';
COM_TEMPO <= '1';
wait 2 ns;

loop1 : for i in 0 to 6000 loop
    COM_TEMPO <= '1';
    CLK_1MHz <= '0';
    wait for 2 ns;
    CLK_1MHz <= '1';
    wait for 2 ns;
end loop ; -- loop1
assert fin = '0' report "fin : WRONG VALUE" severity ERROR;

wait ;
end process ; -- p0

end behac ; -- behac