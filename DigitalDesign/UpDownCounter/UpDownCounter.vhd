library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity UpDownCounter is
	port(	clk		: in	std_logic;
			input	: in	std_logic;
			reset	: in	std_logic;
			cnt_out	: out	std_logic_vector(1 downto 0);
			seg		: out	std_logic_vector(6 downto 0));
end UpDownCounter;

architecture design of UpDownCounter is
	type state_type is (s0, s1, s2, s3);
	signal state	: state_type;
	signal output	: std_logic_vector(1 downto 0);	
begin
	process (reset, clk)
	begin
		if reset = '0' then
			state <= s0;
		elsif rising_edge(clk) then
			case state is
				when s0=>
					if input = '0' then
						state <= s1;
					else
						state <= s3;
					end if;
				when s1=>
					if input = '0' then
						state <= s2;
					else
						state <= s0;
					end if;
				when s2=>
					if input = '0' then
						state <= s3;
					else
						state <= s1;
					end if;
				when s3=>
					if input = '0' then
						state <= s0;
					else
						state <= s2;
					end if;
			end case;
		end if;
	end process;
	output <= 	"00" when state = s0 else
				"01" when state = s1 else
				"10" when state = s2 else
				"11";
	
-- process for 7-segment display
	process(output)
	begin
		case output is
--							  "abcdefg-"
			when "00"	=> seg <= "1111110"; 
			when "01"	=> seg <= "0110000"; 
			when "10"	=> seg <= "1101101"; 
			when "11"	=> seg <= "1111001"; 
			when others	=> seg <= "0000000"; 
		end case;
	end process;	
	cnt_out <= output;
end design;