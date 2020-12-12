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
--  Last change: JO 1/9/2018 7:59:59 AM
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--
--library PWM_LKUP;
--use PWM_LKUP.all;
--
--library altera_mf;
--use altera_mf.altera_mf_components.all; 

entity RFInterlockRTM_a is
  port (

    Clock : in std_logic;

-- SPI Interface
    Cmd_SDO  : out std_logic;
    Cmd_SDI  : in  std_logic;
    n_Cmd_CS : in  std_logic;
    Cmd_Clk  : in  std_logic;

-- Fast Signal Comparator inputs
-- FWD_Over       : in std_logic; -- Removed in C01
    n_Beam_I_Under : in std_logic;
    Beam_I_Over    : in std_logic;
    Beam_V_Over    : in std_logic;
    Refl_Over      : in std_logic;

-- SLED Interface Signals
    n_Motor_Not_Detuned : in std_logic;
    n_Motor_Not_Tuned   : in std_logic;
    n_Lower_Detuned     : in std_logic;
    n_Lower_Tuned       : in std_logic;
    n_Upper_Tuned       : in std_logic;
    n_Upper_Detuned     : in std_logic;

-- SLED Tune/Detune Request     

    Tune_Req   : in std_logic;
    DeTune_Req : in std_logic;

-- Control Output
--    DeTune_P  : out std_logic;        -- Removed in C01
--    DeTune_M  : out std_logic;        -- Removed in C01        
    SLED_AC_Out_P : out std_logic;
    SLED_AC_Out_M : out std_logic;
    N_Tune_En     : out std_logic;
    N_DeTune_En   : out std_logic;

-- Modulator Interface

    Mod_Trigger_Out : out std_logic;
    Mod_Fault       : in  std_logic;
    n_Ext_Intlk     : out std_logic;
    n_Mod_Spare_Out : out std_logic;    -- Optical output
    Mod_Status      : in  std_logic;    -- Optical input

-- Timing
-- SSSB trigger is sent out on a LEMO
-- It is currently not used in the CPLD

    SSSB_Trigger : in std_logic;
    Mod_Trigger  : in std_logic;

-- AMC Interface

    RFOn_AMC : out std_logic;
    RFOff    : out std_logic;

-- Carrier Interface

    FaultOut : out std_logic;

    ClrFault : in std_logic;

    ByPass : in std_logic;

    TestPoint : out std_logic_vector(3 downto 0)
	 
--	 Reset : in std_logic

    );
end RFInterlockRTM_a;


architecture Behaviour of RFInterlockRTM_a is

  signal RegDataOut : std_logic_vector(15 downto 0);
  signal Clk245KhzEn : std_logic;
  signal Clk10KhzEn : std_logic;
  signal Clk1KhzEn  : std_logic;
  signal Clk10hzEn  : std_logic;
  signal Clk120HzEn : std_logic;
  signal Clk200hzEn : std_logic;

-- SLED Interface Signals
  signal Motor_Not_Detuned : std_logic;
  signal Motor_Not_Tuned   : std_logic;
  signal Lower_Detuned     : std_logic;
  signal Lower_Tuned       : std_logic;
  signal Upper_Tuned       : std_logic;
  signal Upper_Detuned     : std_logic;

  signal Beam_I_Under : std_logic;

  signal Tune   : std_logic;
  signal DeTune : std_logic;
-- SLED Tune/Detune Request

  signal Reset : std_logic := '0';

  signal FastFault : std_logic;
  signal SLEDFault : std_logic;

  signal Cmd_CS         : std_logic;
  signal WrStrb         : std_logic;
  signal SPIDataOut     : std_logic_vector(15 downto 0);
  signal SPIDataIn      : std_logic_vector(15 downto 0);
  signal SPIAddrOut     : std_logic_vector(7 downto 0);
  signal SLEDStatus     : std_logic_vector(8 downto 0);
  signal TriggerOut     : std_logic;
  signal FaultStatus    : std_logic_vector(4 downto 0);
--signal ModTrigger                             : std_logic;
  signal iFault         : std_logic;
  signal iMod_Fault     : std_logic;
  signal TriggerPermit  : std_logic;
  signal SysInfoDataOut : std_logic_vector(15 downto 0);
  signal PowerOn        : std_logic;
  signal PonLatch       : std_logic;
  signal RfOn           : std_logic;
  
