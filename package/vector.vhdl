LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


-- declaration
PACKAGE vector_pkg IS 

function vector_n_bits (value : std_logic; len : integer) 
	return std_logic_vector;

procedure vector_fill_0 (DOUT : out std_logic_vector);
procedure vector_fill_1 (DOUT : out std_logic_vector);


END vector_pkg;


-- Body
PACKAGE body vector_pkg IS

function vector_n_bits (value : std_logic; len : integer)
return std_logic_vector is
	variable dout : std_logic_vector(len-1 downto 0);
begin
	for i in len-1 downto 0 loop
      dout(i) := value;
    end loop;
	return dout;
end vector_n_bits;


procedure vector_fill_0 (
	DOUT : out std_logic_vector
) is
begin
	for i in DOUT'high-1 downto DOUT'low loop
      DOUT(i) := '0';
    end loop;
end procedure vector_fill_0;

procedure vector_fill_1 (
	DOUT : out std_logic_vector
) is
begin
	for i in DOUT'high-1 downto DOUT'low loop
      DOUT(i) := '1';
    end loop;
end procedure vector_fill_1;

END vector_pkg;