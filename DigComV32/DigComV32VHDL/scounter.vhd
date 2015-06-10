-- Sequence Counter
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY scounter IS
	PORT
	(
		nRESET				: in	std_logic;
		stop				: in	std_logic;
		inClk				: IN	std_logic;
		sc_clr				: IN	std_logic;
		t					: OUT 	std_logic_vector(15 downto 0);
		M_t					: out	std_logic_vector(15 downto 0);
		clk20000_out		: out	std_logic;

		-- output for test
		clk2_out	: out	std_logic;
		M_clk_out	: out	std_logic;
		hlt_stop_out	: out	std_logic;
		state_mode_out	: out	std_logic_vector(2 downto 0);
		delay_sc_clr_out	: out	std_logic
	);
END scounter;

ARCHITECTURE simplecom of scounter IS
	signal	clk				: std_logic;
	signal	sc_clk			: std_logic;
	signal	stop_node		: std_logic;
	signal	t_node			: std_logic_vector(15 downto 0);
	signal	M_t_node		: std_logic_vector(15 downto 0);
	signal	clk2			: std_logic;		-- divided by 2 clock
	signal	M_clk			: std_logic;		-- memory clock
	signal	sc_clr_delay	: std_logic;		-- delayed sc_clr
	signal	m				: std_logic_vector(3 downto 0);		-- mode
	signal 	hlt_stop		: std_logic;
	signal	inst_stop		: std_logic;
	signal	clk20000		: std_logic;
	signal	state_mode		: std_logic_vector(2 downto 0);
	signal	delay_sc_clr	: std_logic;
	
	TYPE STATE_TYPE IS (s0, s1);

	TYPE STATE_TYPE1 IS (ss0, ss1);
	attribute enum_encoding					: string;
	attribute enum_encoding of STATE_TYPE1 	: type is "0 1";

	SIGNAL state	: STATE_TYPE;
	SIGNAL state1	: STATE_TYPE1;
	signal	step_node	: std_logic;

-- **************************************************
-- step clock generation during instruction step mode
-- **************************************************	
BEGIN
	process(nRESET, inClk, sc_clr)
	begin
		if nRESET = '0' then
			delay_sc_clr <= '0';
		elsif falling_edge(inClk) then
			delay_sc_clr <= sc_clr;
		end if;
	end process;
	delay_sc_clr_out <= delay_sc_clr;
	clk <= inClk;

-- divide by 2 clk
	process(nRESET, clk, clk2)
--	process(nRESET, clk, clk2, stop_node)
	begin
		if nRESET = '0' then
			clk2 <= '0';
		elsif falling_edge(clk) then
			clk2 <= not clk2;
		end if;
		clk2_out <= clk2;
	end process;

-- divide by 20000 clk, used by push-button switch
	process(nRESET, inClk)
	variable		cnt20000	: integer := 0;
	begin
		if nRESET = '0' then
			cnt20000 := 0;
			clk20000 <= '0';
		elsif rising_edge(inClk) then
			if cnt20000 >= 20000 then
--			if cnt20000 >= 10 then
				cnt20000 := 0;
				clk20000 <= not clk20000;
			else
				cnt20000 := cnt20000 + 1;
			end if;
		end if;
	end process;
	clk20000_out <= clk20000;	
			
	M_clk_out <= not inClk;

-- ****************************
-- stop set by HALT instruction
-- **************************** 
	process(clk, nRESET, stop)
	begin
		if nRESET = '0' then
			hlt_stop <= '1';		-- deactivated when hlt_stop is '1'
		elsif falling_edge(clk) then
			if stop = '1' then
				hlt_stop <= '0';	-- activated when hlt_stop is '0'
			end if;	
		end if;
	end process;

	hlt_stop_out <= hlt_stop;
	stop_node <= hlt_stop;

-- sequence counter clock
	process(clk2, nRESET, stop_node)
	begin
		sc_clk <= clk2 and stop_node;
	end process;


	-- delayed sc_clr
	process(clk, sc_clr)
	begin
		if rising_edge(clk) then
			sc_clr_delay <= sc_clr;
		end if;
	end process;

	-- sequence counter
	PROCESS (sc_clk, nRESET)
		VARIABLE	cnt			: INTEGER RANGE 0 TO 16;
	BEGIN
		if nRESET = '0' then
			cnt := 0;

		elsif rising_edge(sc_clk) then
			if sc_clr_delay = '1' then
				cnt := 1;
			else
				cnt := cnt + 1;
			end if;
		END IF;
		
		case cnt is
			when 0		=>	t_node <= "0000000000000000";
			when 1 		=>	t_node <= "0000000000000001";
			when 2 		=>	t_node <= "0000000000000010";
			when 3 		=>	t_node <= "0000000000000100";
			when 4 		=>	t_node <= "0000000000001000";
			when 5 		=>	t_node <= "0000000000010000";
			when 6		=>	t_node <= "0000000000100000";
			when 7 		=>	t_node <= "0000000001000000";
			when 8 		=>	t_node <= "0000000010000000";
			when 9		=>	t_node <= "0000000100000000";
			when 10 	=>	t_node <= "0000001000000000";
			when 11 	=>	t_node <= "0000010000000000";
			when 12 	=>	t_node <= "0000100000000000";
			when 13 	=>	t_node <= "0001000000000000";
			when 14 	=>	t_node <= "0010000000000000";
			when 15 	=>	t_node <= "0100000000000000";
			when 16 	=>	t_node <= "1000000000000000";
		end case;

		if cnt = 16 then
			cnt := 0;
		end if;
	END PROCESS;

	process(clk2, t_node, clk)
	begin
		if clk2 = '0' and rising_edge(clk) then
			M_t_node(15 downto 1) <= t_node(14 downto 0);
			M_t_node(0) <= '0';
		end if;
	end process;

 	state_mode_out(2) <= '1';
	state_mode_out(1) <= '0';
	state_mode_out(0) <= '0';

	t <= t_node;
	M_t <= M_t_node;
END simplecom;