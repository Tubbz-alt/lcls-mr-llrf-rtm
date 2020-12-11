-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  RFInterlockRTM_a.vhd -
--
--  Copyright(c) Stanford Linear Accelerator Center 2000
--
--  Author: JEFF OLSEN
--  Created on: 12/2011
--  Last change: JO 2/14/2017 10:53:42 AM
--
--



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RFInterlockRTM_a is
  port (

    Clock					: in std_logic;

-- SPI Interface

    Cmd_SDO  				: out std_logic;
    Cmd_SDI  				: in  std_logic;
    n_Cmd_CS 				: in  std_logic;
    Cmd_Clk  				: in  std_logic;

-- Fast Signal Comparator inputs
    n_Beam_I_Under 		: in std_logic;
    Beam_I_Over    		: in std_logic;
    Beam_V_Over    		: in std_logic;
    Fwd_Over       		: in std_logic;
    Refl_Over      		: in std_logic;

-- SLED Interface Signals
    n_Motor_Not_Detuned : in std_logic;
    n_Motor_Not_Tuned   : in std_logic;
    n_Lower_Detuned 		: in std_logic;
    n_Lower_Tuned   		: in std_logic;
    n_Upper_Tuned   		: in std_logic;
    n_Upper_Detuned 		: in std_logic;

-- SLED Tune/Detune Request     

    n_Tune_Req   			: in std_logic;
    n_DeTune_Req 			: in std_logic;

-- Control Output
	Tune_P					: out std_logic;
	Tune_M					: out std_logic;
	Tune_En					: out std_logic;
	DeTune_P				: out std_logic;
	DeTune_M				: out std_logic;
	DeTune_En				: out std_logic;

-- Modulator Interface

    Mod_Trigger_Out		: out std_logic;
    Mod_Fault     		: in  std_logic;
    n_Ext_Intlk   		: out std_logic;

-- Timing

	Mod_Trigger				: in std_logic;
	SSSB_Trigger			: in std_logic;

--    StndBy_Trig 			: in std_logic;
--    Accel_Trig  			: in std_logic;


-- AMC Interface

	RFON_AMC			: out std_logic;
    RFOFF 				: out std_logic;

-- Carrier Interface

    FaultOut 				: out std_logic;

	 
	 ClrFault				: in std_logic;

	 ByPass					: in std_logic;
	 
	 TestPoint				: out std_logic_Vector(3 downto 0)

    );
end RFInterlockRTM_a;


architecture Behaviour of RFInterlockRTM_a is

signal RegDataOut	  : std_logic_vector(15 downto 0);
signal Clk10KhzEn   : std_logic;
signal Clk1KhzEn    : std_logic;
signal Clk10hzEn    : std_logic;
signal Clk200hzEn    : std_logic;

-- SLED Interface Signals
signal Motor_Not_Detuned 	: std_logic;
signal Motor_Not_Tuned		: std_logic;
signal Lower_Detuned 		: std_logic;
signal Lower_Tuned			: std_logic;
signal Upper_Tuned			: std_logic;
signal Upper_Detuned 		: std_logic;

signal Beam_I_Under 			: std_logic;

signal Tune						: std_logic;
signal DeTune					: std_logic;
-- SLED Tune/Detune Request

signal Tune_Req				: std_logic;
signal DeTune_Req 			: std_logic;

signal Reset					: std_logic := '0';

signal FastFault				: std_Logic;
signal SLEDFault				: std_logic;

signal Cmd_CS					: std_logic;
signal WrStrb					: std_logic;
signal SPIDataOut 			: std_logic_vector(15 downto 0);
signal SPIDataIn				: std_logic_vector(15 downto 0);
signal SPIAddrOut				: std_logic_vector(7 downto 0);
signal SLEDStatus				: std_logic_vector(8 downto 0);
signal TriggerOut				: std_logic;
signal FaultStatus			: std_logic_vector(4 downto 0);
--signal ModTrigger				: std_logic;
signal iFault					: std_logic;
signal iMod_Fault				: std_logic;
signal TriggerPermit			: std_logic;
signal SysInfoDataOut		: std_logic_vector(15 downto 0);
signal PowerOn					: std_logic;
signal PonLatch				: std_logic;
signal RfOn						: std_logic;

begin


TestPoint				<= "0000";

Tune_Req 				<= not(n_Tune_Req);
DeTune_Req 				<= not(n_DeTune_Req);

Motor_Not_DeTuned 		<= not(n_Motor_Not_DeTuned);
Motor_Not_Tuned   		<= not(n_Motor_Not_Tuned);
Lower_Detuned 			<= not(n_Lower_DeTuned);
Lower_Tuned  			<= not(n_Lower_Tuned);
Upper_Tuned   			<= not(n_Upper_Tuned);
Upper_Detuned 			<= not(n_Upper_DeTuned);

--Beam_I_Under   		<= not(n_Beam_I_Under);

Beam_I_Under			<= '0';

Cmd_CS					<= not(n_Cmd_CS);

