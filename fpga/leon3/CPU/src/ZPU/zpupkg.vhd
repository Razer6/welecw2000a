library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library work;
use work.zpu_config.all;

package zpupkg is

	-- This bit is set for read/writes to IO
	-- FIX!!! eventually this should be set to wordSize-1 so as to
	-- to make the address of IO independent of amount of memory
	-- reserved for CPU. Requires trivial tweaks in toolchain/runtime
	-- libraries.
	
	constant byteBits			: integer := wordPower-3; -- # of bits in a word that addresses bytes
	constant maxAddrBit			: integer := maxAddrBitIncIO-1;
	constant ioBit				: integer := maxAddrBit+1;
	constant wordSize			: integer := 2**wordPower;
	constant wordBytes			: integer := wordSize/8;
	constant minAddrBit			: integer := byteBits;
	-- configurable internal stack size. Probably going to be 16 after toolchain is done
	constant	stack_bits		: integer := 5; 
	constant	stack_size		: integer := 2**stack_bits; 


	
	component trace is
	  port(
	       	clk         : in std_logic;
	       	begin_inst  : in std_logic;
	       	pc          : in std_logic_vector(maxAddrBitIncIO downto 0);
			opcode		: in std_logic_vector(7 downto 0);
			sp			: in std_logic_vector(maxAddrBitIncIO downto minAddrBit);
			memA		: in std_logic_vector(wordSize-1 downto 0);
			memB		: in std_logic_vector(wordSize-1 downto 0);
			busy         : in std_logic;
			intSp		: in std_logic_vector(stack_bits-1 downto 0)
			);
	end component;

	component zpu_core is
    port ( clk : in std_logic;
	 		  areset : in std_logic;
	 		  enable : in std_logic; 
	 		  in_mem_busy : in std_logic; 
	 		  mem_read : in std_logic_vector(wordSize-1 downto 0);
	 		  mem_write : out std_logic_vector(wordSize-1 downto 0);
			  out_mem_addr : out std_logic_vector(maxAddrBitIncIO downto 0);
			  out_mem_writeEnable : out std_logic; 
			  out_mem_readEnable : out std_logic;
	 		  mem_writeMask: out std_logic_vector(wordBytes-1 downto 0);
	 		  interrupt : in std_logic;
	 		  break : out std_logic);
	end component;


	
	component timer is
	  port(
	       clk              : in std_logic;
			 areset				: in std_logic;
			 we					: in std_logic;
			 din					: in std_logic_vector(7 downto 0);
			 adr					: in std_logic_vector(2 downto 0);
			 dout					: out std_logic_vector(7 downto 0));
	end component;

	component  zpuio is
		port (	areset			: in std_logic;
				cpu_clk			: in std_logic;
				clk_status		: in std_logic_vector(2 downto 0);
				cpu_din			: in std_logic_vector(15 downto 0);
				cpu_a			: in std_logic_vector(20 downto 0);
				cpu_we			: in std_logic_vector(1 downto 0);
				cpu_re			: in std_logic;
				cpu_dout		: inout std_logic_vector(15 downto 0));
	end component;



	
	-- opcode decode constants
	constant	OpCode_Im		: std_logic_vector(7 downto 7) := "1";
	constant	OpCode_StoreSP	: std_logic_vector(7 downto 5) := "010";
	constant	OpCode_LoadSP	: std_logic_vector(7 downto 5) := "011";
	constant	OpCode_Emulate	: std_logic_vector(7 downto 5) := "001";
	constant	OpCode_AddSP	: std_logic_vector(7 downto 4) := "0001";
	constant	OpCode_Short	: std_logic_vector(7 downto 4) := "0000";
	
	constant	OpCode_Break	: std_logic_vector(3 downto 0) := "0000";
	constant	OpCode_Shiftleft: std_logic_vector(3 downto 0) := "0001";
	constant	OpCode_PushSP	: std_logic_vector(3 downto 0) := "0010";
	constant	OpCode_PushInt	: std_logic_vector(3 downto 0) := "0011";
	
	constant	OpCode_PopPC	: std_logic_vector(3 downto 0) := "0100";
	constant	OpCode_Add		: std_logic_vector(3 downto 0) := "0101";
	constant	OpCode_And		: std_logic_vector(3 downto 0) := "0110";
	constant	OpCode_Or		: std_logic_vector(3 downto 0) := "0111";
	
	constant	OpCode_Load		: std_logic_vector(3 downto 0) := "1000";
	constant	OpCode_Not		: std_logic_vector(3 downto 0) := "1001";
	constant	OpCode_Flip		: std_logic_vector(3 downto 0) := "1010";
	constant	OpCode_Nop		: std_logic_vector(3 downto 0) := "1011";
	
	constant	OpCode_Store	: std_logic_vector(3 downto 0) := "1100";
	constant	OpCode_PopSP	: std_logic_vector(3 downto 0) := "1101";
	constant	OpCode_Compare	: std_logic_vector(3 downto 0) := "1110";
	constant	OpCode_PopInt	: std_logic_vector(3 downto 0) := "1111";
	
	constant	OpCode_Lessthan				: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(36, 6));
	constant	OpCode_Lessthanorequal		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(37, 6));
	constant	OpCode_Ulessthan			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(38, 6));
	constant	OpCode_Ulessthanorequal		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(39, 6));

	constant	OpCode_Swap					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(40, 6));
	constant	OpCode_Mult					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(41, 6));
	
	constant	OpCode_Lshiftright			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(42, 6));
	constant	OpCode_Ashiftleft			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(43, 6));
	constant	OpCode_Ashiftright			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(44, 6));
	constant	OpCode_Call					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(45, 6));

	constant	OpCode_Eq					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(46, 6));
	constant	OpCode_Neq					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(47, 6));

	constant	OpCode_Sub					: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(49, 6));
	constant	OpCode_Loadb				: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(51, 6));
	constant	OpCode_Storeb				: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(52, 6));

	constant	OpCode_Eqbranch				: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(55, 6));
	constant	OpCode_Neqbranch			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(56, 6));
	constant	OpCode_Poppcrel				: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(57, 6));

	constant	OpCode_Pushspadd			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(61, 6));
	constant	OpCode_Mult16x16			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(62, 6));
	constant	OpCode_Callpcrel			: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(63, 6));
	


	constant OpCode_Size		: integer := 8;


		
end zpupkg;
