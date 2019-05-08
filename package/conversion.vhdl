library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package conversion_pkg is

function to_integer ( to_conv : std_logic_vector) return integer;

function to_string ( to_conv: integer) return String;

function to_bstring (to_conv: std_logic_vector) return string;


end conversion_pkg;



package body conversion_pkg is

function to_integer (to_conv : std_logic_vector) return integer is

begin
	return to_integer(unsigned(to_conv));
end function to_integer;

function to_string ( to_conv: integer) return String is 
begin
	return integer'image(to_conv);
end function;

function to_bstring (to_conv: std_logic_vector) return string is
variable ret : string(0 to to_conv'high);
begin
	for i in 0 to to_conv'high loop
		if ( to_conv(i) = '1' ) then 
			ret(i) := '1';
		else
			ret(i) := '0';
		end if;
    end loop;
    return ret;
end function;

end conversion_pkg;