library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ClockSync is
	port(	CLK 		: IN std_logic;
			a, b, c		: in std_logic;
			d, k		: out std_logic);
end ClockSync;

architecture design of ClockSync is
	signal	e, f, g		: std_logic;
	signal  x, y, z		: std_logic;
begin
	e <= a and b;
	f <= a xor e;
	g <= f or c;
	d <= g;
	
	process(clk, z)
	begin
		if rising_edge(clk) then
			x <= a and b;
			y <= a xor x;
			z <= y or c;
		end if;
		k <= z;
	end process;
end design;
