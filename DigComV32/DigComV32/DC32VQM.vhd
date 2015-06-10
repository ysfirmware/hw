LIBRARY ieee;
USE ieee.std_logic_1164.all;

package DC32VQM_package is
	component simplecom_ro1
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch 		: in	std_logic;
			fgo_sw, registerSelect_sw			: in	std_logic;
			keyIn						: in	std_logic_vector(15 downto 0);
			state_mode_led				: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2				: out	std_logic_vector(7 downto 0);
			selected_reg					: out	std_logic_vector(31 downto 0);
			register_led					: out	std_logic_vector(7 downto 0);
			address					: out	std_logic_vector(11 downto 0);
			M_clk						: out	std_logic;
			M_write						: out	std_logic;
			M_read						: out	std_logic;
			M_en						: out	std_logic;
			cb						: out	std_logic_vector(15 downto 0));
	end component;
end DC32VQM_package;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
USE work.DC32VQM_package.all;

ENTITY DC32VQM IS
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch	 	: in	std_logic;
			fgo_sw, registerSelect_sw			: in	std_logic;
			keyIn						: in	std_logic_vector(15 downto 0);
			state_mode_led				: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2				: out	std_logic_vector(7 downto 0);
			selected_reg					: out	std_logic_vector(31 downto 0);
			register_led					: out	std_logic_vector(7 downto 0);
			address					: out	std_logic_vector(11 downto 0);
			M_clk						: out	std_logic;
			M_write						: out	std_logic;
			M_read						: out	std_logic;
			M_en						: out	std_logic;
			cb						: out	std_logic_vector(15 downto 0));
END DC32VQM;

ARCHITECTURE design OF DC32VQM IS
	component simplecom_ro1
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch 		: in	std_logic;
			fgo_sw, registerSelect_sw			: in	std_logic;
			keyIn						: in	std_logic_vector(15 downto 0);
			state_mode_led				: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2				: out	std_logic_vector(7 downto 0);
			selected_reg					: out	std_logic_vector(31 downto 0);
			register_led					: out	std_logic_vector(7 downto 0);
			address					: out	std_logic_vector(11 downto 0);
			M_clk						: out	std_logic;
			M_write						: out	std_logic;
			M_read						: out	std_logic;
			M_en						: out	std_logic;
			cb						: out	std_logic_vector(15 downto 0));
	end component;
BEGIN
	DC_inst : simplecom_ro1 port map(clk => clk, reset_in => reset_in, 
			runMode => runMode, clockStepMode => clockStepMode,
			instructionStepMode => instructionStepMode, stepSwitch => stepSwitch,
			fgo_sw => fgo_sw, registerSelect_sw => registerSelect_sw,
			keyIn => keyIn, state_mode_led => state_mode_led, 
			fgi => fgi, fgo => fgo, ien => ien, r => r, i => i, s => s, e => e,
			segOut1 => segOut1, segOut2 => segOut2,
			selected_reg => selected_reg, register_led => register_led,
			address => address, M_clk => M_clk, M_write => M_write, 
			M_read => M_read, M_en => M_en, cb => cb);
end design;