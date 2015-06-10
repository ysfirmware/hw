library ieee;
use ieee.std_logic_1164.all;

entity bidirBus is
	port(	io1		: inout std_logic;
			input	: in	std_logic;
			output	: out	std_logic;
			ctrl	: in std_logic);
end bidirBus;

architecture design of bidirBus is
	signal outbuf : std_logic;
begin
	process(input, ctrl, outbuf, io1)
	begin
		outbuf <= input;
		if ctrl = '1' then	-- output
			io1 <= outbuf;
		else				-- input
			io1 <= 'Z';
			output <= io1;
		end if;
	end process;
end design;
