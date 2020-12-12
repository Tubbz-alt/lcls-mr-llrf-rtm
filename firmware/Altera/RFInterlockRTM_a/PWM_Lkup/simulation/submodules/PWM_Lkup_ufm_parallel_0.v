//altufm_parallel ACCESS_MODE="READ_ONLY" CBX_AUTO_BLACKBOX="ALL" CBX_SINGLE_OUTPUT_FILE="ON" DEVICE_FAMILY="MAX V" ERASE_TIME=500000000 LPM_FILE="C:/Users/jjo/OneDrive - SLAC National Accelerator Laboratory/TID_AIR/Projects/MissionReadiness/RfInterlocks/Altera_C02/RFInterlockRTM_a/PWM_GEN_HEX.mif" OSC_FREQUENCY=180000 PROGRAM_TIME=1600000 WIDTH_ADDRESS=9 WIDTH_DATA=16 WIDTH_UFM_ADDRESS=9 addr data_valid dataout nbusy nread
//VERSION_BEGIN 18.1 cbx_a_gray2bin 2018:09:12:13:04:24:SJ cbx_a_graycounter 2018:09:12:13:04:24:SJ cbx_altufm_parallel 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_counter 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_lpm_mux 2018:09:12:13:04:24:SJ cbx_maxii 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2018  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.



