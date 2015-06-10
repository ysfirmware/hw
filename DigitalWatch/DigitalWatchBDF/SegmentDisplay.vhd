-- mode selection by switch 0
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY SegmentDisplay IS
	PORT
	(
		clk							: in	std_logic;
		mode						: in	std_logic_vector(1 downto 0);
		sec, min					: in	std_logic_vector(5 downto 0);
		hour						: in	std_logic_vector(4 downto 0);
		
		seg_hour0, seg_hour1		: out	std_logic_vector(6 downto 0);
		seg_min0, seg_min1			: out	std_logic_vector(6 downto 0);
		seg_sec0, seg_sec1			: out	std_logic_vector(6 downto 0)
	);
END SegmentDisplay;

ARCHITECTURE SegmentDisplay_arch of SegmentDisplay IS
	signal	hour_buf0, hour_buf1	: integer := 0;
	signal	min_buf0, min_buf1		: integer := 0;
	signal	sec_buf0, sec_buf1		: integer := 0;

begin
	
-- process for converting to integer
	process(hour, min, sec)
	begin
		hour_buf0 <= conv_integer(hour)/10;
		hour_buf1 <= conv_integer(hour) mod 10;
		min_buf0 <= conv_integer(min)/10;
		min_buf1 <= conv_integer(min) mod 10;
		sec_buf0 <= conv_integer(sec)/10;
		sec_buf1 <= conv_integer(sec) mod 10;
	end process;	

--	process for 7-segment display	
	process(clk, hour_buf0, hour_buf1, min_buf0, min_buf1, sec_buf0, sec_buf1)
	begin
		if rising_edge(clk) then
			case hour_buf0 is         --abcdefg-
				when 0 => seg_hour0 <= "1111110";
				when 1 => seg_hour0 <= "0110000";
				when 2 => seg_hour0 <= "1101101";
				when 3 => seg_hour0 <= "1111001";
				when 4 => seg_hour0 <= "0110011";
				when 5 => seg_hour0 <= "1011011";
				when 6 => seg_hour0 <= "1011111";
				when 7 => seg_hour0 <= "1110000";
				when 8 => seg_hour0 <= "1111111";
				when 9 => seg_hour0 <= "1110011";
				when others => null;
			end case;
		
			case hour_buf1 is         --abcdefg-
				when 0 => seg_hour1 <= "1111110";
				when 1 => seg_hour1 <= "0110000";
				when 2 => seg_hour1 <= "1101101";
				when 3 => seg_hour1 <= "1111001";
				when 4 => seg_hour1 <= "0110011";
				when 5 => seg_hour1 <= "1011011";
				when 6 => seg_hour1 <= "1011111";
				when 7 => seg_hour1 <= "1110000";
				when 8 => seg_hour1 <= "1111111";
				when 9 => seg_hour1 <= "1110011";
				when others => null;
			end case;
			
			case min_buf0 is         --abcdefg-
				when 0 => seg_min0 <= "1111110";
				when 1 => seg_min0 <= "0110000";
				when 2 => seg_min0 <= "1101101";
				when 3 => seg_min0 <= "1111001";
				when 4 => seg_min0 <= "0110011";
				when 5 => seg_min0 <= "1011011";
				when 6 => seg_min0 <= "1011111";
				when 7 => seg_min0 <= "1110000";
				when 8 => seg_min0 <= "1111111";
				when 9 => seg_min0 <= "1110011";
				when others => null;
			end case;
			
			case min_buf1 is         --abcdefg-
				when 0 => seg_min1 <= "1111110";
				when 1 => seg_min1 <= "0110000";
				when 2 => seg_min1 <= "1101101";
				when 3 => seg_min1 <= "1111001";
				when 4 => seg_min1 <= "0110011";
				when 5 => seg_min1 <= "1011011";
				when 6 => seg_min1 <= "1011111";
				when 7 => seg_min1 <= "1110000";
				when 8 => seg_min1 <= "1111111";
				when 9 => seg_min1 <= "1110011";
				when others => null;
			end case;

			case sec_buf1 is         --abcdefg-
				when 0 => seg_sec1 <= "1111110";
				when 1 => seg_sec1 <= "0110000";
				when 2 => seg_sec1 <= "1101101";
				when 3 => seg_sec1 <= "1111001";
				when 4 => seg_sec1 <= "0110011";
				when 5 => seg_sec1 <= "1011011";
				when 6 => seg_sec1 <= "1011111";
				when 7 => seg_sec1 <= "1110000";
				when 8 => seg_sec1 <= "1111111";
				when 9 => seg_sec1 <= "1110011";
				when others => null;
			end case;

			case sec_buf0 is         --abcdefg-
				when 0 => seg_sec0 <= "1111110";
				when 1 => seg_sec0 <= "0110000";
				when 2 => seg_sec0 <= "1101101";
				when 3 => seg_sec0 <= "1111001";
				when 4 => seg_sec0 <= "0110011";
				when 5 => seg_sec0 <= "1011011";
				when 6 => seg_sec0 <= "1011111";
				when 7 => seg_sec0 <= "1110000";
				when 8 => seg_sec0 <= "1111111";
				when 9 => seg_sec0 <= "1110011";
				when others => null;
			end case;
		end if;
	end process;		
end SegmentDisplay_arch;