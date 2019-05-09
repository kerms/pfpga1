library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions



-- declaration
package check_pkg is

procedure check_eq (
	current_value : in std_logic;
	expected_value : in std_logic;
	var_name : in String
);

procedure check_eq (
	current_value : in integer;
	expected_value : in integer;
	var_name : in String
);

procedure check_eq (
	current_value : in integer;
	expected_value : in integer;
	var_name : in String;
	stop : in std_logic
);

impure function check_eq (
	current_value : std_logic;
	expected_value : std_logic;
	var_name : String
) return boolean;

impure function check_eq (
	current_value : integer;
	expected_value : integer;
	var_name : String
) return boolean;

procedure check_report;

end check_pkg;



-- definition
package body check_pkg is

shared variable nr_warning : integer := 0;
shared variable nr_error : integer := 0;
shared variable nr_total : integer := 0;

impure function check_error return String is
begin
	nr_error := nr_error + 1;
	return "[ERROR] ";
end check_error;

procedure check_eq (
	current_value : in std_logic;
	expected_value : in std_logic;
	var_name : in String
) is
begin
	assert (current_value = expected_value) 
		report check_error&
		var_name&" expected "&std_logic'image(expected_value)&
		", but current value is "&std_logic'image(current_value)
		severity ERROR;
	nr_total := nr_total + 1;
end procedure check_eq;

procedure check_eq (
	current_value : in integer;
	expected_value : in integer;
	var_name : in String
) is
begin
	assert (current_value = expected_value) 
		report check_error&
		var_name&" expected "&integer'image(expected_value)&
		", but current value is "&integer'image(current_value)
		severity ERROR;
	nr_total := nr_total + 1;
end procedure check_eq;

procedure check_eq (
	current_value : in integer;
	expected_value : in integer;
	var_name : in String;
	stop : in std_logic
) is 
begin
	wait until (current_value /= expected_value) or stop='1';
	check_eq(current_value, expected_value, var_name);
	nr_total := nr_total + 1;
end procedure;

impure function check_eq (
	current_value : std_logic;
	expected_value : std_logic;
	var_name : String
) return boolean is
begin
	assert (current_value = expected_value) 
		report check_error&
		var_name&" expected "&std_logic'image(expected_value)&
		", but current value is "&std_logic'image(current_value)
		severity ERROR;
	nr_total := nr_total + 1;
	return current_value = expected_value;
end function;

impure function check_eq (
	current_value : integer;
	expected_value : integer;
	var_name : String
) return boolean is
begin
	assert (current_value = expected_value) 
		report check_error&
		var_name&" expected "&integer'image(expected_value)&
		", but current value is "&integer'image(current_value)
		severity ERROR;
	nr_total := nr_total + 1;
	return current_value = expected_value;
end function;

procedure check_report is
begin
	report LF & LF &"[REPORT] : "& LF
		& "Total check   : " &integer'image(nr_total)&""& LF
		& "Total error   : " &integer'image(nr_error)&""& LF
		& "Total warning : " &integer'image(nr_warning)&""& LF ;
end procedure check_report;

end package body;
