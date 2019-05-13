library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package conversion_pkg is

function to_integer ( to_conv : std_logic_vector) return integer;

function to_string ( to_conv: integer) return String;

function to_string ( to_conv: std_logic) return String;

function to_string ( to_conv: time) return String;

function to_string (to_conv : time; unit : string) return string;

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

function to_string ( to_conv: std_logic) return String is 
begin
	return std_logic'image(to_conv);
end function;

function to_string ( to_conv: time) return String is
begin
	return to_string(to_conv / 1 ns) & " ns";
end function;


function to_string (to_conv : time; unit : string) return string is
begin
	if unit = "fs" then
		return to_string(to_conv / 1 fs) & " " & unit;
	elsif unit = "ps" then
		return to_string(to_conv / 1 ps) & " " & unit;
	elsif unit = "ns" then
		return to_string(to_conv / 1 ns) & " " & unit;
	elsif unit = "us" then
		return to_string(to_conv / 1 us) & " " & unit;
	elsif unit = "ms" then
		return to_string(to_conv / 1 ms) & " " & unit;
	elsif unit = "sec" or unit = "s" then
		return to_string(to_conv / 1 sec) & " " & unit;
	elsif unit = "min" then
		return to_string(to_conv / 1 min) & " " & unit;
	elsif unit = "hr" or unit = "hour" then
		return to_string(to_conv / 1 hr) & " " & unit;
	else
		return to_string(to_conv);
	end if;
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