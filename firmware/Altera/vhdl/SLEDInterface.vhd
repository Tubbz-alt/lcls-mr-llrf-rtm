-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  SLEDInterface.vhd -
--
--  Copyright(c) Stanford Linear Accelerator Center 2000
--
--  Author: JEFF OLSEN
--  Created on: 12/2011
--  Last change: JPS 4/18/2018 2:37:17 PM
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SLEDInterface is
port (

    Clock				: in std_logic;
    DeBounceEn			: in std_logic;
	 TimeOutEn			: in std_logic;
	 Clk120HzEn    	: in std_logic;
	 Reset				: in std_logic;
	 ClrFault			: in std_logic;

-- SLED Interface Signals
    MotorNotDetuned	: in std_logic;
    MotorNotTuned		: in std_logic;
    LowerDetuned 		: in std_logic;
    LowerTuned   		: in std_logic;
    UpperTuned   		: in std_logic;
    UpperDetuned 		: in std_logic;

-- SLED Tune/Detune Request
    TuneReq				: in std_logic;
    DeTuneReq			: in std_logic;
	 SLED_AC_Out_P		: out std_logic;
	 SLED_AC_Out_M		: out std_logic;

-- Control Output
    Tune					: out std_logic;
    DeTune				: out std_logic;
	 SLEDStatusOut		: out std_logic_vector(8 downto 0);
	 SLEDFault			: out std_logic

);
end SLEDInterface;


architecture Behaviour of SLEDInterface is

-- SLED Interface Signals

	signal Tuning							: std_logic;
	signal DeTuning 						: std_logic;

	signal DbMotorNotDeTuned			: std_logic;
	signal DbMotorNotTuned				: std_logic;
	signal DbLowerDeTuned				: std_logic;
	signal DbLowerTuned 					: std_logic;
	signal DbUpperTuned 					: std_logic;
	signal DbUpperDeTuned 				: std_logic;
	
	signal SLEDStatusVectorIn			: std_logic_vector(5 downto 0);
	signal DbSLEDStatusVector			: std_logic_vector(5 downto 0);

	signal DbSLEDTuned					: std_logic;
	signal DbSLEDDeTuned					: std_logic;

	signal SLEDTimeOut					: std_logic;
	signal TimeOutCntr					: std_logic_vector(7 downto 0);

	signal TuneReqSr						: std_logic_vector(1 downto 0);
	signal DeTuneReqSr					: std_logic_vector(1 downto 0);

	signal iSLEDFault						: std_logic;
	signal iSLED_AC_Out_P				: std_logic;
	signal iSLED_AC_Out_M				: std_logic;
	
begin


SLEDStatusVectorIn		<=	LowerTuned			& UpperTuned	&
									MotorNotTuned		& LowerDeTuned	&
									UpperDeTuned		& MotorNotDeTuned;


DbLowerTuned			<= DbSLEDStatusVector(5);
DbUpperTuned			<= DbSLEDStatusVector(4);
DbMotorNotTuned		<= DbSLEDStatusVector(3);
DbLowerDeTuned 		<= DbSLEDStatusVector(2);
DbUpperDeTuned 		<= DbSLEDStatusVector(1);
DbMotorNotDeTuned 	<= DbSLEDStatusVector(0);

Tune						<= Tuning;
DeTune					<= DeTuning;


SLED_AC_Out_P	<= iSLED_AC_Out_P;
SLED_AC_Out_M 	<= iSLED_AC_Out_M;

GenAc_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iSLED_AC_Out_P	<= '0';
	iSLED_AC_Out_M	<= '0';
