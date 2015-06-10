LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY regOut is
	PORT(
		nReset						: in 	std_logic;
		clk20000					: in	std_logic;
		registerSelect_sw			: IN	std_logic;
		ac_in, dr_in, ir_in, tr_in 	: IN	std_logic_vector(15 downto 0);
		ar_in, pc_in				: in	std_logic_vector(11 downto 0);
		inpr_in, outr_in			: in	std_logic_vector(7 downto 0);
		selected_reg				: OUT	std_logic_vector(31 downto 0);
		register_led				: out	std_logic_vector(7 downto 0)
		);
END regOut;

ARCHITECTURE design OF regOut is
	TYPE STATE_TYPE IS (s0, s1, s2, s3, s4, s5, s6, s7);
	SIGNAL 	state		: STATE_TYPE;
	signal	reg_node	: std_logic_vector(15 downto 0);
	signal	select_node	: std_logic;
	signal	reg_select	: std_logic_vector(2 downto 0);
	
BEGIN

	process(nReset, clk20000)
	begin
		if nReset = '0' then
			select_node <= '1';
		elsif rising_edge(clk20000) then
			select_node <= registerSelect_sw;
		end if;
	end process;


	process(nReset, select_node, reg_node)
	begin
		if nReset = '0' then
			reg_select <= "000";
		elsif rising_edge(select_node) then
			reg_select <= reg_select + '1';
		end if;
	end process;


	PROCESS (nReset, select_node, ar_in, pc_in, dr_in, ac_in, inpr_in, ir_in, tr_in, outr_in, reg_node, reg_select)
	BEGIN
		if nReset = '0' then
			reg_node <= "0000000000000000";
		else
			CASE reg_select IS
			WHEN "000" =>
				reg_node(15 downto 12) <= "0000";
				reg_node(11 downto 0) <= ar_in;
				register_led <= "10000000";
			WHEN "001" =>
				reg_node(15 downto 12) <= "0000";
				reg_node(11 downto 0) <= pc_in;
				register_led <= "01000000";
			WHEN "010" =>
				reg_node <= dr_in;
				register_led <= "00100000";
			WHEN "011" =>
				reg_node <= ac_in;
				register_led <= "00010000";
			WHEN "100" =>
				reg_node(15 downto 8) <= "00000000";
				reg_node(7 downto 0) <= inpr_in;
				register_led <= "00001000";
			WHEN "101" =>
				reg_node <= ir_in;
				register_led <= "00000100";
			WHEN "110" =>
				reg_node <= tr_in;
				register_led <= "00000010";			
			WHEN "111" =>
				reg_node(15 downto 8) <= "00000000";
				reg_node(7 downto 0) <= outr_in;
				register_led <= "00000001";
			END CASE;
		end if;

		case reg_node(15 downto 12) is
--											             "abcdefg-"
			when "0000"	=> selected_reg(31 downto 24) <= "11111100"; 
			when "0001"	=> selected_reg(31 downto 24) <= "01100000"; 
			when "0010"	=> selected_reg(31 downto 24) <= "11011010"; 
			when "0011"	=> selected_reg(31 downto 24) <= "11110010"; 
			when "0100"	=> selected_reg(31 downto 24) <= "01100110"; 
			when "0101"	=> selected_reg(31 downto 24) <= "10110110"; 
			when "0110"	=> selected_reg(31 downto 24) <= "10111110"; 
			when "0111"	=> selected_reg(31 downto 24) <= "11100000"; 
			when "1000"	=> selected_reg(31 downto 24) <= "11111110"; 
			when "1001"	=> selected_reg(31 downto 24) <= "11100110"; 
			when "1010"	=> selected_reg(31 downto 24) <= "11111010"; 
			when "1011"	=> selected_reg(31 downto 24) <= "00111110"; 
			when "1100"	=> selected_reg(31 downto 24) <= "00011010"; 
			when "1101"	=> selected_reg(31 downto 24) <= "01111010"; 
			when "1110"	=> selected_reg(31 downto 24) <= "11011110"; 
			when "1111"	=> selected_reg(31 downto 24) <= "10001110"; 
		end case;

		case reg_node(11 downto 8) is
