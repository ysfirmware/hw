library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SequenceDetector is
	port(	clk		: in	std_logic;
			input	: in	std_logic;
			reset	: in	std_logic;
			output	: out	std_logic);
end SequenceDetector;

architecture design of SequenceDetector is
	type state_type is (s0, s1, s2, s3);
	signal state	: state_type;
begin
	process (reset, clk)
	begin
		if reset = '0' then
			state <= s0;
		elsif rising_edge(clk) then
			case state is
				when s0=>
					if input = '0' then
						state <= s0;
					else
						state <= s1;
					end if;
				when s1=>
					if input = '0' then
						state <= s0;
					else
						state <= s2;
					end if;
				when s2=>
					if input = '0' then
						state <= s0;
					else
						state <= s3;
					end if;
				when s3=>
					if input = '0' then
						state <= s0;
					else
						state <= s3;
					end if;
			end case;
		end if;
	end process;
	process(state)
	begin
		case state is
			when s0 => output <= '0';
			when s1 => output <= '0';
			when s2 => output <= '0';
			when s3 => output <= '1';
		end case;	
	end process;				
end design;