library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SwitchEncoder is
	port(	clk			: in std_logic;
			key			: in std_logic_vector(15 downto 0);
			keyVal		: out std_logic_vector(3 downto 0));
	end SwitchEncoder;

architecture design of SwitchEncoder is
begin
-- process for key input
	process(clk, key)
	begin
		if rising_edge(clk) then
			case key(15 downto 0) is
				when "0000000000000001" => keyVal <= "0000";
				when "0000000000000010" => keyVal <= "0001";
				when "0000000000000100" => keyVal <= "0010";
				when "0000000000001000" => keyVal <= "0011"; 
				when "0000000000010000" => keyVal <= "0100";
				when "0000000000100000" => keyVal <= "0101";
				when "0000000001000000" => keyVal <= "0110";
				when "0000000010000000" => keyVal <= "0111";
				when "0000000100000000" => keyVal <= "1000";
				when "0000001000000000" => keyVal <= "1001";
				when "0000010000000000" => keyVal <= "1010";
				when "0000100000000000" => keyVal <= "1011";
				when "0001000000000000" => keyVal <= "1100";
				when "0010000000000000" => keyVal <= "1101";
				when "0100000000000000" => keyVal <= "1110"; 
				when "1000000000000000" => keyVal <= "1111";
				when others => null;
			end case;
		end if;
	end process;
end design;