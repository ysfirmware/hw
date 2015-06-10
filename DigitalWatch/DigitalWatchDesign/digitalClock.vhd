-- mode selection by switch 0
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY digitalClock IS
	PORT
	(
--		signal out		
--		clk1hz_out				: out	std_logic;
--		sec_out					: out	std_logic_vector(5 downto 0);
--		sec_buf0_out, sec_buf1_out	: out	std_logic_vector(3 downto 0);			

		reset					: in	std_logic;
		clk						: in	std_logic;
		seg_hour0, seg_hour1	: out	std_logic_vector(6 downto 0);
		seg_min0, seg_min1		: out	std_logic_vector(6 downto 0);
		seg_sec0, seg_sec1		: out	std_logic_vector(6 downto 0)
		
	);
END digitalClock;

ARCHITECTURE digitalClock_arch of digitalClock IS
	signal 	clk1hz		: std_logic;
	signal	hour		: std_logic_vector(4 downto 0) := "00000";
	signal	min, sec	: std_logic_vector(5 downto 0) := "000000";
	signal	hour_buf0, hour_buf1	: integer := 0;
	signal	min_buf0, min_buf1		: integer := 0;
	signal	sec_buf0, sec_buf1		: integer := 0;

begin
	process(clk, clk1hz)
		variable		cnt1hz	: 	integer := 0;
	begin
		if rising_edge(clk) then
			if cnt1hz >= 499999 then	
				cnt1hz := 0;
				clk1hz <= not clk1hz;
			else
				cnt1hz := cnt1hz + 1;
			end if;
		end if;
	end process;
--	clk1hz_out <= clk1hz;
	
-- process for second
	process(reset, clk1hz, sec)
	begin
		if reset = '0' then
			sec <= "000000";
		elsif rising_edge(clk1hz) then
			if conv_integer(sec) >= 59 then	
				sec <= "000000";
			else
				sec <= sec + '1';
			end if;
		end if;
	end process;
--	sec_out <= sec;
--	sec_buf0_out <= conv_std_logic_vector(sec_buf0, 4);
--	sec_buf1_out <= conv_std_logic_vector(sec_buf1, 4);

-- process for minute
	process(reset, clk1hz, sec, min)
	begin
		if reset = '0' then
			min <= "000000";
		elsif rising_edge(clk1hz) then
			if conv_integer(sec) >= 59 then
				if conv_integer(min) >= 59 then
					min <= "000000";
				else
					min <= min + '1';
				end if;
			end if;
		end if;
	end process;

-- process for hour
	process(reset, clk1hz, sec, min, hour)
	begin
		if reset = '0' then
			hour <= "00000";
		elsif rising_edge(clk1hz) then
			if conv_integer(sec) >= 59 then
				if conv_integer(min) >= 59 then
					if conv_integer(hour) >= 23 then
						hour <= "00000";
					else	
						hour <= hour + '1';
					end if;	
				end if;
			end if;
		end if;
	end process;	

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
end digitalClock_arch;