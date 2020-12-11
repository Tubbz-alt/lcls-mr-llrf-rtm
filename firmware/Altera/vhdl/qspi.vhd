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
--      Last change: JO 7/18/2016 4:06:44 PM
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
	DataIn		: in std_logic_vector(15 downto 0)
	);
end qspi ;

Architecture Behaviour of qspi is

type QSPI_State_t is
	(
	Idle,
	CMDIn,
	Readt,
	Read1,
	Writet
	);

signal QSPI_State : QSPI_State_t;

signal DataOutSR 	: std_logic_vector(15 downto 0);
signal DInSr   	: std_logic_vector(15 downto 0);
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
		iDout <= DataIn(15);
	else
		iDout <= DataOutSR(15); 
	end if;
end if;
end process; -- Dout_p

QSPI: Process(Reset, Clock, cs)
Begin 
If ((Reset = '1') or (cs = '0'))then
	Counter 		<= (Others => '0');
	DataOutSr 	<= (others => '0');
	DInSr 		<= (others => '0');
	DataOut	 	<= (others => '0');
	Address	 	<= (others => '0');
	Write_Strb 	<= '0';
	En 			<= '0';
	DoutEn 		<= '0';
	iRead 		<= '0';
	Load 			<= '0';
elsif (Clock'event and Clock = '1') then
Case QSPI_State is
When Idle =>
	DoutEn 		<= '0';
	Load 			<= '0';
	Write_Strb 	<= '0';
	If (Din = '1') then
		iRead 				<= Din;
		EN	 					<= '1';
		DInSr(7 downto 0) <= DInSr(6 downto 0) & DIn;
		Counter 				<= x"6";
		QSPI_State 			<= CMDIn;
	else
		En 					<= '0';
		iRead 				<= '0';
		QSPI_State 			<= Idle;
	end if;
	
When CMDIn =>
	Write_Strb 				<= '0';
	DInSr(7 downto 0)  	<= DInSr(6 downto 0) & DIn;
	If (Counter = x"0") then
		Address 		<= '0' & DInSr(5 downto 0) & Din;
		Counter 		<= x"F";
		QSPI_State 	<= Read1;
		Load 			<= '1';   
		DoutEn 		<= '1';
	else
		Counter 		<= Counter -1;
		QSPI_State 	<= CMDIn;
	end if;

When Read1 =>
   DInSr 						<= DInSr(14 downto 0) & Din;
	Counter 						<= Counter -1;
	Write_Strb 					<= '0';
	Load 							<= '0';
	DataOutSR(15 downto 0)  <= DataIn(14 downto 0) & '0';
	QSPI_State 					<= Readt;
	
When Readt =>
   DInSr 						<= DInSr(14 downto 0) & Din;
	DataOutSR(15 downto 0)  <= DataOutSR(14 downto 0) & '0';
	Counter 						<= Counter -1;
	Load 							<= '0';
	If (Counter = x"0") then
	    DataOut <= DInSr(14 downto 0) & Din;
	    if (iRead = '0') then
	        Write_Strb <= '1';
	    end if;
		DoutEn 		<= '0';
		QSPI_State 	<= Idle;
	else
		QSPI_State 	<= Readt;
	end if;
		
When Others =>		
	En 			<= '0';
	Write_Strb 	<= '0';
	QSPI_State 	<= Idle;
	
end Case;
end if;
end process; --QSPI

end Behaviour;