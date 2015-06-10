library ieee;
use ieee.std_logic_1164.ALL;

library work;
use work.UserLogic.all;

entity StructCarAlarm is    
    port(	Door, Ignition, SeatBelt	: in std_logic;
			Alarm						: out std_logic);
end StructCarAlarm;

architecture design of StructCarAlarm is
	signal DoorOpened, NoSeatBelt, Node1, Node2	: std_logic;
begin 
-- Statements to interconnect declared components
	U0: NOT11 port map (Door, DoorOpened);
	U1: NOT11 port map (SeatBelt, NoSeatBelt);
	U2: AND21 port map (Ignition, DoorOpened , Node1);
	U3: AND21 port map (Ignition, NoSeatBelt, Node2);
	U4: OR21 port map (Node1, Node2, Alarm);
end design;

library ieee;
use ieee.std_logic_1164.ALL;
package UserLogic is
-- Component declarations
	component AND21
		port (	in1, in2	: in std_logic;
				out1		: out std_logic);
	end component;

	component OR21
		port (	in1, in2	: in std_logic;
				out1		: out std_logic);
	end component;

	component NOT11
		port (	in1			: in std_logic;
				out1		: out std_logic);
	end component;
end UserLogic;	
	
library ieee;
use ieee.std_logic_1164.ALL;

entity AND21 is
	port (	in1, in2	: in std_logic;
			out1		: out std_logic);
	end AND21;
 
architecture behavioral of AND21 is
begin
		out1 <= in1 and in2;
end behavioral;

library ieee;
use ieee.std_logic_1164.ALL;

entity OR21 is
	port (	in1, in2	: in std_logic;
			out1		: out std_logic);
	end OR21;
 
architecture behavioral of OR21 is
begin
		out1 <= in1 or in2;
end behavioral;

library ieee;
use ieee.std_logic_1164.ALL;

entity NOT11 is
	port (	in1			: in std_logic;
			out1		: out std_logic);
	end NOT11;
 
architecture behavioral of NOT11 is
begin
		out1 <= not in1;
end behavioral;

	
