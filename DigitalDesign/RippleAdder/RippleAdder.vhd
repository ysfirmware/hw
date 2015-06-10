library ieee;
use ieee.std_logic_1164.ALL;

library work;
use work.UserAdder.all;

entity RippleAdder is    
    port(	x, y	:	in std_logic_vector(3 downto 0);
			seg1, seg2	:	out std_logic_vector(6 downto 0));
end RippleAdder;

architecture design of RippleAdder is
		signal c  	:	std_logic_vector(2 downto 0);
		signal sum	:	std_logic_vector(3 downto 0);
		signal c_out	: std_logic;
begin
	c0	: HalfAdder 
		port map (x(0), y(0), sum(0), c(0));
    c12	: for i in 1 to 2 generate
		c1to2:  FullAdder port map(x(i), y(i), c(i-1), sum(i), c(i));
		end generate;
	c3	: FullAdder port map(x(3), y(3), c(2), sum(3), c_out);
	
	process(sum, c_out)
	begin
		case sum is
--							   		"abcdefg"
			when "0000"	=> seg2 <= 	"1111110"; 
			when "0001"	=> seg2 <= 	"0110000"; 
			when "0010"	=> seg2 <= 	"1101101"; 
			when "0011"	=> seg2 <= 	"1111001"; 
			when "0100"	=> seg2 <= 	"0110011"; 
			when "0101"	=> seg2 <= 	"1011011"; 
			when "0110"	=> seg2 <= 	"1011111"; 
			when "0111"	=> seg2 <= 	"1110000"; 
			when "1000"	=> seg2 <= 	"1111111"; 
			when "1001"	=> seg2 <= 	"1110011"; 
			when "1010"	=> seg2 <= 	"1111101"; 
			when "1011"	=> seg2 <= 	"0011111"; 
			when "1100"	=> seg2 <= 	"0001101"; 
			when "1101"	=> seg2 <= 	"0111101"; 
			when "1110"	=> seg2 <= 	"1101111"; 
			when "1111"	=> seg2 <= 	"1000111"; 
		end case;

		case c_out is
--							   		"abcdefg"
			when '0'	=> seg1 <= 	"1111110"; 
			when '1'	=> seg1 <= 	"0110000"; 
			when others => seg1 <= 	"0000000"; 
		end case;
	end process;	
end design;

library ieee;
use ieee.std_logic_1164.ALL;
package UserAdder is
	component FullAdder 
		port(	a, b, c_in	:	in std_logic;
				sum, c_out  :	out std_logic);
	end component;
   
	component HalfAdder
		port(	a, b		: in std_logic;
				sum, c_out	: out std_logic);
	end component;		
end UserAdder;

library ieee;
use ieee.std_logic_1164.ALL;

entity FullAdder is 
	port(	a, b, c_in		: in    std_logic;
			sum, c_out		: out   std_logic);
end FullAdder;

architecture designFA of FullAdder is
begin
    sum <= (not a and not b and c_in) or (not a and b and not c_in) 
		or (a and not b and not c_in) or (a and b and c_in);
    c_out <= (a and b) or (a and c_in) or (b and c_in);
end designFA;

library ieee;
use ieee.std_logic_1164.ALL;

entity HalfAdder is 
    port(	a, b		: in    std_logic;
			sum, c_out	: out   std_logic);
end HalfAdder;

architecture designHA of HalfAdder is
begin
    sum <= (not a and b) or (a and not b);
    c_out <= a and b;
end designHA;
