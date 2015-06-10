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
use ieee.std_logic_arith.all;
use work.my_package.all;

entity nBitAddSub1_vhdl is
	port(	a, b 				: in adder_value;
			m					: in std_logic;
			sum					: out result_value;
			underflow, overflow : out std_logic);
	end nBitAddSub1_vhdl;

architecture design of nBitAddSub1_vhdl is
	signal over, under		: std_logic;
begin
	process(m, a, b, over, under)
		variable res : result_value;
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
	
		overflow <= over;
		underflow <= under;
	end process;
end design;