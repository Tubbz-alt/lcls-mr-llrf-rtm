-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  FastFaultInterface.vhd -
--
--  Copyright(c) Stanford Linear Accelerator Center 2000
--
--  Author: JEFF OLSEN
--
--  Last change: JO 7/14/2016 4:51:46 PM
--
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FastFaultInterface is
  port (

	Clock				: in std_logic;
	Reset				: in std_logic;
	ClrFault 		: in std_logic;
	BeamUnderEn		: in std_logic;

-- Fast Signal Comparator inputs
	Beam_I_Under 	: in std_logic;
	Beam_I_Over		: in std_logic;
	Beam_V_Over		: in std_logic;
	Fwd_Over			: in std_logic;
	Refl_Over		: in std_logic;

	FaultVectorOut	: out std_logic_vector(4 downto 0);
	FaultOut 		: out std_logic

    );
end FastFaultInterface;


architecture Behaviour of FastFaultInterface is

signal FastFaultVector		: std_logic_vector(4 downto 0);
signal iFaultVectorOut		: std_logic_vector(4 downto 0);
signal DbFastFaultVector	: std_logic_vector(4 downto 0);
signal iFaultOut				: std_Logic;
signal BeamUnderI				: std_Logic;
signal BeamUnder				: std_Logic;
signal BeamUnderCntr			: std_logic_vector(11 downto 0);

begin

FastFaultVector 	<= Beam_I_Under & Beam_I_Over & Beam_V_Over & Fwd_Over & Refl_Over;
FaultOut				<= iFaultOut;
FaultVectorOut		<= iFaultVectorOut;
BeamUnderI			<= DbFastFaultVector(4);


latchFastFaults : for i in 0 to 4 generate
DeBounce : entity work.DeBouncer
port map (
    Clock     	=> Clock,
    Reset	   => Reset,
	 ClkEn		=> '1',
	 Input		=> FastFaultVector(i),
    DbOut 		=> DbFastFaultVector(i)
	);
end generate;

Fault_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iFaultOut 			<= '0';
	iFaultVectorOut(4 downto 0)	<= (Others => '0');
	BeamUnderCntr 		<= (Others => '0');
	BeamUnder			<= '0';
elsif (Clock'event and Clock = '1') then
	if ((DbFastFaultVector(3 downto 0) /= "0000") or (BeamUnder = '1')) then
		if (iFaultOut = '0') then
			iFaultOut 			<= '1';
			iFaultVectorOut(4 downto 0)  	<= iFaultVectorOut(4 downto 0) OR  (BeamUnder & DbFastFaultVector(3 downto 0));
		end if;
	elsif (ClrFault = '1') then
		iFaultVectorOut(4 downto 0) 	<= (Others => '0');
		iFaultOut 			<= '0';
	end if;
	
	if ((BeamUnderI = '0') or (ClrFault = '1'))then
		BeamUnderCntr 	<= (Others => '0');
		BeamUnder		<= '0';
	elsif (BeamUnderEn = '1') then
		if (BeamUnderCntr = x"7D0") then
			BeamUnder 		<= '1';
		else
			BeamUnderCntr 	<= BeamUnderCntr + 1;
		end if;
	end if;
end if;
end process;

end behaviour;