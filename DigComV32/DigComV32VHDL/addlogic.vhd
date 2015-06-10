-- ALU Logic
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY addlogic IS
	PORT
	(
		nRESET								: in	std_logic;
		clk, clk2							: in	std_logic;
		
		c_and, c_add, c_dr,
		c_inpr, c_com, c_shr, 
		c_shl, e_clr, e_cme					: in	std_logic;
		
		ac, dr								: in	std_logic_vector(15 downto 0);
		inpr								: in 	std_logic_vector(7 downto 0);
		
		e_out								: out 	std_logic;
		ac_out								: out	std_logic_vector(15 downto 0)
	);
END addlogic;

ARCHITECTURE addlogic_arch of addlogic IS
	signal		e, e2						: std_logic;
	signal		k							: std_logic_vector(8 downto 0);
BEGIN
	k <= c_dr & c_com & c_and & c_add & c_inpr & c_shr & c_shl & e_clr & e_cme;
	
	PROCESS (k, nRESET, clk2)
	BEGIN
		if nRESET = '0' then
			e <= '0';
		elsif falling_edge(clk2) then
			case k is 
				when "000100000" =>		-- add
					e <= conv_std_logic_vector(conv_integer(ac) + conv_integer(dr), 17)(16);
				when "000001000" =>		-- shr
					e <= ac(0);
				when "000000100" =>		-- shl
					e <= ac(15);
				when "000000010" =>		-- cle
					e <= '0';
				when "000000001" =>		-- cme
					e <= not e2;
				when others => null;
			end case;	
		end if;	
	end process;
	e_out <= e;

	PROCESS (nRESET, clk)
	BEGIN
		if nRESET = '0' then
			e2 <= '0';
		elsif rising_edge(clk) then		-- register instance
			e2 <= e;
		end if;
	end process;

	PROCESS(k, dr, ac, inpr, e2)
	BEGIN
		case k is 
			when "100000000" =>				-- c_dr
				ac_out <= dr;
			when "010000000" =>				-- c_com
				ac_out <= not ac;
			when "001000000" =>				-- c_and
				ac_out <= ac and dr;
			when "000100000" =>				-- c_add
				ac_out <= conv_std_logic_vector(conv_integer(ac) + conv_integer(dr), 17)(15 downto 0);
			when "000010000" =>				-- c_inpr
				ac_out(7 downto 0) <= inpr;
				ac_out(15 downto 8) <= "00000000";
			when "000001000" =>
				ac_out(14 downto 0) <= ac(15 downto 1);
				ac_out(15) <= e2;
			when "000000100" =>
				ac_out(15 downto 1) <= ac(14 downto 0);
				ac_out(0) <= e2;
			when others => 
				ac_out <= "0000000000000000";
		end case;	
	end process;
END addlogic_arch;