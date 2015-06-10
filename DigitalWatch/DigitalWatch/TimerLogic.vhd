-- Timer Logic
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY TimerLogic IS
	PORT
	(
		reset					: in	std_logic;
		clk100hz				: in	std_logic;
		mode					: in	std_logic_vector(1 downto 0);
		set_time				: in	std_logic_vector(2 downto 0);
		sw1, sw2				: in	std_logic;
		
		mmsec_out				: out	std_logic_vector(6 downto 0);
		sec_out					: out	std_logic_vector(5 downto 0);
		min_out					: out	std_logic_vector(5 downto 0)
	);
END TimerLogic;

ARCHITECTURE TimerLogic_arch of TimerLogic IS
	signal	mmsec		: std_logic_vector(6 downto 0) := "0000000";
	signal	min, sec	: std_logic_vector(5 downto 0) := "000000";
	signal 	state		: std_logic;	-- 0 : stop state, 1 : up count state
begin

-- process for state control
	process(reset, mode, sw1)
	begin
		if reset = '0' then
			state <= '0';	-- stop state
		elsif rising_edge(sw1) then
			if mode = "11" then
				if state = '0' then
					state <= '1';
				else 
					state <= '0';
				end if;
			end if;
		end if;		
	end process;
	
-- process for 1/100 second
	process(reset, clk100hz, state, mode, sw2)
	begin
		if reset = '0' then
			mmsec <= "0000000";
		elsif state = '0' then
			if mode = "11" then
				if sw2 = '1' then
					mmsec <= "0000000";
				end if;
			end if;	
		else
			if rising_edge(clk100hz) then
				if conv_integer(mmsec) >= 99 then
					mmsec <= "0000000";
				else
					mmsec <= mmsec + '1';
				end if;
			end if;
		end if;	
	end process;

-- process for second
	process(reset, clk100hz, mmsec, state, mode, sw2)
	begin
		if reset = '0' then
			sec <= "000000";
		elsif state = '0' then	
			if mode = "11" then
				if sw2 = '1' then
					sec <= "000000";
				end if;
			end if;	
		else
			if rising_edge(clk100hz) then
				if conv_integer(mmsec) >= 99 then
					if conv_integer(sec) >= 59 then
						sec <= "000000";
					else
						sec <= sec + '1';
					end if;
				end if;	
			end if;
		end if;
	end process;

-- process for min
	process(reset, clk100hz, mmsec, sec, state, mode, sw2)
	begin
		if reset = '0' then
			min <= "000000";
		elsif state = '0' then
			if mode = "11" then
				if sw2 = '1' then
					min <= "000000";
				end if;
			end if;
		else
			if rising_edge(clk100hz) then
				if conv_integer(mmsec) >= 99 then
					if conv_integer(sec) >= 59 then
						if conv_integer(min) >= 59 then
							min <= "000000";
						else
							min <= min + '1';
						end if;	
					end if;
				end if;	
			end if;
		end if;	
	end process;	
	mmsec_out <= mmsec;
	sec_out <= sec;
	min_out <= min;
end TimerLogic_arch;



