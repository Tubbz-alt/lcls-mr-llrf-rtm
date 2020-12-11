-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  RegIntf.vhd -
--
--  Copyright(c) Stanford Linear Accelerator Center 2000
--
--  Author: JEFF OLSEN
--  Created on: 8/4/2006 9:52:00 AM
--  Last change: JO 7/21/2016 8:49:14 AM
--


Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity RegIntf is
Port (
	Clock 				: in std_logic;
	Reset 				: in std_logic;
	Address				: in std_logic_vector(7 downto 0);
	Write_Strb			: in std_logic;
	ClearStats			: out std_logic;
	DataIn				: in std_logic_vector(15 downto 0);
	DataOut				: out std_logic_vector(15 downto 0);
	SLEDStatus			: in std_logic_vector(8 downto 0);
	FastFaultStatus 	: in std_logic_vector(4 downto 0);
	ModulatorFault 	: in std_logic;
	RFOn					: in std_logic
	);
end RegIntf ;

Architecture Behaviour of RegIntf is


Begin

WriteReg_p: process(Clock, Reset)
begin
if (Reset = '1') then
	ClearStats <= '0';
elsif (Clock'event and Clock = '1') then
	ClearStats <= '0';
	if (Write_Strb = '1') then
		case Address is
		when x"00" =>
			ClearStats <= '1';
		when others =>
		end case;
  end if;
end if;
end process;

ReadReg_p: process(Address, SLEDStatus, ModulatorFault, FastFaultStatus, RFon)
Begin
	Case Address is
	when x"00" =>
		DataOut <= RFOn & SLEDStatus & ModulatorFault & FastFaultStatus;
	When Others =>
		DataOut <= (Others => '0');
	end case;

end process; --ReadReg_p

end Behaviour;




