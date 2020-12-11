-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      qspi.vhd - 
--
--      Copyright(c) SLAC 2000
--
--      Author: Jeff Olsen
--      Created on: 10/24/2006 12:23:13 PM
--      Last change: JO 10/26/2006 4:15:31 PM
--
-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      qspi.vhd - 
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 08/03/06

--
-- 
-- Created by Jeff Olsen 08/23/05
--
--  Filename: qspi.vhd
--
--  Function:
--  Implement QSPI protocol for BPM
--
--  Modifications:



--Library work;
--use work.pac.all;

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity qspi is
Port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;

-- External interface
	Din			: in std_logic;
	Dout			: out std_logic;
	Cs				: in std_logic;

        
	Write_Strb	: out std_logic;
	DataOut		: out std_logic_vector(15 downto 0);
	Address		: out std_logic_vector(7 downto 0);
	En				: out std_logic;
	DataIn		: in std_logic_vector(7 downto 0)
	);
end qspi ;

Architecture Behaviour of qspi is

type QSPI_State_t is
	(
	Idle,
	CMDIn,
	Read,
	Read1,
	Write
	);

signal QSPI_State : QSPI_State_t;

signal CMDSR 		: std_logic_vector(7 downto 0);
signal DataOutSR 	: std_logic_vector(7 downto 0);
signal DataInSr   : std_logic_vector(7 downto 0);
signal Counter 	: std_logic_vector(3 downto 0);
signal iRead 		: std_logic;
signal DoutEn 		: std_logic;
signal iDoutEn 	: std_logic;
signal Load 		: std_logic;
signal iDout 		: std_logic;
Begin	
	
Douten_p: process(Clock)
Begin
if (Clock'event and Clock = '0') then
		iDoutEn <= DoutEn;
end if;
end process;	

Dout_p: process(Din, iDouten, iDout)
begin
if(iDoutEn = '0') then
	Dout <= Din;
else
   Dout <= iDout;
end if;
end Process;	
	
iDout_p: Process(clock, reset)
begin
If (Reset = '1') then
	iDout <= '0';
elsif (Clock'event and Clock = '0') then	
	If (Load = '1') then
		iDout <= DataIn(7);
	else
		iDout <= DataOutSR(7); 
	end if;
end if;
end process; -- Dout_p

QSPI: Process(Reset, Clock)
Begin 
If (Reset = '1') then
	Counter 		<= (Others => '0');
	CmdSr 		<= (Others => '0');
	DataOutSr 	<= (others => '0');
	DataInSr 	<= (others => '0');
	Write_Strb 	<= '0';
	En 			<= '0';
	DoutEn 		<= '0';
	iRead 		<= '0';
	Load 			<= '0';
elsif (Clock'event and Clock = '1') then
Case QSPI_State is
When Idle =>
	DoutEn 			<= '0';
	Load 				<= '0';
	Write_Strb 		<= '0';
	If (CS = '1') then
		EN	 			<= '1';
		Counter 		<= x"6";
		QSPI_State 	<= CMDIn;
		CmdSR(7 downto 0)  	<= CmdSR(6 downto 0) & DIn;
	else
	   En 			<= '0';
	   iRead 		<= '0';
		QSPI_State 	<= Idle;
	end if;
	
When CMDIn =>
	Write_Strb 		<= '0';
	CmdSR(7 downto 0)  	<= CmdSR(6 downto 0) & DIn;

	If (Counter = x"0") then
		Address 		<= CmdSr(6 downto 0) & Din;
		Counter 		<= x"7";
		QSPI_State 	<= Read1;
		Load 			<= '1';   
		DoutEn 		<= '1';
		if (CmdSR(5) = '1') then			
         iRead 	<= '1';
		else
			iRead 	<= '0';
		end if;
	else
		Counter 		<= Counter -1;
		QSPI_State 	<= CMDIn;
	end if;

When Read1 =>
    DataInSr <= DataInSr(6 downto 0) & Din;
	Counter 		<= Counter -1;
	Write_Strb 	<= '0';
	DataOutSR(7 downto 0)  <= DataIn(6 downto 0) & '0';
	Counter 		<= Counter -1;
	Load 			<= '0';
	QSPI_State 	<= Read;

	
When Read =>
   DataInSr <= DataInSr(6 downto 0) & Din;
	Counter 		<= Counter -1;
	Load 			<= '0';
	DataOutSR(7 downto 0)  <= DataOutSR(6 downto 0) & '0';
	If (Counter = x"0") then
		if (iRead = '0') then
		  Write_Strb <= '1';
		end if;
		DataOut <= DataInSR(6 downto 0) & Din;
		DoutEn 			<= '0';
		QSPI_State 	<= Idle;
	else
		QSPI_State 	<= Read;
	end if;
		
When Others =>		
	En 			<= '0';
	Write_Strb 	<= '0';
	QSPI_State 	<= Idle;
	
end Case;
end if;
end process; --QSPI

end Behaviour;