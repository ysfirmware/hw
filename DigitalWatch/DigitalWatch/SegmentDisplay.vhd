-- mode selection by switch 0
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY SegmentDisplay IS
	PORT
	(
		reset						: in	std_logic;
		clk2hz						: in	std_logic;
		clk100hz					: in	std_logic;
		mode						: in	std_logic_vector(1 downto 0);
		set_time					: in	std_logic_vector(2 downto 0);
		sw2							: in	std_logic;
		dc_sec, dc_min				: in	std_logic_vector(5 downto 0);
		dc_hour						: in	std_logic_vector(4 downto 0);
		al_sec, al_min				: in	std_logic_vector(5 downto 0);
		al_hour						: in	std_logic_vector(4 downto 0);
		tl_mmsec					: in	std_logic_vector(6 downto 0); 
		tl_sec, tl_min				: in	std_logic_vector(5 downto 0);
		
		seg_hour0, seg_hour1		: out	std_logic_vector(6 downto 0);
		seg_min0, seg_min1			: out	std_logic_vector(6 downto 0);
		seg_sec0, seg_sec1			: out	std_logic_vector(6 downto 0);
		mode_out					: out	std_logic_vector(2 downto 0);
		blink_out					: out	std_logic		
	);
END SegmentDisplay;

ARCHITECTURE SegmentDisplay_arch of SegmentDisplay IS
	signal	hour_buf0, hour_buf1	: integer := 0;
	signal	min_buf0, min_buf1		: integer := 0;
	signal	sec_buf0, sec_buf1		: integer := 0;
	signal	sec_on, min_on, hour_on	: std_logic	:= '0';
	signal	sw2_cnt					: integer	:= 0;
	signal	blink					: std_logic	:= '1'; -- this signal indicate blink operation on
	signal	disp_sec, disp_min, disp_hour	: std_logic	:= '1'; -- this signal blink synchronized with clk2hz

	type state_type is (s0, s1, s2, s3);
	signal	state					: state_type;

begin

-- process for 7-segment blink on/off
	process(reset, clk2hz, mode, set_time, blink, sw2)
	begin
		if reset = '0' then
			blink <= '1';
		elsif rising_edge(clk2hz) then
			case state is 
				when s0 =>
					if mode = "01" or mode = "10" then 	-- time set or alarm set mode
						if sw2 = '1' then
							state <= s1;
							blink <= '1';
						else
							state <= s0;
							blink <= '1';
						end if;
					else
						state <= s0;
						blink <= '1';
					end if;
				when s1 =>
					if mode = "01" or mode = "10" then
						if sw2 = '1' then
							state <= s2;
							blink <= '1';
						else
							state <= s0;
							blink <= '1';
						end if;
					else
						state <= s0;
						blink <= '1';
					end if;
				when s2 =>
					if mode = "01" or mode = "10" then
						if sw2 = '1' then
							state <= s3;
							blink <= '1';
						else
							state <= s0;
							blink <= '1';
						end if;
					else
						state <= s0;
						blink <= '1';
					end if;
				when s3 =>
					if mode = "01" or mode = "10" then
						if sw2 = '1' then
							state <= s3;
							blink <= '0';
						else
							state <= s0;
							blink <= '1';
						end if;
					else
						state <= s0;
						blink <= '1';
					end if;
			end case;	
		end if;
		blink_out <= blink;		
	end process;
	
-- process for display on/off
	process(clk2hz, mode, set_time, blink, disp_hour, disp_min, disp_sec)
	begin
		if rising_edge(clk2hz) then
			if mode = "01" or mode = "10" then
				if blink = '1' then 
					case set_time is
						when "100" => 
							disp_hour <= not disp_hour;
							disp_min <= '1';
							disp_sec <= '1';
						when "010" => 
							disp_hour <= '1';
							disp_min <= not disp_min;
							disp_sec <= '1';
						when "001" => 
							disp_hour <= '1';
							disp_min <= '1';
							disp_sec <= not disp_sec;
						when others => null;
					end case;
				else
					disp_hour <= '1';
					disp_min <= '1';
					disp_sec <= '1';
				end if;	
			else
				disp_hour <= '1';
				disp_min <= '1';
				disp_sec <= '1';
			end if;
		end if;		
	end process;

-- process for current mode display
	process(clk100hz, mode)
	begin
		if rising_edge(clk100hz) then
			case mode is
				when "00" => 
					mode_out <= "000";
				when "01" => 
					mode_out <= "100";
				when "10" => 
					mode_out <= "010";
				when "11" => 
					mode_out <= "001";
			end case;
		end if;
	end process;
	
-- process for converting to integer
	process(mode, dc_hour, dc_min, dc_sec, al_hour, al_min, al_sec, tl_mmsec, tl_sec, tl_min)
	begin
		case mode is
			when "00" =>	-- digital clock mode
				hour_buf0 <= conv_integer(dc_hour)/10;
				hour_buf1 <= conv_integer(dc_hour) mod 10;
				min_buf0 <= conv_integer(dc_min)/10;
				min_buf1 <= conv_integer(dc_min) mod 10;
				sec_buf0 <= conv_integer(dc_sec)/10;
				sec_buf1 <= conv_integer(dc_sec) mod 10;
			when "01" =>	-- clock setting mode
				hour_buf0 <= conv_integer(dc_hour)/10;
				hour_buf1 <= conv_integer(dc_hour) mod 10;
				min_buf0 <= conv_integer(dc_min)/10;
				min_buf1 <= conv_integer(dc_min) mod 10;
				sec_buf0 <= conv_integer(dc_sec)/10;
				sec_buf1 <= conv_integer(dc_sec) mod 10;
			when "10" =>	-- alarm mode
				hour_buf0 <= conv_integer(al_hour)/10;
				hour_buf1 <= conv_integer(al_hour) mod 10;
				min_buf0 <= conv_integer(al_min)/10;
				min_buf1 <= conv_integer(al_min) mod 10;
				sec_buf0 <= conv_integer(al_sec)/10;
				sec_buf1 <= conv_integer(al_sec) mod 10;
			when "11" =>	-- timer mode
				hour_buf0 <= conv_integer(tl_min)/10;
				hour_buf1 <= conv_integer(tl_min) mod 10;
				min_buf0 <= conv_integer(tl_sec)/10;
				min_buf1 <= conv_integer(tl_sec) mod 10;
				sec_buf0 <= conv_integer(tl_mmsec)/10;
				sec_buf1 <= conv_integer(tl_mmsec) mod 10;
			when others => null;	
		end case;	
	end process;

--	process for 7-segment display	
	process(clk100hz, hour_buf0, hour_buf1, min_buf0, min_buf1, sec_buf0, sec_buf1, disp_hour, disp_min, disp_sec)
	begin
		if rising_edge(clk100hz) then
			if disp_hour = '1' then
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
			else
				seg_hour0 <= "0000000";
				seg_hour1 <= "0000000";
			end if;
		end if;
		
		if rising_edge(clk100hz) then
			if disp_min = '1' then	
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
			else 
				seg_min0 <= "0000000";	
				seg_min1 <= "0000000";
			end if;	
		end if;

		if rising_edge(clk100hz) then
			if disp_sec = '1' then
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
			else
				seg_sec0 <= "0000000";
				seg_sec1 <= "0000000";
			end if;	
		end if;	
	end process;		
end SegmentDisplay_arch;