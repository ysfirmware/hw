library ieee;
use ieee.std_logic_1164.all;

entity SimpleGates_vhdl is
	port(	A, B, C, D	: in	std_logic;
			X			: out	std_logic);
end SimpleGates_vhdl;

architecture design of SimpleGates_vhdl is
begin
	X <= ((A nor B) and (C nand D));
end design;