LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions

-- declaration
PACKAGE random_pkg IS 

--impure function RandInt (Min, Max: integer; Exclude: integer_vector) 
--    return integer ;
--impure function RandInt ( A : integer_vector ) return integer ;
--impure function RandInt ( A : integer_vector; Exclude: integer_vector) 
--    return integer ;

procedure seed(s : in positive);
procedure seed(s1, s2 : in positive);

impure function random(min, max : integer) 
	return integer;

impure function random (min, max : integer; size : integer) 
	return std_logic_vector;

END random_pkg;

-- Body
PACKAGE body random_pkg IS

shared variable seed1 : positive;
shared variable seed2 : positive;

procedure seed(s : in positive) is
begin
	seed1 := s;
	if s > 1 then
		seed2 := s - 1;
	else
		seed2 := s + 42;
	end if;
end procedure;

procedure seed(s1, s2 : in positive) is
begin
	seed1 := s1;
	seed2 := s2;
end procedure;

impure function random return real is
    variable result : real;
begin
    uniform(seed1, seed2, result);
    return result;
end function;

impure function random(min, max : integer) return integer is
begin
    return integer(trunc(real(max - min + 1) * random)) + min;
end function;

impure function random (min, max : integer; size : integer) 
return std_logic_vector is
begin
	return std_logic_vector ( to_unsigned( random(min,max), size));
end function;

END random_pkg;