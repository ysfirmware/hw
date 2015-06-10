library ieee;
use ieee.std_logic_1164.all;

entity FullAdder1_vhdl is
	port(	x, y, z		: in	std_logic;
			S, C		: out 	std_logic);
end FullAdder1_vhdl;

architecture design of FullAdder1_vhdl is
	signal k			: std_logic_vector(2 downto 0);
begin
	k <= x&y&z;
	
	process(k)
	begin
		case k is
			when "000" =>
				S <= '0';
				C <= '0';
			when "001" =>
				S <= '1';
				C <= '0';
			when "010" =>
				S <= '1';
				C <= '0';
			when "011" =>
				S <= '0';
				C <= '1';
			when "100" =>
				S <= '1';
				C <= '0';
			when "101" =>
				S <= '0';
				C <= '1';
			when "110" =>
				S <= '0';
				C <= '1';
			when "111" =>
				S <= '1';
				C <= '1';
		end case;
	end process;
end design;