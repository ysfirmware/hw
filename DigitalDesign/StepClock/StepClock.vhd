library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StepClock is
	port(	nRESET			: in	std_logic;
			clk				: IN	std_logic;
			stepSwitch		: in	std_logic;

		-- clock out
			stepClockOut	: out	std_logic);
end StepClock;

architecture design of StepClock is
	type STATE_TYPE is (s0, s1);
	signal state	: STATE_TYPE;
begin
	process(nRESET, clk)
	begin
		if nRESET = '0' then
			state <= s0;
		elsif rising_edge(clk) then
			case state is 
				when s0 => 
					if stepSwitch = '0' then
						state <= s0;
					else 
						state <= s1;
						stepClockOut <= '1';
					end if;
				when s1 =>
					if stepSwitch = '0' then
						state <= s0;
						stepClockOut <= '0';
					else
						state <= s1;
						stepClockOut <= '0';
					end if;
			end case;
		end if;
	end process;			
end;