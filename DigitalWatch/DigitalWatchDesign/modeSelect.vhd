-- mode selection by switch 0
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY modeSelect IS
	PORT
	(
		reset					: in	std_logic;
		clk						: in 	std_logic;
		sw0						: in	std_logic;
		mode_out				: out	std_logic_vector(1 downto 0)
	);
END modeSelect;

ARCHITECTURE modeSelect_arch of modeSelect IS
		signal	mode		: std_logic_vector(1 downto 0);
		signal	sw0_node	: std_logic;
begin
	process(reset, clk, sw0)
	begin
		if reset= '0' then
			sw0_node <= '0';
		elsif rising_edge(clk) then
			sw0_node <= sw0;
		end if;
	end process;
	
	process(reset, sw0_node)
	begin
		if reset = '0' then
			mode <= "00";
		elsif rising_edge(sw0_node) then
			mode <= mode + '1';
		end if;
	end process;
	mode_out <= mode;
end modeSelect_arch;