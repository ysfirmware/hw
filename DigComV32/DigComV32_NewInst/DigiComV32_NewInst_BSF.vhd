LIBRARY ieee;
USE ieee.std_logic_1164.all;

package DigiComV32_NewInst_package is
	component simplecom_ro1
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch 		: in	std_logic;
			sc_stop, ac_clr, sc_clr, ir_ld			: in	std_logic;
			inp_rd, tr_ld, outr_ld, c_and			: in	std_logic;
			ien_set, c_add, ien_clr, c_dr			: in	std_logic;
			ar_ld, c_inpr, ar_inr, c_com			: in	std_logic;
			fgo_sw, ar_clr, c_shr					: in	std_logic; 
			keyIn									: in	std_logic_vector(15 downto 0);
			pc_ld, c_shl, pc_inr, e_clr				: in	std_logic;
			pc_clr, e_cme, registerSelect_sw, dr_ld	: in	std_logic;
			x										: in	std_logic_vector(7 downto 1);
			dr_inr, decode_en, ac_ld, ac_inr		: in	std_logic;
			t										: out	std_logic_vector(6 downto 0);
			M_t										: out	std_logic_vector(6 downto 1);
			decode									: out	std_logic_vector(7 downto 0);
			ac_out, reg_dr							: out	std_logic_vector(15 downto 0);
			ir										: out	std_logic_vector(11 downto 0);
			clk2_out, inst_stop_out					: out	std_logic;
			state_mode_led							: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2						: out	std_logic_vector(7 downto 0);
			selected_reg							: out	std_logic_vector(31 downto 0);
			register_led							: out	std_logic_vector(7 downto 0);
			address									: out	std_logic_vector(11 downto 0);
			M_clk									: out	std_logic;
			cb										: out	std_logic_vector(15 downto 0));
	end component;
end DigiComV32_NewInst_package;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
USE work.DigiComV32_NewInst_package.all;

ENTITY DigiComV32_NewInst_BSF IS
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch 		: in	std_logic;
			sc_stop, ac_clr, sc_clr, ir_ld			: in	std_logic;
			inp_rd, tr_ld, outr_ld, c_and			: in	std_logic;
			ien_set, c_add, ien_clr, c_dr			: in	std_logic;
			ar_ld, c_inpr, ar_inr, c_com			: in	std_logic;
			fgo_sw, ar_clr, c_shr					: in	std_logic; 
			keyIn									: in	std_logic_vector(15 downto 0);
			pc_ld, c_shl, pc_inr, e_clr				: in	std_logic;
			pc_clr, e_cme, registerSelect_sw, dr_ld	: in	std_logic;
			x										: in	std_logic_vector(7 downto 1);
			dr_inr, decode_en, ac_ld, ac_inr		: in	std_logic;
			t										: out	std_logic_vector(6 downto 0);
			M_t										: out	std_logic_vector(6 downto 1);
			decode									: out	std_logic_vector(7 downto 0);
			ac_out, reg_dr							: out	std_logic_vector(15 downto 0);
			ir										: out	std_logic_vector(11 downto 0);
			clk2_out, inst_stop_out					: out	std_logic;
			state_mode_led							: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2						: out	std_logic_vector(7 downto 0);
			selected_reg							: out	std_logic_vector(31 downto 0);
			register_led							: out	std_logic_vector(7 downto 0);
			address									: out	std_logic_vector(11 downto 0);
			M_clk									: out	std_logic;
			cb										: out	std_logic_vector(15 downto 0);
			nRESET									: out	std_logic	-- test out
			
			
			);
END DigiComV32_NewInst_BSF;

ARCHITECTURE design OF DigiComV32_NewInst_BSF IS
	component simplecom_ro1
		port(
			clk, reset_in, runMode, clockStepMode 	: in	std_logic;
			instructionStepMode, stepSwitch 		: in	std_logic;
			sc_stop, ac_clr, sc_clr, ir_ld			: in	std_logic;
			inp_rd, tr_ld, outr_ld, c_and			: in	std_logic;
			ien_set, c_add, ien_clr, c_dr			: in	std_logic;
			ar_ld, c_inpr, ar_inr, c_com			: in	std_logic;
			fgo_sw, ar_clr, c_shr					: in	std_logic; 
			keyIn									: in	std_logic_vector(15 downto 0);
			pc_ld, c_shl, pc_inr, e_clr				: in	std_logic;
			pc_clr, e_cme, registerSelect_sw, dr_ld	: in	std_logic;
			x										: in	std_logic_vector(7 downto 1);
			dr_inr, decode_en, ac_ld, ac_inr		: in	std_logic;
			t										: out	std_logic_vector(6 downto 0);
			M_t										: out	std_logic_vector(6 downto 1);
			decode									: out	std_logic_vector(7 downto 0);
			ac_out, reg_dr							: out	std_logic_vector(15 downto 0);
			ir										: out	std_logic_vector(11 downto 0);
			clk2_out, inst_stop_out					: out	std_logic;
			state_mode_led							: out	std_logic_vector(2 downto 0);
			fgi, fgo, ien, r, i, s, e				: out	std_logic;
			segOut1, segOut2						: out	std_logic_vector(7 downto 0);
			selected_reg							: out	std_logic_vector(31 downto 0);
			register_led							: out	std_logic_vector(7 downto 0);
			address									: out	std_logic_vector(11 downto 0);
			M_clk									: out	std_logic;
			cb										: out	std_logic_vector(15 downto 0);
			nRESET									: out	std_logic	-- test out
			);
	end component;
	
BEGIN
	DC_inst : simplecom_ro1 port map
			(clk => clk, reset_in => reset_in, runMode => runMode, 
			clockStepMode => clockStepMode, instructionStepMode => instructionStepMode, 
			stepSwitch => stepSwitch, sc_stop => sc_stop, ac_clr => ac_clr, 
			sc_clr => sc_clr, ir_ld => ir_ld, inp_rd => inp_rd, tr_ld => tr_ld, 
			outr_ld => outr_ld, c_and => c_and, ien_set => ien_set, c_add => c_add, 
			ien_clr => ien_clr, c_dr => c_dr, ar_ld => ar_ld, c_inpr => c_inpr, 
			ar_inr => ar_inr, c_com => c_com, fgo_sw => fgo_sw, ar_clr => ar_clr, 
			c_shr => c_shr, keyIn => keyIn, pc_ld => pc_ld, c_shl => c_shl, 
			pc_inr => pc_inr, e_clr => e_clr, pc_clr => pc_clr, e_cme => e_cme, 
			registerSelect_sw => registerSelect_sw, dr_ld => dr_ld, x => x, 
			dr_inr => dr_inr, decode_en => decode_en, ac_ld => ac_ld, ac_inr => ac_inr, 
			t => t, M_t => M_t, decode => decode, 
			ac_out => ac_out, reg_dr => reg_dr, ir => ir, 
			clk2_out => clk2_out, inst_stop_out => inst_stop_out, 
			state_mode_led => state_mode_led, fgi => fgi, fgo => fgo, ien => ien, 
			r => r, i => i, s => s, e => e, segOut1 => segOut1, segOut2 => segOut2, 
			selected_reg => selected_reg, register_led => register_led, address => address, 
			M_clk => M_clk, cb => cb, nRESET => nRESET);
end design;	
	
	