iFault					<= (SLEDFault OR FastFault OR PowerOn);
FaultOut					<= (iFault OR iMod_Fault) and not(Bypass);
RFOn						<= not((iFault or iMod_Fault or Poweron) and not(Bypass));
n_RFOff					<= RFOn;

--
Mod_Trigger_Out			<= Trigger and not(iFault) and not(iMod_Fault) and not(Bypass) and not(PowerOn);

-- low = Interlock closed, good
n_Ext_Intlk				<= (SLEDFault OR FastFault) and not(Bypass);

n_Tune_Cmd				<= not(Tune);
n_DeTune_Cmd			<= not(Detune);

SPIDataIn 				<= RegDataOut OR SysInfoDataOut;


PowerOn <= not(PonLatch);

Pon_p : process(Clock, Reset)
begin
if (Reset = '1') then
	PonLatch <= '0';
elsif (Clock'event and Clock = '1') then
	if (ClrFault = '1') then
		PonLatch <= '1';
	end if;
end if;
end process;

u_clkDiv : entity work.ClkEn_Gen
Port map (
	Clock			=> Clock,
	Reset			=> Reset,
	Clk10KhzEn     	=> Clk10KhzEn,
	Clk1KhzEn      	=> Clk1KhzEn,
	Clk200hzEn     	=> Clk200hzEn,
	Clk10hzEn      	=> Clk10hzEn
);

u_spi : Entity work.qspi
Port map (
	Clock			=> Cmd_Clk,
	Reset			=> Reset,

-- External interface
	Din			=> Cmd_SDI,
	Dout     	=> Cmd_SDO,
	Cs          => Cmd_Cs,
	Write_Strb	=> WrStrb,
	DataOut		=> SPIDataOut,
	Address		=> SPIAddrOut,
	En				=> OPEN,
	DataIn		=> SPIDataIn
	);


u_RegIntf : Entity work.RegIntf
Port map (
	Clock           	=> Clock,
	Reset            	=> Reset,
	Address          	=> SPIAddrOut,
	Write_Strb       	=> WrStrb,
	ClearStats			=> open,
	DataIn           	=> SPIDataOut,
	DataOut          	=> RegDataOut,
	SLEDStatus       	=> SLEDStatus,
	FastFaultStatus  	=> FaultStatus,
	ModulatorFault   	=> iMod_Fault,
	RFOn					=> RFOn
	);

u_Sled : entity work.SLEDInterface
port map (

    Clock				=> Clock,
    DeBounceEn			=> Clk1KhzEn,
	 TimeOutEn			=> Clk10HzEn,
	 Reset				=> Reset,
	 ClrFault			=> ClrFault,

-- SLED Interface Signals
    MotorNotDetuned	=> Motor_Not_DeTuned,
    MotorNotTuned		=> Motor_Not_Tuned,
    LowerDetuned 		=> Lower_Detuned,
    LowerTuned   		=> Lower_Tuned,
    UpperTuned   		=> Upper_Tuned,
    UpperDetuned 		=> Upper_Detuned,

-- SLED Tune/Detune Request
    TuneReq				=> Tune_Req,
    DeTuneReq			=> DeTune_Req,

-- Control Output
	 Tune					=>	Tune,
    DeTune				=> DeTune,
	 SLEDStatusOut		=> SLEDStatus,
	 SLEDFault			=> SLEDFault
);

u_FastFault : entity work.FastFaultInterface
  port map (

	Clock				=> Clock,
	Reset				=> Reset,
	ClrFault 		=> ClrFault,
	BeamUnderEn		=> Clk200HzEn,
--	BeamUnderEn		=> Clk10KhzEn,

-- Fast Signal Comparator inputs
	Beam_I_Under 	=> Beam_I_Under,
	Beam_I_Over		=> Beam_I_Over,
	Beam_V_Over		=> Beam_V_Over,
	Fwd_Over			=> Fwd_Over,
	Refl_Over		=> Refl_Over,

	FaultVectorOut	=> FaultStatus,
	FaultOut 		=> FastFault
    );

-- jjo
-- Only debounces the Mod Fault
u_ModTrig : Entity work.ModTrigger
Port map (
	Clock          => Clock,
	Reset          => Reset, 
	ClrFault			=> ClrFault,
	ModFault			=>	Mod_Fault,
	ModFaultOut		=> iMod_Fault
	);

-- jjo
-- not needed since it will be up to
-- clear and reenable the triggers
--
--u_TrigPermit : Entity work.TrigPermit
--port map (
--	Clock          => Clock,
--	Clk10HzEn     	=> Clk10HzEn,
----	Clk10HzEn     	=> Clk10KhzEn,
--	Reset          => Reset,
--	Trigger        => TriggerOut,
--	StndByTrig     => StndBy_Trig,
--	Fault          =>	iFault,
--	ModTrigger		=> ModTrigger,
--	TriggerPermit	=> TriggerPermit
--);

u_SysInfo : Entity work.SysInfo
Port map (
	Clock						=> Clock,
	Reset						=> Reset,

	LittleEndian			=> '0',
	Lnk_Addr		 			=> SPIAddrOut,
	Reg_DataOut				=> SysInfoDataOut

);



end behaviour;