-- Test
	signal TestCntr		: std_logic_vector(11 downto 0);
	signal PulseCntr		: std_logic_vector(11 downto 0);
	signal TestOut			: std_logic;
	signal TestDout		: std_logic_vector(15 downto 0);
	signal PWMDout		: std_logic_vector(15 downto 0);
	
	signal addr				: std_logic_vector(8 downto 0);
	Signal nread     		: std_logic;      --      nread.nread
	Signal nbusy      	: std_logic;     --      nbusy.nbusy
	Signal sync_nbusy    : std_logic_vector(1 downto 0);     
	Signal data_valid 	: std_Logic;   -- data_valid.data_valid
	Signal sync_data_valid   : std_logic_vector(1 downto 0); 
	signal PWM0_SR			: std_logic_vector(7 downto 0);
	signal PWM1_SR			: std_logic_vector(7 downto 0);
	signal PWMCntr			: std_logic_vector(2 downto 0);
	signal PWMClkEn		: std_logic;
	signal PWMStart		: std_logic;
	
	type PWMLkup_t is (
		UFM_Idle_s,
		UFM_Wait_s,
		UFM_Data_s,
		UFM_Shift_s
		);
		
		signal PWMLkup_s : PWMLkup_t;
		
	
		component PWM_Lkup is
		port (
			addr       : in  std_logic_vector(8 downto 0)  := (others => 'X'); -- addr
			nread      : in  std_logic                     := 'X';             -- nread
			dataout    : out std_logic_vector(15 downto 0);                    -- dataout
			nbusy      : out std_logic;                                        -- nbusy
			data_valid : out std_logic                                         -- data_valid
		);
	end component PWM_LKUP;
	
begin


	TestPoint(3) 			<= PWMStart;
  TestPoint(2) 			<= nread;
	TestPoint(1) 			<= PWM1_SR(0);
  TestPoint( 0) 			<= PWM0_SR(0);
  
  SLED_AC_Out_P <= PWM0_SR(0);
 SLED_AC_Out_M <= PWM1_SR(0);

  n_Mod_Spare_Out 	<='0';

  Motor_Not_DeTuned <= not(n_Motor_Not_DeTuned);
  Motor_Not_Tuned   <= not(n_Motor_Not_Tuned);
  Lower_Detuned     <= not(n_Lower_DeTuned);
  Lower_Tuned       <= not(n_Lower_Tuned);
  Upper_Tuned       <= not(n_Upper_Tuned);
  Upper_Detuned     <= not(n_Upper_DeTuned);

	Beam_I_Under		<= not(n_Beam_I_Under);

  Cmd_CS		<= not(n_Cmd_CS);

  iFault		<= (SLEDFault or FastFault or PowerOn);
  FaultOut	<= (iFault or iMod_Fault) and not(Bypass);
  RFOn		<= not((iFault or iMod_Fault or Poweron) and not(Bypass));
  RFOn_AMC	<= RFOn;
  RFOff		<= not(RFOn);

--
-- Comment out line below for test mode - JPS
  Mod_Trigger_Out <= Mod_Trigger and not(iFault) and not(iMod_Fault) and not(Bypass) and not(PowerOn);

