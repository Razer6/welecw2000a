library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package zpu_config is
	-- generate trace output or not.
	constant	Generate_Trace		: boolean := false;
	constant wordPower			: integer := 5;
	-- during simulation, set this to '0' to get matching trace.txt 
	constant	DontCareValue		: std_logic := 'X';
	-- Clock frequency in MHz.
	constant	ZPU_Frequency		: std_logic_vector(7 downto 0) := x"7d";  -- 125 MHz
	-- This is the msb address bit. bytes=2^(maxAddrBitIncIO+1)
	constant 	maxAddrBitIncIO		: integer := 31;
    
    constant spStart :  std_logic_vector(31 downto 0) := X"00010000";
	
end zpu_config;
