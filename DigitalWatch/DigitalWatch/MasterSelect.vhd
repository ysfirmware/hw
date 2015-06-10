-- divide by 1000000 clk
-- ALU Logic
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY MasterSelect IS
	PORT
	(
		reset						: in	std_logic;
		clk							: in	std_logic;
		clk1hz_out, clk2hz_out 		: out	std_logic;
		clk100hz_out				: out	std_logic;
		sw0, sw1					: in	std_logic;
		mode_out					: out	std_logic_vector(1 downto 0);
		set_time_out				: out	std_logic_vector(2 downto 0)
	);
END MasterSelect;

ARCHITECTURE MasterSelect_arch of MasterSelect IS
	signal	clk1hz, clk2hz, clk100hz: std_logic;
	signal	mode					: std_logic_vector(1 downto 0)	:= "00";
	signal	set_time				: std_logic_vector(2 downto 0)	:= "100";
	signal	nsw0, nnsw0				: std_logic;
	signal	sw0_node				: std_logic;
	
BEGIN
-- 1Hz clock generation
	process(clk, clk1hz)
	variable		cnt1hz		: 	integer := 0;
	begin
		if rising_edge(clk) then
			if cnt1hz >= 499999 then	
--			if cnt1hz >= 10 then	
				cnt1hz := 0;
				clk1hz <= not clk1hz;
			else
				cnt1hz := cnt1hz + 1;
			end if;
		end if;
		clk1hz_out <= clk1hz;
	end process;

-- 2Hz clock generation
	process(clk, clk2hz)
	variable		cnt2hz		: 	integer := 0;
	begin
		if rising_edge(clk) then
			if cnt2hz >= 249999 then	
--			if cnt2hz >= 5 then	
				cnt2hz := 0;
				clk2hz <= not clk2hz;
			else
				cnt2hz := cnt2hz + 1;
			end if;
		end if;
		clk2hz_out <= clk2hz;
	end process;


-- 100Hz clock generation
	process(clk, clk100hz)
	variable		cnt100hz	: 	integer := 0;
	begin
		if rising_edge(clk) then
			if cnt100hz >= 4999 then	
--			if cnt100hz >= 1 then	
				cnt100hz := 0;
				clk100hz <= not clk100hz;
			else
				cnt100hz := cnt100hz + 1;
			end if;
		end if;
		clk100hz_out <= clk100hz;
	end process;

	process(clk100hz, sw0)
	begin
		if reset = '0' then
			sw0_node <= '0';
		elsif rising_edge(clk100hz) then
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
	
	process(reset, sw0, sw1)
	begin
		if reset = '0' then
			set_time <= "100";
		elsif sw0 = '1' then
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
	set_time_out <= set_time;
end MasterSelect_arch;