-- Mod_Trigger_Out <= TestOut; -- uncomment this line for test mode (see also SLED_Interface.vhd

-- Test
-- low = Interlock closed, good



  n_Ext_Intlk <= (SLEDFault or FastFault) and not(Bypass);

  n_Tune_En   <= not(Tune);
  n_DeTune_En <= not(Detune);

  SPIDataIn <= RegDataOut or SysInfoDataOut;


  PowerOn <= not(PonLatch);
  
  
-- TEST pulse generated for Mod Trigger "Test_Out" above (JPS)

  test_pulse : process(Clock, Reset)
  begin
	if (Reset = '1') then
		PulseCntr <= (Others => '0');
	elsif (Clock'event and Clock = '1') then
		if (Clk120HzEn = '1') then
--			PulseCntr <= x"177";  -- 375, 6us
--			PulseCntr <= x"03E";  -- 62, 1us
			PulseCntr <= x"00A";  -- 10, 100ns
			TestOut  <= '1';
		elsif (TestOut = '1') then
			if (PulseCntr = x"00") then
				TestOut <= '0';
			else
				PulseCntr <= PulseCntr -1;
			end if;
		end if;	
	end if;
  end process;	

		
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
    port map (
      Clock      => Clock,
      Reset      => Reset,
		Clk245KhzEn => Clk245KhzEn,
      Clk10KhzEn => Clk10KhzEn,
      Clk1KhzEn  => Clk1KhzEn,
      Clk200hzEn => Clk200hzEn,
		Clk120HzEn	=> Clk120HzEn,
      Clk10hzEn  => Clk10hzEn
      );

  u_spi : entity work.qspi
    port map (
      Clock => Cmd_Clk,
      Reset => Reset,

-- External interface
      Din        => Cmd_SDI,
      Dout       => Cmd_SDO,
      Cs         => Cmd_Cs,
      Write_Strb => WrStrb,
      DataOut    => SPIDataOut,
      Address    => SPIAddrOut,
      En         => open,
      DataIn     => SPIDataIn
      );


  u_RegIntf : entity work.RegIntf
    port map (
      Clock           => Clock,
      Reset           => Reset,
      Address         => SPIAddrOut,
      Write_Strb      => WrStrb,
      ClearStats      => open,
      DataIn          => SPIDataOut,
      DataOut         => RegDataOut,
      SLEDStatus      => SLEDStatus,
      FastFaultStatus => FaultStatus,
      ModulatorFault  => iMod_Fault,
      RFOn            => RFOn
      );

  u_Sled : entity work.SLEDInterface
    port map (

      Clock       => Clock,
		DeBounceEn	=> Clk1KhzEn,
		TimeOutEn	=> Clk10HzEn,
		Clk120HzEn	=> Clk120HzEn,
		Reset			=> Reset,
		ClrFault		=> ClrFault,

-- SLED Interface Signals
      MotorNotDetuned => Motor_Not_DeTuned,
      MotorNotTuned   => Motor_Not_Tuned,
      LowerDetuned    => Lower_Detuned,
      LowerTuned      => Lower_Tuned,
      UpperTuned      => Upper_Tuned,
      UpperDetuned    => Upper_Detuned,

-- SLED Tune/Detune Request
		TuneReq			=> Tune_Req,
		DeTuneReq		=> DeTune_Req,
--		SLED_AC_Out_P	=> SLED_AC_Out_P,
--		SLED_AC_Out_M	=> SLED_AC_Out_M,

-- Control Output
		Tune				=> Tune,
		DeTune			=> DeTune,
		SLEDStatusOut	=> SLEDStatus,
		SLEDFault		=> SLEDFault
      );


-- jjo 1/9/18
-- Removed Beam I under and RF Forward
--

  u_FastFault : entity work.FastFaultInterface
    port map (

		Clock				=> Clock,
		Reset				=> Reset,
		ClrFault			=> ClrFault,
		BeamUnderEn		=> Clk200HzEn,
-- Fast Signal Comparator inputs
--		Beam_I_Under	=> Beam_I_Under,
--		Fwd_Over			=> Fwd_Over,
		Beam_I_Over		=> Beam_I_Over,
		Beam_V_Over		=> Beam_V_Over,
		Refl_Over		=> Refl_Over,

      FaultVectorOut => FaultStatus,
      FaultOut       => FastFault
      );

-- jjo
-- Only debounces the Mod Fault
  u_ModFlt : entity work.ModFlt
    port map (
      Clock       => Clock,
      Reset       => Reset,
      ClrFault    => ClrFault,
      ModFault    => Mod_Fault,
      ModFaultOut => iMod_Fault
      );


	u_SysInfo : entity work.SysInfo
		port map (
			Clock => Clock,
			Reset => Reset,

			LittleEndian => '0',
			Lnk_Addr     => SPIAddrOut,
			Reg_DataOut  => SysInfoDataOut
	);

-- TEST

PWMClkEn <= CLK245KhzEn;

  test_p : process(Clock, Reset)
  begin
	if (Reset = '1') then
		PWMLkup_s 			<= UFM_Idle_s;
		TestCntr 			<= (Others => '0');
		nread 				<= '1';
		Sync_data_valid 	<= (Others => '0');
		sync_nbusy 			<= (Others => '0');
		PWMCntr				<= (Others => '0');		
		PWM0_SR				<= (Others => '0');
		PWM1_SR				<= (Others => '0');
		PWMStart				<= '0';
		
	elsif (Clock'event and Clock = '1') then
		Sync_data_valid 	<= Sync_data_valid(0) & data_valid;
		sync_nbusy 			<= sync_nbusy(0) & nbusy;
		
		case PWMLkup_s is
	
		when UFM_Idle_s =>
		if ((PWMClkEn = '1') and (sync_nbusy(1) = '1')) then
			nread 		<= '0';
			PWMLkup_s 	<= UFM_Wait_s;
		else
			nread			<= '1';
		end if;
	
		when UFM_Wait_s =>		
			if (sync_nbusy(1) = '0') then
				nread 		<= '1';
				PWMLkup_s 	<= UFM_Data_s;	
			end if; 
			
		when UFM_Data_s =>
			if ((PWMClkEn = '1') and (Sync_data_valid(1) = '1')) then
				if (testcntr(8 downto 0) = "000000000") then
					PWMStart <= '1';
				else
					PWMStart <= '0';
				end if;
				
				PWM0_SR			<= TestDout(7 downto 0);
				PWM1_SR			<= TestDout(15 downto 8);				
				TestCntr 		<= TestCntr + 1;
				PWMCntr			<= "000";
				PWMLkup_s 		<= UFM_Shift_s;
		end if;
		
		
		when UFM_Shift_s =>
				if ((nread = '0') and (sync_nbusy(1) = '0')) then
					nread <= '1';
				end if;
				
			if (PWMClkEn = '1') then
					PWM0_SR <= '0' & PWM0_SR(7 downto 1);
					PWM1_SR <= '0' & PWM1_SR(7 downto 1);		
				if (PWMCntr(2 downto 0) = "100")	then
						nread <= '0';
				end if;
				
					
				if (PWMCntr(2 downto 0) = "110") then
					PWMLkup_s <= UFM_Data_s;
				else
					PWMCntr <= PWMCntr +1;
				end if;		
			end if;
		end case;
	end if;
end process;	
	
	
	
	addr <= TestCntr(8 downto 0);
	
	u0 : PWM_Lkup
		port map (
			addr       => addr,			--       addr.addr
			nread      => nread,      --      nread.nread
			dataout    => TestDout,    --    dataout.dataout
			nbusy      => nbusy,      --      nbusy.nbusy
			data_valid => data_valid  -- data_valid.data_valid
		);


end behaviour;
