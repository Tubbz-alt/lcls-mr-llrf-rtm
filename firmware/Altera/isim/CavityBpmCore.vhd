-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	CavityBpmCore.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: Jeff Olsen
--	Created on: 8/9/2016 11:04:44 AM
--	Last change: JO 8/9/2016 11:23:01 AM
--
U_App : entity work.CavityBpmCore
generic map	(
   TPD_G        	=> TPD_G,
   XIL_DEVICE_G 	=> "7SERIES",
   APP_TYPE_G   	=> "ETH",
   AXIS_SIZE_G  	=> AXIS_SIZE_C,
   MAC_ADDR_G   	=> MAC_ADDR_C,
   IP_ADDR_G    	=> IP_ADDR_C
	)
port map (
   -- Clock and Reset
   clk       		: in sl,
   rst       		: in sl,

-- Axi-Lite Register Interface (axiClk domain)
	axilReadMaster	 : in	 AxiLiteReadMasterType	:= AXI_LITE_READ_MASTER_INIT_C;
	axilReadSlave	 : out AxiLiteReadSlaveType;
	axilWriteMaster : in	 AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
	axilWriteSlave	 : out AxiLiteWriteSlaveType;


   txMasters 		: => txMasters,
   txSlaves  		: => txSlaves,
   rxMasters 		: => rxMasters,
   rxSlaves  		: => rxSlaves,

-- LEDs
	GreenLED			=> GreenLed,
	RedLED			=> RedLED,

-- Push Button for Local Ip
	n_IPWrEn			=> n_IPWrEn,

-- RS232 Connector
	n_RS232Irq		=> n_RS232Irq,
	RS232Din			=> RS232Din,
	RS232Dout		=> RS232Dout,
	RS232Sclk		=> RS232SClk,
	n_RS232Cs		=> n_RS232Cs,

-- SFP Diagnostics
	SfpRxLos			=> SfpRxLos,
	SfpTxFault		=> SfpTxFault,
	SfpTxDis			=> SfpTxDis,
	SfpSda			=> SfpSda,
	SfpScl			=> SfpScl,
	SfpModPres		=> SfpModPres,

-- AD5542 DAC Interface
	DacSClk			=> DacSClk,
	DacDout			=> DacDout,
	n_DacCs			=> n_DacCs,

-- HMC783 PLL Interface
	PllSw1			=> PllSw1,
	PllSck			=> PllSck,
	PllSDo			=> PllSDo,
	PllSDi			=> PllSDi,
	PllCe				=> PllCe,
	n_PllSe			=> n_PllSe,

-- Attenuator Controls
	XAtten         => XAtten,
	YAtten         => YAtten,
	RefAtten       => RefAtten,
	Ch4Atten       => Ch4Atten,

-- Monitor ADC Interface
	MonSda         => MonSda,
	MonScl         => MonScl,

-- N25Q128 Boot Prom Interface
	BootSck        => BootSck,
	BootCs         => BootCs,
	BootData       => BootData,

-- 24LC64 Prom Interface
	PromSda        => PromSda,
	PromScl        => PromScl
);

