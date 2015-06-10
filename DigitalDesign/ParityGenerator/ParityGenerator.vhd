library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ParityGenerator is
	generic (n : integer := 7);
	port(	input	: in std_logic_vector(n-1 downto 0);
			output	: out std_logic_vector(n downto 0));
end ParityGenerator;

architecture design of ParityGenerator is
begin
	process(input)
		variable	temp1	: std_logic;
		variable	temp2	: std_logic_vector(n downto 0);
	begin
		temp1 := '0';
		for i in input'range loop
			temp1 := temp1 xor input(i);
			temp2(i) := input(i);
		end loop;
		temp2(n) := temp1;
		output <= temp2;
	end process;
end design;