--											             "abcdefg-"
			when "0000"	=> selected_reg(23 downto 16) <= "11111100"; 
			when "0001"	=> selected_reg(23 downto 16) <= "01100000"; 
			when "0010"	=> selected_reg(23 downto 16) <= "11011010"; 
			when "0011"	=> selected_reg(23 downto 16) <= "11110010"; 
			when "0100"	=> selected_reg(23 downto 16) <= "01100110"; 
			when "0101"	=> selected_reg(23 downto 16) <= "10110110"; 
			when "0110"	=> selected_reg(23 downto 16) <= "10111110"; 
			when "0111"	=> selected_reg(23 downto 16) <= "11100000"; 
			when "1000"	=> selected_reg(23 downto 16) <= "11111110"; 
			when "1001"	=> selected_reg(23 downto 16) <= "11100110"; 
			when "1010"	=> selected_reg(23 downto 16) <= "11111010"; 
			when "1011"	=> selected_reg(23 downto 16) <= "00111110"; 
			when "1100"	=> selected_reg(23 downto 16) <= "00011010"; 
			when "1101"	=> selected_reg(23 downto 16) <= "01111010"; 
			when "1110"	=> selected_reg(23 downto 16) <= "11011110"; 
			when "1111"	=> selected_reg(23 downto 16) <= "10001110"; 
		end case;                                     

		case reg_node(7 downto 4) is
--											             "abcdefg-"
			when "0000"	=> selected_reg(15 downto 8) <= "11111100"; 
			when "0001"	=> selected_reg(15 downto 8) <= "01100000"; 
			when "0010"	=> selected_reg(15 downto 8) <= "11011010"; 
			when "0011"	=> selected_reg(15 downto 8) <= "11110010"; 
			when "0100"	=> selected_reg(15 downto 8) <= "01100110"; 
			when "0101"	=> selected_reg(15 downto 8) <= "10110110"; 
			when "0110"	=> selected_reg(15 downto 8) <= "10111110"; 
			when "0111"	=> selected_reg(15 downto 8) <= "11100000"; 
			when "1000"	=> selected_reg(15 downto 8) <= "11111110"; 
			when "1001"	=> selected_reg(15 downto 8) <= "11100110"; 
			when "1010"	=> selected_reg(15 downto 8) <= "11111010"; 
			when "1011"	=> selected_reg(15 downto 8) <= "00111110"; 
			when "1100"	=> selected_reg(15 downto 8) <= "00011010"; 
			when "1101"	=> selected_reg(15 downto 8) <= "01111010"; 
			when "1110"	=> selected_reg(15 downto 8) <= "11011110"; 
			when "1111"	=> selected_reg(15 downto 8) <= "10001110"; 
		end case;                                    

		case reg_node(3 downto 0) is
--											             "abcdefg-"
			when "0000"	=> selected_reg(7 downto 0) <= "11111100"; 
			when "0001"	=> selected_reg(7 downto 0) <= "01100000"; 
			when "0010"	=> selected_reg(7 downto 0) <= "11011010"; 
			when "0011"	=> selected_reg(7 downto 0) <= "11110010"; 
			when "0100"	=> selected_reg(7 downto 0) <= "01100110"; 
			when "0101"	=> selected_reg(7 downto 0) <= "10110110"; 
			when "0110"	=> selected_reg(7 downto 0) <= "10111110"; 
			when "0111"	=> selected_reg(7 downto 0) <= "11100000"; 
			when "1000"	=> selected_reg(7 downto 0) <= "11111110"; 
			when "1001"	=> selected_reg(7 downto 0) <= "11100110"; 
			when "1010"	=> selected_reg(7 downto 0) <= "11111010"; 
			when "1011"	=> selected_reg(7 downto 0) <= "00111110"; 
			when "1100"	=> selected_reg(7 downto 0) <= "00011010"; 
			when "1101"	=> selected_reg(7 downto 0) <= "01111010"; 
			when "1110"	=> selected_reg(7 downto 0) <= "11011110"; 
			when "1111"	=> selected_reg(7 downto 0) <= "10001110"; 
		end case;                                       
	END PROCESS;
END design;

