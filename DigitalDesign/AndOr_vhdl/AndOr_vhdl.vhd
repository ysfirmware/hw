library ieee;
use ieee.std_logic_1164.all;

entity AndOr_vhdl is
	port(	a, b						: in	std_logic;
			and_out, or_out, not_out	: out	std_logic);
end AndOr_vhdl;

architecture design of AndOr_vhdl is
begin
	and_out <= a and b;
	or_out <= a or b;
	not_out <= not a;
end design;
