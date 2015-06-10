library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SimpleStateMachine is
	port ( 	m, n, i, clk, rst	: in std_logic;
			y					: out std_logic);
end SimpleStateMachine;

architecture design of SimpleStateMachine is
	type state_type is (S0, S1);
	signal state	: state_type;
begin
	process (rst, clk)
	begin
		if rst= '0' then
			state <= S0;
		elsif rising_edge(clk) then
			case state is 
				when S0 =>
					if (i = '1') then state <= S1;
					else state <= S0;
					end if;
				when S1 =>
					if (i = '1') then state <= S0;
					else state <= S1;
					end if;
			end case;
		end if;
	end process;
	
	y <= m when state = S0 else
		 n;	
end design;