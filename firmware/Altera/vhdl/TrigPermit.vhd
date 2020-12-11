-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  TrigPermit.vhd -
--
--  Copyright(c) Stanford Linear Accelerator Center 2000
--
--  Author: JEFF OLSEN
--  Created on: 12/2011
--  Last change: JO 11/21/2016 3:12:37 PM
--
--

-- Hold off triggers for 1 sec if there is a fault
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;


entity TrigPermit is
port (

	Clock				: in std_logic;
	Clk10HzEn			: in std_logic;
	Reset					: in std_logic;
	Trigger				: in std_logic;

	Fault					: in std_logic;

	ModTrigger			: out std_logic;
	TriggerPermit		: out std_logic

);
end TrigPermit;


architecture Behaviour of TrigPermit is

signal PermitCntr 		: std_logic_vector(7 downto 0);
signal StndByTrigSr		: std_logic_vector(2 downto 0);
signal iTriggerPermit	: std_logic;
signal iFault				: std_logic;
begin

ModTrigger 		<= Trigger when iTriggerPermit = '1' else	'0';
TriggerPermit	<= iTriggerPermit;

sycn_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iFault <= '0';
elsif (Clock'event and Clock = '1') then
	iFault <= Fault;
end if;
end process;

Inh_p : process(Clock, Reset, iFault)
begin
if ((Reset = '1') or (iFault = '1')) then
	PermitCntr 		<= (Others => '0');
	iTriggerPermit	<= '0';
elsif (Clock'event and Clock = '1') then
	if (PermitCntr = x"9") then
			iTriggerPermit <= '1';
	end if;
	if (Clk10HzEn = '1') then
		if (PermitCntr /= x"9") then
			PermitCntr 		<= PermitCntr + 1;
			iTriggerPermit <= '0';
		end if;
	end if;
end if;
end process; -- Inh_p

end behaviour;
