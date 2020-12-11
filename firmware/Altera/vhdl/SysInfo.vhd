-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	SysInfo.vhd -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/11/2011 12:08:09 PM
--	Last change: JO 11/21/2016 3:10:53 PM
--

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library work;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--


entity SysInfo is
Port (
	Clock						: in std_logic;
	Reset						: in std_logic;

	LittleEndian			: in std_logic;
	Lnk_Addr		 			: in std_logic_vector(7 downto 0);			-- From Link Interface
	Reg_DataOut				: out std_logic_vector(15 downto 0)

);

end SysInfo;

architecture behaviour of SysInfo is

	constant Version				: std_logic_vector(15 downto 0)	:= x"0006";
	constant System_ID			: string(8 downto 1) 				:= "LLRF    ";
	constant SubType_ID			: string(8 downto 1) 				:= "INTLKRTM";
	constant Date_ID				: string(8 downto 1) 				:= "12/07/16";

	function Character_to_StdLogicVector(MyString : in character) return std_logic_vector;

function Character_to_StdLogicVector(MyString : in character ) return  std_logic_vector is
variable Test1 : std_logic_vector(7 downto 0);
begin
case MyString is
	when '0' => Test1 := x"30";
	when '1' => Test1 := x"31";
	when '2' => Test1 := x"32";
	when '3' => Test1 := x"33";
	when '4' => Test1 := x"34";
	when '5' => Test1 := x"35";
	when '6' => Test1 := x"36";
	when '7' => Test1 := x"37";
	when '8' => Test1 := x"38";
	when '9' => Test1 := x"39";
	
	when 'a' => Test1 := x"61";
	when 'b' => Test1 := x"62";
	when 'c' => Test1 := x"63";
	when 'd' => Test1 := x"64";
	when 'e' => Test1 := x"65";
	when 'f' => Test1 := x"66";
	when 'g' => Test1 := x"67";
	when 'h' => Test1 := x"68";
	when 'i' => Test1 := x"69";
	when 'j' => Test1 := x"6A";
	when 'k' => Test1 := x"6B";
	when 'l' => Test1 := x"6C";
	when 'm' => Test1 := x"6D";
	when 'n' => Test1 := x"6E";
	when 'o' => Test1 := x"6F";
	when 'p' => Test1 := x"70";
	when 'q' => Test1 := x"71";
	when 'r' => Test1 := x"72";
	when 's' => Test1 := x"73";
	when 't' => Test1 := x"74";
	when 'u' => Test1 := x"75";
	when 'v' => Test1 := x"76";
	when 'w' => Test1 := x"77";
	when 'x' => Test1 := x"78";
	when 'y' => Test1 := x"79";
	when 'z' => Test1 := x"7A";
	
	when 'A' => Test1 := x"41";
	when 'B' => Test1 := x"42";
	when 'C' => Test1 := x"43";
	when 'D' => Test1 := x"44";
	when 'E' => Test1 := x"45";
	when 'F' => Test1 := x"46";
	when 'G' => Test1 := x"47";
	when 'H' => Test1 := x"48";
	when 'I' => Test1 := x"49";
	when 'J' => Test1 := x"4A";
	when 'K' => Test1 := x"4B";
	when 'L' => Test1 := x"4C";
	when 'M' => Test1 := x"4D";
	when 'N' => Test1 := x"4E";
	when 'O' => Test1 := x"4F";
	when 'P' => Test1 := x"50";
	when 'Q' => Test1 := x"51";
	when 'R' => Test1 := x"52";
	when 'S' => Test1 := x"53";
	when 'T' => Test1 := x"54";
	when 'U' => Test1 := x"55";
	when 'V' => Test1 := x"56";
	when 'W' => Test1 := x"57";
	when 'X' => Test1 := x"58";
	when 'Y' => Test1 := x"59";
	when 'Z' => Test1 := x"5A";
	
	when ' ' => Test1 := x"20";
	when '-' => Test1 := x"2D";
	when '.' => Test1 := x"2E";
	when '/' => Test1 := x"2F";
	
	when others => Test1 := x"20";
end case;
	Return  Test1;
end Character_to_StdLogicVector;


begin


info_p : process(Lnk_Addr, LittleEndian)
begin
if (LittleEndian = '1') then
	Case Lnk_Addr(7 downto 0) is
	when x"01" =>
		Reg_DataOut <= Version;
		
	when x"02" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID( 7)) & Character_to_StdLogicVector(System_ID(8));
	when x"03" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID( 5)) & Character_to_StdLogicVector(System_ID(6));
	when x"04" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(3)) & Character_to_StdLogicVector(System_ID(4));
	when x"05" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(1)) & Character_to_StdLogicVector(System_ID(2));

	when x"06" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(7)) & Character_to_StdLogicVector(SubType_ID(8));
	when x"07" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(5)) & Character_to_StdLogicVector(SubType_ID(6));
	when x"08" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(3)) & Character_to_StdLogicVector(SubType_ID(4));
	when x"09" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(1)) & Character_to_StdLogicVector(SubType_ID(2));

	when x"0A" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(7)) & Character_to_StdLogicVector(Date_ID(8));
	when x"0B" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(5)) & Character_to_StdLogicVector(Date_ID(6));
	when x"0C" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(3)) & Character_to_StdLogicVector(Date_ID(4));
	when x"0D" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(1)) & Character_to_StdLogicVector(Date_ID(2));

	when others => Reg_DataOut	<= (Others => '0');
	end case;
else
	Case Lnk_Addr(7 downto 0) is
	when x"01" =>
		Reg_DataOut <= Version;
		
	when x"02" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(8)) & Character_to_StdLogicVector(System_ID(7));
	when x"03" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(6)) & Character_to_StdLogicVector(System_ID(5));
	when x"04" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(4)) & Character_to_StdLogicVector(System_ID(3));
	when x"05" =>
		Reg_DataOut <= Character_to_StdLogicVector(System_ID(2)) & Character_to_StdLogicVector(System_ID(1));

	when x"06" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(8)) & Character_to_StdLogicVector(SubType_ID(7));
	when x"07" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(6)) & Character_to_StdLogicVector(SubType_ID(5));
	when x"08" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(4)) & Character_to_StdLogicVector(SubType_ID(3));
	when x"09" =>
		Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(2)) & Character_to_StdLogicVector(SubType_ID(1));

	when x"0A" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(8)) & Character_to_StdLogicVector(Date_ID(7));
	when x"0B" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(6)) & Character_to_StdLogicVector(Date_ID(5));
	when x"0C" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(4)) & Character_to_StdLogicVector(Date_ID(3));
	when x"0D" =>
		Reg_DataOut <= Character_to_StdLogicVector(Date_ID(2)) & Character_to_StdLogicVector(Date_ID(1));

	when others => Reg_DataOut	<= (Others => '0');
	end case;
end if;
end process;


end;

