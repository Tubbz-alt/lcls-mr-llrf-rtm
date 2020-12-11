-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	QSPIDrvr.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 5/4/2012 9:30:41 AM
--	Last change: JO 5/4/2012 9:45:10 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:38:56 03/05/2012 
-- Design Name: 
-- Module Name:    QSPIDrvr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity QSPIDrvr is
Port ( 
	clock 	: in std_logic;
	reset 	: in std_logic;
	Ain 		: in std_logic_vector(7 downto 0);
	Din 		: in std_logic_vector(7 downto 0);
	Start 	: in std_logic;
	RdEn		: in std_logic;
	Cs 		: out std_logic;
	SClk 		: out std_logic;
	SDout 	: out std_logic;
	SDin 		: in  std_logic;
	AOut 		: out std_logic_vector(7 downto 0);
	DOut 		: out std_logic_vector(7 downto 0)
);
end QSPIDrvr;

architecture Behavioral of QSPIDrvr is

signal DOutSr 		: std_logic_vector(15 downto 0); 
signal DInSr 		: std_logic_vector(15 downto 0); 
signal BitCntr  	: std_logic_vector(3 downto 0);  
signal iSclk		: std_logic;  


type Sio_t is
(
	Idle_s,
	Start_s,
	Shift_s,
	ClkToggle_s,
	Term_s
);

signal SIO_State : Sio_t;

begin

SDout <= DoutSr(15);
SClk	<= iSclk;

Sio_p : process(Clock, reset)
begin
if (Reset = '1') then
	DOutSr 	<= (Others => '0');
	DInSr		<= (Others => '0');
	iSclk		<= '0';
	Cs			<= '0';
elsif (Clock'event and Clock = '1') then
	case SIO_State is
	when Idle_s =>
		BitCntr	<= x"F";
		Cs			<= '0';
		if (Start = '1') then
			DoutSr 		<= '1' & RdEn & Ain(5 downto 0) & Din;
			Cs 			<= '1';
			SIO_State	<= Start_s;
		else
			iSclk			<= '0';
			SIO_State 	<= Idle_s;
		end if;
		
	when Start_s =>
		iSClk 		<= not(iSclk);
		SIO_State	<= Shift_s;
		
	when Shift_s =>
		iSclk			<= not(iSclk);
		BitCntr 		<= BitCntr - 1;
		DoutSr 		<= DOutSr(14 downto 0) & '0';
		DinSr			<= DinSr(14 downto 0) & SDin;
		if (BitCntr = x"0") then
			Cs				<= '0';
			SIO_State 	<= Term_s;
		else
			SIO_State 	<= ClkToggle_s;
		end if;
	
	when ClkToggle_s =>
		iSclk			<= not(iSclk);
		SIO_State 	<= Shift_s;
		
	when Term_s =>
		AOut 			<= "00" & DinSr(13 downto 8);
		DOut			<= DinSr(7 downto 0);
		SIO_State 	<= Idle_s;
		
	
	when others =>
	end case;
end if;
end process;
			
end Behavioral;

