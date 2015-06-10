-- mode selection by switch 0
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY clockSetting IS
	PORT
	(
--		signal out		
		clk1hz_out					: out	std_logic;
--		sec_out						: out	std_logic_vector(5 downto 0);
--		sec_buf0_out, sec_buf1_out	: out	std_logic_vector(3 downto 0);	
--		min_out						: out	std_logic_vector(5 downto 0);
--		min_buf0_out, min_buf1_out	: out	std_logic_vector(3 downto 0);	
--		hour_out					: out	std_logic_vector(4 downto 0);
--		hour_buf0_out, hour_buf1_out	: out	std_logic_vector(3 downto 0);	
		mode_out 						: out	std_logic_vector(1 downto 0);
--		set_time_out			: out	std_logic_vector(2 downto 0);		

		reset					: in	std_logic;
		clk						: in	std_logic;
		sw0, sw1, sw2			: in	std_logic;
		seg_hour0, seg_hour1	: out	std_logic_vector(6 downto 0);
		seg_min0, seg_min1		: out	std_logic_vector(6 downto 0);
		seg_sec0, seg_sec1		: out	std_logic_vector(6 downto 0)
		
	);
END clockSetting;

ARCHITECTURE clockSetting_arch of clockSetting IS
	signal 	clk1hz		: std_logic;
	signal	timeClock	: std_logic;
	signal	mode		: std_logic_vector(1 downto 0);
	signal	sw0_node	: std_logic;
	signal	set_time	: std_logic_vector(2 downto 0);
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
--			if cnt1hz >= 4 then	
				
				cnt1hz := 0;
				clk1hz <= not clk1hz;
			else
				cnt1hz := cnt1hz + 1;
			end if;
		end if;
	end process;
	clk1hz_out <= clk1hz;

	process(reset, clk, sw0)
	begin
		if reset= '0' then
			sw0_node <= '0';
		elsif rising_edge(clk) then
			sw0_node <= sw0;
		end if;
	end process;
	
	process(reset, sw0_node)
	begin
		if reset = '0' then
			mode <= "00";
		elsif rising_edge(sw0_node) then
			mode <= mode + '1';
		end if;
	end process;
	mode_out <= mode;

	process(reset, sw1)
	begin
		if reset = '0' then
			set_time <= "100";
		elsif rising_edge(sw1) then
			case set_time is
				when "100" => 
					set_time <= "010";
				when "010" => 
					set_time <= "001";
				when "001" => 
					set_time <= "100";
				when others =>
					set_time <= null;
			end case;
		end if;
	end process;	
--	set_time_out <= set_time;

-- process for clock source
	process(clk1hz, mode, sw2)
	begin
		if mode = "01" then
			timeClock <= sw2;
		else
			timeClock <= clk1hz;
		end if;
	end process;

-- process for second
	process(reset, timeClock, sec)
	begin
		if reset = '0' then
			sec <= "000000";
		elsif rising_edge(timeClock) then
			if mode = "01" then				-- time set mode
				if set_time = "001" then	-- second time set
					if conv_integer(sec) >= 59 then
						sec <= "000000";
					else
						sec <= sec + '1';
					end if;
				end if;
			else
				if conv_integer(sec) >= 59 then
					sec <= "000000";
				else
					sec <= sec + '1';
				end if;
			end if;
		end if;		
	end process;
	
--	sec_out <= sec;
--	sec_buf0_out <= conv_std_logic_vector(sec_buf0, 4);
--	sec_buf1_out <= conv_std_logic_vector(sec_buf1, 4);

-- process for minute
	process(reset, timeClock, sec, mode, set_time)
	begin
		if reset = '0' then
			min <= "000000";
		elsif rising_edge(timeClock) then	
			if mode = "01" then				-- time set mode
				if set_time = "010" then	-- minute time set
					if conv_integer(min) >= 59 then
						min <= "000000";
					else
						min <= min + '1';
					end if;
				end if;
			else		
				if conv_integer(sec) >= 59 then
					if conv_integer(min) >= 59 then
						min <= "000000";
					else
						min <= min + '1';
					end if;
				end if;	
			end if;	
		end if;
	end process;
--	min_out <= min;
--	min_buf0_out <= conv_std_logic_vector(min_buf0, 4);
--	min_buf1_out <= conv_std_logic_vector(min_buf1, 4);

-- process for hour
	process(reset, timeClock, min, mode, set_time)
	begin
		if reset = '0' then
			hour <= "00000";
		elsif rising_edge(timeClock) then
			if mode = "01" then
				if set_time = "100" then
					if conv_integer(hour) >= 23 then
						hour <= "00000";
					else
						hour <= hour + '1';
					end if;
				end if;
			else
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
		end if;		
	end process;	
--	hour_out <= hour;
--	hour_buf0_out <= conv_std_logic_vector(hour_buf0, 4);
--	hour_buf1_out <= conv_std_logic_vector(hour_buf1, 4);

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
end clockSetting_arch;



