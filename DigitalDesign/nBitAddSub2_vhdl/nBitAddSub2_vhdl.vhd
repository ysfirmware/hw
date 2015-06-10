library ieee;
use ieee.std_logic_1164.all;

package my_package is
	constant adder_width			: integer:=4;
	constant result_width			: integer:=5;
	constant max_result				: integer:=2**result_width-1;
	constant min_result				: integer:=-2**result_width;
	
	subtype adder_value is integer range 0 to 2**adder_width-1;
	subtype result_value is integer range -2**result_width to 2**result_width-1;
end my_package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_package.all;

entity nBitAddSub2_vhdl is
	port(	a, b 				: in adder_value;
			m					: in std_logic;
			seg1, seg2			: out std_logic_vector(6 downto 0);
			sign				: out std_logic;
			sum					: out result_value;
			underflow, overflow : out std_logic);
	end nBitAddSub2_vhdl;

architecture design of nBitAddSub2_vhdl is
	signal over, under		: std_logic;
	signal seg1Reg, seg2Reg	: integer range 0 to 15;	
begin
	process(m, a, b, over, under)
		variable res 				: result_value;
	begin
		if (m = '0') then res := a + b;
		else res := a - b;
		end if;
			
		if (res > max_result) then over <= '1';
		else over <= '0';
		end if;

		if (res < min_result) then	under <= '1';
		else under <= '0';
		end if;

		if (over = '0' and under = '0') then sum <= res;
		end if;
		
		if (res < 0) then 
			sign <= '1';
			seg1Reg <= -res / 16;
			seg2Reg <= -res mod 16;
		else 
			sign <= '0';
			seg1Reg <= res / 16;
			seg2Reg <= res mod 16;
		end if;
		overflow <= over;
		underflow <= under;
	end process;
	
-- process for 7-segment display
	process(seg1Reg, seg2Reg)
	begin
		case seg1Reg is
--							   "abcdefg-"
			when 0	=> seg1	<= "1111110"; 
			when 1	=> seg1 <= "0110000"; 
			when 2	=> seg1 <= "1101101"; 
			when 3	=> seg1 <= "1111001"; 
			when 4	=> seg1 <= "0110011"; 
			when 5	=> seg1 <= "1011011"; 
			when 6	=> seg1 <= "1011111"; 
			when 7	=> seg1 <= "1110000"; 
			when 8	=> seg1 <= "1111111"; 
			when 9	=> seg1 <= "1110011"; 
			when 10	=> seg1 <= "1111101"; 
			when 11	=> seg1 <= "0011111"; 
			when 12	=> seg1 <= "0001101"; 
			when 13	=> seg1 <= "0111101"; 
			when 14	=> seg1 <= "1101111"; 
			when 15	=> seg1 <= "1000111"; 
		end case;
		
		case seg2Reg is
--							   "abcdefg-"
			when 0	=> seg2	<= "1111110"; 
			when 1	=> seg2 <= "0110000"; 
			when 2	=> seg2 <= "1101101"; 
			when 3	=> seg2 <= "1111001"; 
			when 4	=> seg2 <= "0110011"; 
			when 5	=> seg2 <= "1011011"; 
			when 6	=> seg2 <= "1011111"; 
			when 7	=> seg2 <= "1110000"; 
			when 8	=> seg2 <= "1111111"; 
			when 9	=> seg2 <= "1110011"; 
			when 10	=> seg2 <= "1111101"; 
			when 11	=> seg2 <= "0011111"; 
			when 12	=> seg2 <= "0001101"; 
			when 13	=> seg2 <= "0111101"; 
			when 14	=> seg2 <= "1101111"; 
			when 15	=> seg2 <= "1000111"; 
		end case;
	end process;	
end design;