//synthesis_resources = lpm_counter 1 lut 62 maxv_ufm 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"suppress_da_rule_internal=c101;suppress_da_rule_internal=c103;suppress_da_rule_internal=c104;suppress_da_rule_internal=r101;suppress_da_rule_internal=s104;suppress_da_rule_internal=s102"} *)
module  PWM_Lkup_ufm_parallel_0
	( 
	addr,
	data_valid,
	dataout,
	nbusy,
	nread) /* synthesis synthesis_clearbox=1 */;
	input   [8:0]  addr;
	output   data_valid;
	output   [15:0]  dataout;
	output   nbusy;
	input   nread;

	reg	[8:0]	A;
	reg	data_valid_out_reg;
	reg	data_valid_reg;
	reg	deco1_dffe;
	reg	decode_dffe;
	reg	gated_clk1_dffe;
	reg	gated_clk2_dffe;
	reg	real_decode2_dffe;
	reg	real_decode_dffe;
	reg	[15:0]	sipo_dffe;
	wire	[15:0]	wire_tmp_do_d;
	reg	[15:0]	tmp_do;
	wire	[15:0]	wire_tmp_do_ena;
	wire  [4:0]   wire_cntr2_q;
	wire  wire_maxii_ufm_block1_bgpbusy;
	wire  wire_maxii_ufm_block1_drdout;
	wire  wire_maxii_ufm_block1_osc;
	wire  add_en;
	wire  add_load;
	wire  arclk;
	wire  busy_arclk;
	wire  busy_drclk;
	wire  control_mux;
	wire  copy_tmp_decode;
	wire  data_valid_en;
	wire  dly_tmp_decode;
	wire  drdin;
	wire  gated1;
	wire  gated2;
	wire  hold_decode;
	wire  in_read_data_en;
	wire  in_read_drclk;
	wire  in_read_drshft;
	wire  mux_nread;
	wire oscena;
	wire  q0;
	wire  q1;
	wire  q2;
	wire  q3;
	wire  q4;
	wire  read;
	wire  read_op;
	wire  real_decode;
	wire  [8:0]  shiftin;
	wire  [15:0]  sipo_q;
	wire  start_decode;
	wire  start_op;
	wire  stop_op;
	wire  tmp_add_en;
	wire  tmp_add_load;
	wire  tmp_arclk;
	wire  tmp_arclk0;
	wire  tmp_ardin;
	wire  tmp_arshft;
	wire  tmp_data_valid2;
	wire  tmp_decode;
	wire  tmp_drclk;
	wire  tmp_in_read_data_en;
	wire  tmp_in_read_drclk;
	wire  tmp_in_read_drshft;
	wire  tmp_read;
	wire  ufm_arclk;
	wire  ufm_ardin;
	wire  ufm_arshft;
	wire  ufm_bgpbusy;
	wire  ufm_drclk;
	wire  ufm_drdin;
	wire  ufm_drdout;
	wire  ufm_drshft;
	wire  ufm_osc;
	wire  ufm_oscena;
	wire  [8:0]  X_var;
	wire  [8:0]  Y_var;
	wire  [8:0]  Z_var;

	// synopsys translate_off
	initial
		A = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (add_en == 1'b1)   A <= {Z_var};
	// synopsys translate_off
	initial
		data_valid_out_reg = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  data_valid_out_reg <= (data_valid_reg & (~ tmp_decode));
	// synopsys translate_off
	initial
		data_valid_reg = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (data_valid_en == 1'b1)   data_valid_reg <= tmp_data_valid2;
	// synopsys translate_off
	initial
		deco1_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (start_op == 1'b1)   deco1_dffe <= mux_nread;
	// synopsys translate_off
	initial
		decode_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  decode_dffe <= copy_tmp_decode;
	// synopsys translate_off
	initial
		gated_clk1_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  gated_clk1_dffe <= busy_arclk;
	// synopsys translate_off
	initial
		gated_clk2_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  gated_clk2_dffe <= busy_drclk;
	// synopsys translate_off
	initial
		real_decode2_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  real_decode2_dffe <= real_decode_dffe;
	// synopsys translate_off
	initial
		real_decode_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		  real_decode_dffe <= start_decode;
	// synopsys translate_off
	initial
		sipo_dffe = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (in_read_data_en == 1'b1)   sipo_dffe <= {sipo_q[14:0], ufm_drdout};
	// synopsys translate_off
	initial
		tmp_do[0:0] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[0:0] == 1'b1)   tmp_do[0:0] <= wire_tmp_do_d[0:0];
	// synopsys translate_off
	initial
		tmp_do[1:1] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[1:1] == 1'b1)   tmp_do[1:1] <= wire_tmp_do_d[1:1];
	// synopsys translate_off
	initial
		tmp_do[2:2] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[2:2] == 1'b1)   tmp_do[2:2] <= wire_tmp_do_d[2:2];
	// synopsys translate_off
	initial
		tmp_do[3:3] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[3:3] == 1'b1)   tmp_do[3:3] <= wire_tmp_do_d[3:3];
	// synopsys translate_off
	initial
		tmp_do[4:4] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[4:4] == 1'b1)   tmp_do[4:4] <= wire_tmp_do_d[4:4];
	// synopsys translate_off
	initial
		tmp_do[5:5] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[5:5] == 1'b1)   tmp_do[5:5] <= wire_tmp_do_d[5:5];
	// synopsys translate_off
	initial
		tmp_do[6:6] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[6:6] == 1'b1)   tmp_do[6:6] <= wire_tmp_do_d[6:6];
	// synopsys translate_off
	initial
		tmp_do[7:7] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[7:7] == 1'b1)   tmp_do[7:7] <= wire_tmp_do_d[7:7];
	// synopsys translate_off
	initial
		tmp_do[8:8] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[8:8] == 1'b1)   tmp_do[8:8] <= wire_tmp_do_d[8:8];
	// synopsys translate_off
	initial
		tmp_do[9:9] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[9:9] == 1'b1)   tmp_do[9:9] <= wire_tmp_do_d[9:9];
	// synopsys translate_off
	initial
		tmp_do[10:10] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[10:10] == 1'b1)   tmp_do[10:10] <= wire_tmp_do_d[10:10];
	// synopsys translate_off
	initial
		tmp_do[11:11] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[11:11] == 1'b1)   tmp_do[11:11] <= wire_tmp_do_d[11:11];
	// synopsys translate_off
	initial
		tmp_do[12:12] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[12:12] == 1'b1)   tmp_do[12:12] <= wire_tmp_do_d[12:12];
	// synopsys translate_off
	initial
		tmp_do[13:13] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[13:13] == 1'b1)   tmp_do[13:13] <= wire_tmp_do_d[13:13];
	// synopsys translate_off
	initial
		tmp_do[14:14] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[14:14] == 1'b1)   tmp_do[14:14] <= wire_tmp_do_d[14:14];
	// synopsys translate_off
	initial
		tmp_do[15:15] = 0;
	// synopsys translate_on
	always @ ( posedge ufm_osc)
		if (wire_tmp_do_ena[15:15] == 1'b1)   tmp_do[15:15] <= wire_tmp_do_d[15:15];
	assign
		wire_tmp_do_d = {sipo_q[15:0]};
	assign
		wire_tmp_do_ena = {16{(data_valid_reg & (~ tmp_decode))}};
	lpm_counter   cntr2
	( 
	.clk_en(tmp_decode),
	.clock(ufm_osc),
	.cout(),
	.eq(),
	.q(wire_cntr2_q)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.aclr(1'b0),
	.aload(1'b0),
	.aset(1'b0),
	.cin(1'b1),
	.cnt_en(1'b1),
	.data({5{1'b0}}),
	.sclr(1'b0),
	.sload(1'b0),
	.sset(1'b0),
	.updown(1'b1)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		cntr2.lpm_direction = "UP",
		cntr2.lpm_modulus = 28,
		cntr2.lpm_port_updown = "PORT_UNUSED",
		cntr2.lpm_width = 5,
		cntr2.lpm_type = "lpm_counter";
	maxv_ufm   maxii_ufm_block1
	( 
	.arclk(ufm_arclk),
	.ardin(ufm_ardin),
	.arshft(ufm_arshft),
	.bgpbusy(wire_maxii_ufm_block1_bgpbusy),
	.busy(),
	.drclk(ufm_drclk),
	.drdin(ufm_drdin),
	.drdout(wire_maxii_ufm_block1_drdout),
	.drshft(ufm_drshft),
	.osc(wire_maxii_ufm_block1_osc),
	.oscena(ufm_oscena)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.erase(1'b0),
	.program(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.ctrl_bgpbusy(1'b0),
	.devclrn(1'b1),
	.devpor(1'b1),
	.sbdin(1'b0),
	.sbdout()
	// synopsys translate_on
	);
	defparam
		maxii_ufm_block1.address_width = 9,
		maxii_ufm_block1.erase_time = 500000000,
		maxii_ufm_block1.init_file = "C:/Users/jjo/OneDrive - SLAC National Accelerator Laboratory/TID_AIR/Projects/MissionReadiness/RfInterlocks/Altera_C02/RFInterlockRTM_a/PWM_GEN_HEX.mif",
		maxii_ufm_block1.mem1 = 512'h9F00CF00E703F300790C3E009F0CE700F30C7C009E06CF00F3033CC0CF00E71879009E03E760E30079069E60E7003C06CF307980CE01C70CC730C7C0C700F303,
		maxii_ufm_block1.mem10 = 512'h00F300E700E706CF009F009F009F183F003F007F007E187E007E007E007E037E007E007E187E007E007E303E003F009F189F00CF00CF06E700F360F300F9007C,
		maxii_ufm_block1.mem11 = 512'h00F900F300E700E706CF009F003F007F00FE0CFC00FC00F900F300E760CF009F003F007F00FE00FC06F900F300E700CF009F189F003F007F00FE00FC30F900F9,
		maxii_ufm_block1.mem12 = 512'h00CF18E700F380F301F9007C187E003E003F0C9F009F009F0CCF00CF00CF18CF00CF00CF80CF01CF00CF00CF609F009F009F003FC03F007F007E00FE00FC0CF9,
		maxii_ufm_block1.mem13 = 512'h30E3C079007C033C0CE7303980CF01790CCE60F3009C06E76079009E06E7C079009E18E70079069E80CF01F3C07C009EC0CF00F3C0F9003CC09F00CF00E703C7,
		maxii_ufm_block1.mem14 = 512'h0C8EC3E330380C8EC3E33038188E06E3C338601E30C70CF1063883CE81F1C138601E60E73078303C301E308F30C73079609C60F3C03880E7019C03F306780CCE,
		maxii_ufm_block1.mem15 = 512'h38C30E18C7867161380C0E63C718E18318C38770C318E10E7063388C8631631C0C63C7381886C3C361E10C1807870763071C870E31C738E10C380E1CC3C73031,
		maxii_ufm_block1.mem16 = 512'h000000000000000000007118CE3079303C60CE60E360F1603860C760E3301C308F18C70CF10C3806CE8371C19C30E318380C8E8373611C18C70671C38C30E30C,
		maxii_ufm_block1.mem2 = 512'hF900F300F330E700E700CF00CF809F019F009F003F803F013F003F003F603F003F003F003F033F003F009F069F00CF00CF03E700E7C0F300F900F90C7C003EC0,
		maxii_ufm_block1.mem3 = 512'hFC00F900F900F330E700CF009F003F003F607F00FE00FC00F900F300E703CF009F003F007F00FE18FC00F900F300E700E7C0CF009F003F007F00FEC0FC00FC00,
		maxii_ufm_block1.mem4 = 512'hE700F303F900F9307C003E003F069F009F80CF01CF00CF80E701E700E700E703E700E700E730E700E700E700CF06CF00CF009F009F0C3F003F007F007E60FE00,
		maxii_ufm_block1.mem5 = 512'h8F18E730F1C0F1009C06E7187CC03C00CF0679303E009E03E73079009E03E76079009E0CE780F9013CC0CF00E730F9003C309F00E730F300F9303C009FC0CF00,
		maxii_ufm_block1.mem6 = 512'h3886C66171181C86C76171301C0C8F83E3C13830CE18710C3C068E8373C19C60E33071308E30C718E31871181E188F18F3303830E7609CC07380CE0179033C06,
		maxii_ufm_block1.mem7 = 512'hC331308E0CE30E70C31C18E3C670E01C308E1C718638C31C180E63C78C70310C1CC7C318E163700C38871C318E1C711C381CC6C6E1303886C631710C8C63E318,
		maxii_ufm_block1.mem8 = 512'h189C60C7C07380CE0139038F0673061E0C8F0CC70CE30CF10C780C3C061E06E7033883C7C13960CE3071183C0C8E86E3C11C30C71871861C61C730710C1C83C7,
		maxii_ufm_block1.mem9 = 512'h033E009F0CCF00E730F9007C303E00CF30E700F9183C00CF0CE70079039E60E700F30C3C80E70179189E80E701390CCF6073009E03F318F1609C80E701F106F1,
		maxii_ufm_block1.osc_sim_setting = 180000,
		maxii_ufm_block1.program_time = 1600000,
		maxii_ufm_block1.lpm_type = "maxv_ufm";
	assign
		add_en = (tmp_add_en & read_op),
		add_load = (tmp_add_load & read_op),
		arclk = (tmp_arclk0 & read_op),
		busy_arclk = arclk,
		busy_drclk = in_read_drclk,
		control_mux = (((~ q4) & ((q3 | q2) | q1)) | q4),
		copy_tmp_decode = tmp_decode,
		data_valid = data_valid_out_reg,
		data_valid_en = ((q4 & q3) & q1),
		dataout = tmp_do,
		dly_tmp_decode = decode_dffe,
		drdin = 1'b0,
		gated1 = gated_clk1_dffe,
		gated2 = gated_clk2_dffe,
		hold_decode = ((~ real_decode2_dffe) & real_decode),
		in_read_data_en = (tmp_in_read_data_en & read_op),
		in_read_drclk = (tmp_in_read_drclk & read_op),
		in_read_drshft = (tmp_in_read_drshft & read_op),
		mux_nread = (((~ control_mux) & read) | (control_mux & (~ data_valid_en))),
		nbusy = ((~ dly_tmp_decode) & (~ ufm_bgpbusy)),
		oscena = 1'b1,
		q0 = wire_cntr2_q[0],
		q1 = wire_cntr2_q[1],
		q2 = wire_cntr2_q[2],
		q3 = wire_cntr2_q[3],
		q4 = wire_cntr2_q[4],
		read = (~ nread),
		read_op = tmp_read,
		real_decode = start_decode,
		shiftin = {A[7:0], 1'b0},
		sipo_q = {sipo_dffe[15:0]},
		start_decode = (mux_nread & (~ ufm_bgpbusy)),
		start_op = (hold_decode | stop_op),
		stop_op = ((((q4 & q3) & (~ q2)) & q1) & q0),
		tmp_add_en = ((~ q4) & ((~ q3) | ((~ q2) & (~ q1)))),
		tmp_add_load = (~ ((~ q4) & (((((~ q3) & q2) | ((~ q3) & q0)) | ((~ q3) & q1)) | ((q3 & (~ q2)) & (~ q1))))),
		tmp_arclk = (gated1 & (~ ufm_osc)),
		tmp_arclk0 = ((~ q4) & ((~ q3) | (((~ q2) & (~ q1)) & (~ q0)))),
		tmp_ardin = A[8],
		tmp_arshft = add_en,
		tmp_data_valid2 = (stop_op & read_op),
		tmp_decode = tmp_read,
		tmp_drclk = (gated2 & (~ ufm_osc)),
		tmp_in_read_data_en = (((~ q4) & ((q3 & q2) | (q3 & q1))) | (q4 & (((~ q3) | ((~ q2) & (~ q1))) | (q1 & (~ q0))))),
		tmp_in_read_drclk = (((~ q4) & ((q3 & q2) | (q3 & q1))) | (q4 & (((~ q3) | ((~ q2) & (~ q1))) | (q1 & (~ q0))))),
		tmp_in_read_drshft = (~ (((((~ q4) & q3) & (~ q2)) & q1) & q0)),
		tmp_read = deco1_dffe,
		ufm_arclk = tmp_arclk,
		ufm_ardin = tmp_ardin,
		ufm_arshft = tmp_arshft,
		ufm_bgpbusy = wire_maxii_ufm_block1_bgpbusy,
		ufm_drclk = tmp_drclk,
		ufm_drdin = drdin,
		ufm_drdout = wire_maxii_ufm_block1_drdout,
		ufm_drshft = in_read_drshft,
		ufm_osc = wire_maxii_ufm_block1_osc,
		ufm_oscena = oscena,
		X_var = (shiftin & {9{(~ add_load)}}),
		Y_var = (addr & {9{add_load}}),
		Z_var = (X_var | Y_var);
endmodule //PWM_Lkup_ufm_parallel_0
//VALID FILE
