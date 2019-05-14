LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY frame_reg IS
	PORT(
	    CLK_100MHz 	: in std_logic;
        reset        : in std_logic;
		din		: in std_logic_vector(31 downto 0);
		din_addr: in std_logic(3 downto 0);
		push	: in std_logic;
		dcc_control_out	: out std_logic_vector(31 downto 0);
        dout	: out std_logic_vector(31 downto 0)
		--command_dcc : in std_logic_vector(31 downto 0);
		--command_dcc_v : in std_logic;		
	);
END frame_reg;

architecture dataflow of frame_reg is

signal r_control : std_logic_vector (31 downto 0);
signal r_param_1 : std_logic_vector (31 downto 0); 
signal r_param_2 : std_logic_vector (31 downto 0);
signal r_param_3 : std_logic_vector (31 downto 0);
signal r_param_4 : std_logic_vector (31 downto 0);
signal r_param_5 : std_logic_vector (31 downto 0);
signal r_param_6 : std_logic_vector (31 downto 0);

begin
	process(din, push)
		begin
		case (din_addr) is
		  when "0000" => dcc_control_out<= r_control;
		  when  "0001" => dout<= r_param_1;
		  when others      => dout<= r_param_2;
		  end case;
	end process;
	
end dataflow;
