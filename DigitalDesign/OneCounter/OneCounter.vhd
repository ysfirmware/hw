library ieee;
use ieee.std_logic_1164.all;

entity OneCounter is
	port(	d 	: in std_logic_vector(7 downto 0);
			seg	: out std_logic_vector(6 downto 0));
end OneCounter;

architecture design of OneCounter is
begin
	process(d)
		variable oneCount : integer;
    begin
		oneCount := 0;
		for i in d'range loop
			if d(i) = '1' then
				oneCount := oneCount + 1;
			end if;
		end loop;
		
		case oneCount is
--					     	  "abcdefg-"
			when 0	=> seg <= "1111110"; 
			when 1	=> seg <= "0110000"; 
			when 2	=> seg <= "1101101"; 
			when 3	=> seg <= "1111001"; 
			when 4	=> seg <= "0110011"; 
			when 5	=> seg <= "1011011"; 
			when 6	=> seg <= "1011111"; 
			when 7	=> seg <= "1110000"; 
			when 8	=> seg <= "1111111"; 
			when others => seg <= "0000000"; 
		end case;
    end process;
end design;