elsif (Clock'event and Clock = '1') then
-----------------------------------------------------------------------------------
----------------------------------------------- Use this code block for TESTING 10 VAC output
	if (Clk120HzEn = '1') then
			iSLED_AC_Out_P <= not(iSLED_AC_Out_P);
			iSLED_AC_Out_M	<= iSLED_AC_Out_P;
	end if;
-------------------------------------------------------------------------- 
-----------------------------------------------Use the code block below for OPERATION
------------------------------------------ original operational code (bug?)
--	if (Clk120HzEn = '1') then
--	if ((Tuning = '1') or (DeTuning = '1')) then
--			iSLED_AC_Out_P <= not(iSLED_AC_Out_P);
--			iSLED_AC_Out_M	<= iSLED_AC_Out_P;
--		end if;
--	else
--		iSLED_AC_Out_P	<= '0';
--		iSLED_AC_Out_M	<= iSLED_AC_Out_P;
--	end if;
----------------------------------------------
-------------------------------- Modified code for OPERATION -- John Sikora June 14, 2018
--
--	if (Clk120HzEn = '1') then
--		if ((Tuning = '1') or (DeTuning = '1')) then
--			iSLED_AC_Out_P <= not(iSLED_AC_Out_P);
--			iSLED_AC_Out_M	<= iSLED_AC_Out_P;
--		else
--			iSLED_AC_Out_P	<= '0';
--			iSLED_AC_Out_M	<= iSLED_AC_Out_P;
--		end if;
--	else
--
--	end if;
-----------------------------------------------
---------------------------------------------------------------------------------- 
end if;
end process;

latchSled : for i in 0 to 5 generate
DeBounce : entity work.DeBouncer
port map (
    Clock     	=> Clock,
    Reset   	=> Reset,
	 ClkEn		=> DeBounceEn,
	 Input		=> SLEDStatusVectorIn(i),
    DbOut 		=> DbSLEDStatusVector(i)
    );
end generate;

DbSLEDTuned		<=	 (DbLowerTuned				and
						  DbUpperTuned 			and
						  not(DbMotorNotTuned)	and
						  not(DbLowerDeTuned)	and
						  not(DbUpperDeTuned)	and
						  DbMotorNotDeTuned 	);

DbSLEDDeTuned	<=	 (not(DbLowerTuned)		and
						  not(DbUpperTuned) 		and
						  DbMotorNotTuned			and
						  DbLowerDeTuned			and
						  DbUpperDeTuned			and
						  not(DbMotorNotDeTuned));

SLEDFault <= iSLEDFault;

SLEDTo_p : process(Clock, Reset)
begin
if (Reset = '1') then
	TuneReqSr		<= (Others => '0');
	DeTuneReqSr		<= (Others => '0');
	TimeOutCntr		<= (Others => '0');
	iSLEDFault		<= '0';
	Tuning			<= '0';
	DeTuning			<= '0';
	SLEDStatusOut	<= (Others => '0');
	SLEDTimeOut 	<= '0';
elsif (Clock'event and Clock = '1') then

--------------Original code ---------------
	TuneReqSr		<= TuneReqSr(0)	& (TuneReq and NOT(DbSLEDTuned));
	DeTuneReqSr	<= DeTuneReqSr(0) & (DeTuneReq and Not(DbSLEDDeTuned));
	
	 
	 
	 
    if ((SLEDTimeOut = '1') or (DbSLEDTuned = '1') or (ClrFault = '1')) then
		  Tuning		<= '0';
    elsif (TuneReqSr = "01") then
		  Tuning		<= '1';
		  DeTuning	<= '0';
    end if;

	 if ((SLEDTimeOut = '1') or (DbSLEDDeTuned = '1') or (ClrFault = '1')) then
		  DeTuning	<= '0';
    elsif (DeTuneReqSr = "01") then
        Tuning		<= '0';
		  DeTuning	<= '1';
    end if;

	if ((Tuning = '1') or (DeTuning = '1')) then
		if (TimeOutEn = '1') then
			if (TimeOutCntr /= x"63") then
				TimeOutCntr <= TimeOutCntr + 1;
			else
				SLEDTimeOut <= '1';
			end if;
		end if;
	elsif (ClrFault = '1') then
		TimeOutCntr <= (Others => '0');
		SLEDTimeOut <= '0';
	end if;

-- Tuned   DeTuned    Fault
--	  0		  0			1
--   0        1         0
--   1        0         0
--   1        1         1
--


	if (((DbSLEDTuned = '0') and (DbSLEDDeTuned = '0')) OR
       ((DbSLEDTuned = '1') and (DbSLEDDeTuned = '1'))) then		 	
			iSLEDFault		<= '1';
			SLEDStatusOut	<= SLEDTimeOut & Tuning & DeTuning  & DbSLEDStatusVector;
	
	elsif (ClrFault = '1') then
		iSLEDFault		<= '0';
		SLEDStatusOut	<= SLEDTimeOut & Tuning & DeTuning & DbSLEDStatusVector;
	end if;
end if;

end process; --SLEDTo_p

end behaviour;
