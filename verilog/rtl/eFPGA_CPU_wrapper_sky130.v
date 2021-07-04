// SPDX-FileCopyright 2021 Nguyen Dao
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
module eFPGA_CPU_top (
	// Wishbone Slave ports (WB MI A)
	input wb_clk_i,
	input wb_rst_i,
	input wbs_stb_i,
	input wbs_cyc_i,
	input wbs_we_i,
	input [3:0] wbs_sel_i,
	input [31:0] wbs_dat_i,
	input [31:0] wbs_adr_i,
	output wbs_ack_o,
	output [31:0] wbs_dat_o,

	// Logic Analyzer Signals
	output [2:0] la_data_out, //AA First 3 are in use?
	input  [127:0] la_data_in,

	// IOs
	input  [12:0] io_in,
	output [12:0] io_out,
	output [12:0] io_oeb,

	// Independent clock (on independent integer divider)
	input   user_clock2
);

	localparam include_eFPGA = 1;
	localparam NumberOfRows = 10;
	localparam NumberOfCols = 8;
	localparam FrameBitsPerRow = 32;
	localparam MaxFramesPerCol = 20;
	localparam desync_flag = 20;
	localparam FrameSelectWidth = 5;
	localparam RowSelectWidth = 5;

	wire [40-1:0] W_OPA;
	wire [40-1:0] W_OPB;
	wire [40-1:0] W_RES0;
	wire [40-1:0] W_RES1;
	wire [40-1:0] W_RES2;

	wire [40-1:0] E_OPA;
	wire [40-1:0] E_OPB;
	wire [40-1:0] E_RES0;
	wire [40-1:0] E_RES1;
	wire [40-1:0] E_RES2;
	
	wire CLK; // This clock can go to the CPU (connects to the fabric LUT output flops

	// CPU configuration port
	wire SelfWriteStrobe;        //from RISCV, must decode address and write enable
	wire [32-1:0] SelfWriteData; //from RISCV, configuration data write port

	// UART configuration port
	wire Rx;
	wire ComActive;
	wire ReceiveLED;

	// BitBang configuration port
	wire s_clk;
	wire s_data;

	wire external_clock;
	wire [1:0] clk_sel;

	// Signal declarations
	wire [(NumberOfRows*FrameBitsPerRow)-1:0] FrameRegister;
	wire [(MaxFramesPerCol*NumberOfCols)-1:0] FrameSelect;
	wire [(FrameBitsPerRow*(NumberOfRows+2))-1:0] FrameData;

	wire [FrameBitsPerRow-1:0] FrameAddressRegister;
	wire LongFrameStrobe;
	wire [31:0] LocalWriteData;
	wire LocalWriteStrobe;
	wire [RowSelectWidth-1:0] RowSelect;

	assign la_data_out[2:0] = {ReceiveLED, Rx, ComActive};

	assign external_clock = io_in[0];
	assign clk_sel = {io_in[2],io_in[1]};
	assign s_clk          = io_in[3];
	assign s_data         = io_in[4];
	assign Rx             = io_in[5];
	assign io_out[6]     = ReceiveLED;

	assign io_oeb[6:0] = 7'b1000000;
	
	assign CLK = clk_sel[0] ? (clk_sel[1] ? user_clock2 : wb_clk_i) : external_clock;

	assign W_OPA[39] = io_in[7];
	assign W_OPB[39] = io_in[8];
	assign W_OPA[38] = io_in[9];
	assign E_OPA[39] = io_in[10];
	assign E_OPB[39] = io_in[11];
	assign E_OPA[38] = io_in[12];
	assign io_out[9:7] = W_RES1[39:37];
	assign io_oeb[9:7] = W_RES2[39:37];
	assign io_out[12:10] = E_RES1[39:37];
	assign io_oeb[12:10] = E_RES2[39:37];

//CPU instantiation
/* 	
	wire [40-1:0] E_OPA;  //from RISCV
	wire [40-1:0] E_OPB;  //from RISCV
	wire [40-1:0] E_RES0; //to RISCV
	wire [40-1:0] E_RES1; //to RISCV
	wire [40-1:0] E_RES2; //to RISCV
	wire CLK; // This clock can go to the CPU (connects to the fabric LUT output flops
	// CPU configuration port
	wire SelfWriteStrobe;        //from RISCV, must decode address and write enable
	wire [32-1:0] SelfWriteData; //from RISCV, configuration data write port */

/* core wires

    input clk_i; //main clock 20mhz
    input debug_req_i;
    input fetch_enable_i; //enable cpu
    output irq_ack_o;
    input irq_i;
    input [4:0]irq_id_i;
    output [4:0]irq_id_o;
    input reset;
    output [31:0] eFPGA_operand_a_o;
    output [31:0] eFPGA_operand_b_o;
    input [31:0] eFPGA_result_a_i;
    input [31:0] eFPGA_result_b_i;
    input [31:0] eFPGA_result_c_i; //total 160 pins to fpga
    output eFPGA_write_strobe_o;  
    input eFPGA_fpga_done_i; 
    output eFPGA_en_o;
    output [1:0] eFPGA_operator_o;
    output [3:0] eFPGA_delay_o;



    wire [31:0]flexbex_data_addr_o;
    wire [3:0]flexbex_data_be_o;
    wire flexbex_data_gnt_i;
    wire [31:0]flexbex_data_rdata_i;
    wire flexbex_data_req_o;
    wire flexbex_data_rvalid_o;
    wire [31:0]flexbex_data_wdata_o;
    wire flexbex_data_we_o;

    
    input [31:0]ext_data_addr_i;
    input [3:0]ext_data_be_i;
    output ext_data_gnt_o;
    output [31:0]ext_data_rdata_o;
    input ext_data_req_i;
    output ext_data_rvalid_o;
    input [31:0]ext_data_wdata_i;
    input ext_data_we_i;

    wire [31:0]flexbex_instr_addr_o;
    wire flexbex_instr_gnt_o;
    wire [31:0]flexbex_instr_rdata_o;
    wire flexbex_instr_req_o;
    wire flexbex_instr_rvalid_o;
*/    


/*
wire [40-1:0] W_OPA;  //from RISCV
	wire [40-1:0] W_OPB;  //from RISCV
	wire [40-1:0] W_RES0; //to RISCV
	wire [40-1:0] W_RES1; //to RISCV
	wire [40-1:0] W_RES2; //to RISCV
*/
    wire eFPGA_operand_a_o;
    assign W_OPA[31:0] = eFPGA_operand_a_o;
    assign SelfWriteData = eFPGA_operand_a_o;

 //output to core mem a

    wire [8:0]core_a_data_addr_o;
    wire [3:0]core_a_data_be_o;
    wire [31:0]core_a_data_rdata_i;
    wire core_a_data_req_o;
    wire core_a_data_rvalid_i;
    wire [31:0]core_a_data_wdata_o;
    wire core_a_data_we_o;

forte_soc_top  FST_a_i (.clk_i(CLK), //clock
    .debug_req_i(la_data_in[0]), 
    .fetch_enable_i(la_data_in[1]),
    .irq_ack_o(W_OPA[33]),  
    .irq_i(W_RES0[32]), 
    .irq_id_i(W_RES0[37:33]),
    .irq_id_o(W_OPA[37:33]), 
    .reset(wb_rst_i),
    .eFPGA_operand_a_o(eFPGA_operand_a_o),
    .eFPGA_operand_b_o(W_OPB[31:0]),
    .eFPGA_result_a_i(W_RES0[31:0]),
    .eFPGA_result_b_i(W_RES1[31:0]),
    .eFPGA_result_c_i(W_RES2[31:0]),
    .eFPGA_write_strobe_o(SelfWriteStrobe),
    .eFPGA_fpga_done_i(W_RES0[38]),
    .eFPGA_delay_o(W_OPB[35:32]), 
    .eFPGA_en_o(W_OPB[36]),
    .eFPGA_operator_o(W_OPB[38:37]),
    .ext_data_addr_i(core_a_data_addr_o),
    .ext_data_be_i(core_a_data_be_o),
    .ext_data_rdata_o(core_a_data_rdata_i),
    .ext_data_req_i(core_a_data_req_o),
    .ext_data_rvalid_o(core_a_data_rvalid_i),
    .ext_data_wdata_i(core_a_data_wdata_o),
    .ext_data_we_i(core_a_data_we_o)
);

 //output to core mem b

    wire [8:0]core_b_data_addr_o;
    wire [3:0]core_b_data_be_o;
    wire [31:0]core_b_data_rdata_i;
    wire core_b_data_req_o;
    wire core_b_data_rvalid_i;
    wire [31:0]core_b_data_wdata_o;
    wire core_b_data_we_o;

core_sram  FST_b_i (.clk_i(CLK), //clock
    .debug_req_i(la_data_in[0]), 
    .fetch_enable_i(la_data_in[1]),
    .irq_ack_o(E_OPA[33]),  
    .irq_i(E_RES0[32]), 
    .irq_id_i(E_RES0[37:33]),
    .irq_id_o(E_OPA[37:33]), 
    .reset(wb_rst_i),
    .eFPGA_operand_a_o(E_OPA[31:0]),
    .eFPGA_operand_b_o(E_OPB[31:0]),
    .eFPGA_result_a_i(E_RES0[31:0]),
    .eFPGA_result_b_i(E_RES1[31:0]),
    .eFPGA_result_c_i(E_RES2[31:0]),
    .eFPGA_write_strobe_o(SelfWriteStrobe),
    .eFPGA_fpga_done_i(E_RES0[38]),
    .eFPGA_delay_o(E_OPB[35:32]), 
    .eFPGA_en_o(E_OPB[36]),
    .eFPGA_operator_o(E_OPB[38:37]),
    .ext_data_addr_i(core_b_data_addr_o),
    .ext_data_be_i(core_b_data_be_o),
    .ext_data_rdata_o(core_b_data_rdata_i),
    .ext_data_req_i(core_b_data_req_o),
	.ext_data_rvalid_o(core_b_data_rvalid_i),
    .ext_data_wdata_i(core_b_data_wdata_o),
    .ext_data_we_i(core_b_data_we_o)
);


wb_mem_split wb_to_core_sram_i(

   //input from the wishbone
    .wb_data_addr_i(wbs_adr_i),
    .wb_data_be_i(wbs_sel_i),
    .wb_data_rdata_o(wbs_dat_o),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wb_data_rvalid_o(wbs_ack_o),
    .wb_data_wdata_i(wbs_dat_i),
    .wb_data_we_i(wbs_we_i),

 //output to core mem a

    .core_a_data_addr_o(core_a_data_addr_o),
    .core_a_data_be_o(core_a_data_be_o),
    .core_a_data_rdata_i(core_a_data_rdata_i),
    .core_a_data_req_o(core_a_data_req_o),
    .core_a_data_rvalid_i(core_a_data_rvalid_i),
    .core_a_data_wdata_o(core_a_data_wdata_o),
    .core_a_data_we_o(core_a_data_we_o),

 //output to core mem b

    .core_b_data_addr_o(core_b_data_addr_o),
    .core_b_data_be_o(core_b_data_gnt_i),
    .core_b_data_rdata_i(core_b_data_req_o),
    .core_b_data_req_o(core_b_data_req_o),
    .core_b_data_rvalid_i(core_b_data_rvalid_i),
   	.core_b_data_wdata_o(core_b_data_wdata_o),
    .core_b_data_we_o(core_b_data_we_o)

);


Config Config_inst (
	.CLK(CLK),
	.Rx(Rx),
	.ComActive(ComActive),
	.ReceiveLED(ReceiveLED),
	.s_clk(s_clk),
	.s_data(s_data),
	.SelfWriteData(SelfWriteData),
	.SelfWriteStrobe(SelfWriteStrobe),
	
	.ConfigWriteData(LocalWriteData),
	.ConfigWriteStrobe(LocalWriteStrobe),
	
	.FrameAddressRegister(FrameAddressRegister),
	.LongFrameStrobe(LongFrameStrobe),
	.RowSelect(RowSelect)
);


	// L: if include_eFPGA = 1 generate

	Frame_Data_Reg_0 Inst_Frame_Data_Reg_0 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[0*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_1 Inst_Frame_Data_Reg_1 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[1*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_2 Inst_Frame_Data_Reg_2 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[2*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_3 Inst_Frame_Data_Reg_3 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[3*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_4 Inst_Frame_Data_Reg_4 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[4*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_5 Inst_Frame_Data_Reg_5 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[5*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_6 Inst_Frame_Data_Reg_6 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[6*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_7 Inst_Frame_Data_Reg_7 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[7*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_8 Inst_Frame_Data_Reg_8 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[8*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Data_Reg_9 Inst_Frame_Data_Reg_9 (
	.FrameData_I(LocalWriteData),
	.FrameData_O(FrameRegister[9*FrameBitsPerRow+:FrameBitsPerRow]),
	.RowSelect(RowSelect),
	.CLK(CLK)
	);

	Frame_Select_0 Inst_Frame_Select_0 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[0*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_1 Inst_Frame_Select_1 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[1*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_2 Inst_Frame_Select_2 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[2*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_3 Inst_Frame_Select_3 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[3*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_4 Inst_Frame_Select_4 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[4*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_5 Inst_Frame_Select_5 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[5*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_6 Inst_Frame_Select_6 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[6*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	Frame_Select_7 Inst_Frame_Select_7 (
	.FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
	.FrameStrobe_O(FrameSelect[7*MaxFramesPerCol +: MaxFramesPerCol]),
	.FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-(FrameSelectWidth)]),
	.FrameStrobe(LongFrameStrobe)
	);

	eFPGA Inst_eFPGA(
	.Tile_X0Y1_OPA_I0(W_OPA[39]),
	.Tile_X0Y1_OPA_I1(W_OPA[38]),
	.Tile_X0Y1_OPA_I2(W_OPA[37]),
	.Tile_X0Y1_OPA_I3(W_OPA[36]),
	.Tile_X0Y2_OPA_I0(W_OPA[35]),
	.Tile_X0Y2_OPA_I1(W_OPA[34]),
	.Tile_X0Y2_OPA_I2(W_OPA[33]),
	.Tile_X0Y2_OPA_I3(W_OPA[32]),
	.Tile_X0Y3_OPA_I0(W_OPA[31]),
	.Tile_X0Y3_OPA_I1(W_OPA[30]),
	.Tile_X0Y3_OPA_I2(W_OPA[29]),
	.Tile_X0Y3_OPA_I3(W_OPA[28]),
	.Tile_X0Y4_OPA_I0(W_OPA[27]),
	.Tile_X0Y4_OPA_I1(W_OPA[26]),
	.Tile_X0Y4_OPA_I2(W_OPA[25]),
	.Tile_X0Y4_OPA_I3(W_OPA[24]),
	.Tile_X0Y5_OPA_I0(W_OPA[23]),
	.Tile_X0Y5_OPA_I1(W_OPA[22]),
	.Tile_X0Y5_OPA_I2(W_OPA[21]),
	.Tile_X0Y5_OPA_I3(W_OPA[20]),
	.Tile_X0Y6_OPA_I0(W_OPA[19]),
	.Tile_X0Y6_OPA_I1(W_OPA[18]),
	.Tile_X0Y6_OPA_I2(W_OPA[17]),
	.Tile_X0Y6_OPA_I3(W_OPA[16]),
	.Tile_X0Y7_OPA_I0(W_OPA[15]),
	.Tile_X0Y7_OPA_I1(W_OPA[14]),
	.Tile_X0Y7_OPA_I2(W_OPA[13]),
	.Tile_X0Y7_OPA_I3(W_OPA[12]),
	.Tile_X0Y8_OPA_I0(W_OPA[11]),
	.Tile_X0Y8_OPA_I1(W_OPA[10]),
	.Tile_X0Y8_OPA_I2(W_OPA[9]),
	.Tile_X0Y8_OPA_I3(W_OPA[8]),
	.Tile_X0Y9_OPA_I0(W_OPA[7]),
	.Tile_X0Y9_OPA_I1(W_OPA[6]),
	.Tile_X0Y9_OPA_I2(W_OPA[5]),
	.Tile_X0Y9_OPA_I3(W_OPA[4]),
	.Tile_X0Y10_OPA_I0(W_OPA[3]),
	.Tile_X0Y10_OPA_I1(W_OPA[2]),
	.Tile_X0Y10_OPA_I2(W_OPA[1]),
	.Tile_X0Y10_OPA_I3(W_OPA[0]),

	.Tile_X0Y1_OPB_I0(W_OPB[39]),
	.Tile_X0Y1_OPB_I1(W_OPB[38]),
	.Tile_X0Y1_OPB_I2(W_OPB[37]),
	.Tile_X0Y1_OPB_I3(W_OPB[36]),
	.Tile_X0Y2_OPB_I0(W_OPB[35]),
	.Tile_X0Y2_OPB_I1(W_OPB[34]),
	.Tile_X0Y2_OPB_I2(W_OPB[33]),
	.Tile_X0Y2_OPB_I3(W_OPB[32]),
	.Tile_X0Y3_OPB_I0(W_OPB[31]),
	.Tile_X0Y3_OPB_I1(W_OPB[30]),
	.Tile_X0Y3_OPB_I2(W_OPB[29]),
	.Tile_X0Y3_OPB_I3(W_OPB[28]),
	.Tile_X0Y4_OPB_I0(W_OPB[27]),
	.Tile_X0Y4_OPB_I1(W_OPB[26]),
	.Tile_X0Y4_OPB_I2(W_OPB[25]),
	.Tile_X0Y4_OPB_I3(W_OPB[24]),
	.Tile_X0Y5_OPB_I0(W_OPB[23]),
	.Tile_X0Y5_OPB_I1(W_OPB[22]),
	.Tile_X0Y5_OPB_I2(W_OPB[21]),
	.Tile_X0Y5_OPB_I3(W_OPB[20]),
	.Tile_X0Y6_OPB_I0(W_OPB[19]),
	.Tile_X0Y6_OPB_I1(W_OPB[18]),
	.Tile_X0Y6_OPB_I2(W_OPB[17]),
	.Tile_X0Y6_OPB_I3(W_OPB[16]),
	.Tile_X0Y7_OPB_I0(W_OPB[15]),
	.Tile_X0Y7_OPB_I1(W_OPB[14]),
	.Tile_X0Y7_OPB_I2(W_OPB[13]),
	.Tile_X0Y7_OPB_I3(W_OPB[12]),
	.Tile_X0Y8_OPB_I0(W_OPB[11]),
	.Tile_X0Y8_OPB_I1(W_OPB[10]),
	.Tile_X0Y8_OPB_I2(W_OPB[9]),
	.Tile_X0Y8_OPB_I3(W_OPB[8]),
	.Tile_X0Y9_OPB_I0(W_OPB[7]),
	.Tile_X0Y9_OPB_I1(W_OPB[6]),
	.Tile_X0Y9_OPB_I2(W_OPB[5]),
	.Tile_X0Y9_OPB_I3(W_OPB[4]),
	.Tile_X0Y10_OPB_I0(W_OPB[3]),
	.Tile_X0Y10_OPB_I1(W_OPB[2]),
	.Tile_X0Y10_OPB_I2(W_OPB[1]),
	.Tile_X0Y10_OPB_I3(W_OPB[0]),

	.Tile_X0Y1_RES0_O0(W_RES0[39]),
	.Tile_X0Y1_RES0_O1(W_RES0[38]),
	.Tile_X0Y1_RES0_O2(W_RES0[37]),
	.Tile_X0Y1_RES0_O3(W_RES0[36]),
	.Tile_X0Y2_RES0_O0(W_RES0[35]),
	.Tile_X0Y2_RES0_O1(W_RES0[34]),
	.Tile_X0Y2_RES0_O2(W_RES0[33]),
	.Tile_X0Y2_RES0_O3(W_RES0[32]),
	.Tile_X0Y3_RES0_O0(W_RES0[31]),
	.Tile_X0Y3_RES0_O1(W_RES0[30]),
	.Tile_X0Y3_RES0_O2(W_RES0[29]),
	.Tile_X0Y3_RES0_O3(W_RES0[28]),
	.Tile_X0Y4_RES0_O0(W_RES0[27]),
	.Tile_X0Y4_RES0_O1(W_RES0[26]),
	.Tile_X0Y4_RES0_O2(W_RES0[25]),
	.Tile_X0Y4_RES0_O3(W_RES0[24]),
	.Tile_X0Y5_RES0_O0(W_RES0[23]),
	.Tile_X0Y5_RES0_O1(W_RES0[22]),
	.Tile_X0Y5_RES0_O2(W_RES0[21]),
	.Tile_X0Y5_RES0_O3(W_RES0[20]),
	.Tile_X0Y6_RES0_O0(W_RES0[19]),
	.Tile_X0Y6_RES0_O1(W_RES0[18]),
	.Tile_X0Y6_RES0_O2(W_RES0[17]),
	.Tile_X0Y6_RES0_O3(W_RES0[16]),
	.Tile_X0Y7_RES0_O0(W_RES0[15]),
	.Tile_X0Y7_RES0_O1(W_RES0[14]),
	.Tile_X0Y7_RES0_O2(W_RES0[13]),
	.Tile_X0Y7_RES0_O3(W_RES0[12]),
	.Tile_X0Y8_RES0_O0(W_RES0[11]),
	.Tile_X0Y8_RES0_O1(W_RES0[10]),
	.Tile_X0Y8_RES0_O2(W_RES0[9]),
	.Tile_X0Y8_RES0_O3(W_RES0[8]),
	.Tile_X0Y9_RES0_O0(W_RES0[7]),
	.Tile_X0Y9_RES0_O1(W_RES0[6]),
	.Tile_X0Y9_RES0_O2(W_RES0[5]),
	.Tile_X0Y9_RES0_O3(W_RES0[4]),
	.Tile_X0Y10_RES0_O0(W_RES0[3]),
	.Tile_X0Y10_RES0_O1(W_RES0[2]),
	.Tile_X0Y10_RES0_O2(W_RES0[1]),
	.Tile_X0Y10_RES0_O3(W_RES0[0]),

	.Tile_X0Y1_RES1_O0(W_RES1[39]),
	.Tile_X0Y1_RES1_O1(W_RES1[38]),
	.Tile_X0Y1_RES1_O2(W_RES1[37]),
	.Tile_X0Y1_RES1_O3(W_RES1[36]),
	.Tile_X0Y2_RES1_O0(W_RES1[35]),
	.Tile_X0Y2_RES1_O1(W_RES1[34]),
	.Tile_X0Y2_RES1_O2(W_RES1[33]),
	.Tile_X0Y2_RES1_O3(W_RES1[32]),
	.Tile_X0Y3_RES1_O0(W_RES1[31]),
	.Tile_X0Y3_RES1_O1(W_RES1[30]),
	.Tile_X0Y3_RES1_O2(W_RES1[29]),
	.Tile_X0Y3_RES1_O3(W_RES1[28]),
	.Tile_X0Y4_RES1_O0(W_RES1[27]),
	.Tile_X0Y4_RES1_O1(W_RES1[26]),
	.Tile_X0Y4_RES1_O2(W_RES1[25]),
	.Tile_X0Y4_RES1_O3(W_RES1[24]),
	.Tile_X0Y5_RES1_O0(W_RES1[23]),
	.Tile_X0Y5_RES1_O1(W_RES1[22]),
	.Tile_X0Y5_RES1_O2(W_RES1[21]),
	.Tile_X0Y5_RES1_O3(W_RES1[20]),
	.Tile_X0Y6_RES1_O0(W_RES1[19]),
	.Tile_X0Y6_RES1_O1(W_RES1[18]),
	.Tile_X0Y6_RES1_O2(W_RES1[17]),
	.Tile_X0Y6_RES1_O3(W_RES1[16]),
	.Tile_X0Y7_RES1_O0(W_RES1[15]),
	.Tile_X0Y7_RES1_O1(W_RES1[14]),
	.Tile_X0Y7_RES1_O2(W_RES1[13]),
	.Tile_X0Y7_RES1_O3(W_RES1[12]),
	.Tile_X0Y8_RES1_O0(W_RES1[11]),
	.Tile_X0Y8_RES1_O1(W_RES1[10]),
	.Tile_X0Y8_RES1_O2(W_RES1[9]),
	.Tile_X0Y8_RES1_O3(W_RES1[8]),
	.Tile_X0Y9_RES1_O0(W_RES1[7]),
	.Tile_X0Y9_RES1_O1(W_RES1[6]),
	.Tile_X0Y9_RES1_O2(W_RES1[5]),
	.Tile_X0Y9_RES1_O3(W_RES1[4]),
	.Tile_X0Y10_RES1_O0(W_RES1[3]),
	.Tile_X0Y10_RES1_O1(W_RES1[2]),
	.Tile_X0Y10_RES1_O2(W_RES1[1]),
	.Tile_X0Y10_RES1_O3(W_RES1[0]),

	.Tile_X0Y1_RES2_O0(W_RES2[39]),
	.Tile_X0Y1_RES2_O1(W_RES2[38]),
	.Tile_X0Y1_RES2_O2(W_RES2[37]),
	.Tile_X0Y1_RES2_O3(W_RES2[36]),
	.Tile_X0Y2_RES2_O0(W_RES2[35]),
	.Tile_X0Y2_RES2_O1(W_RES2[34]),
	.Tile_X0Y2_RES2_O2(W_RES2[33]),
	.Tile_X0Y2_RES2_O3(W_RES2[32]),
	.Tile_X0Y3_RES2_O0(W_RES2[31]),
	.Tile_X0Y3_RES2_O1(W_RES2[30]),
	.Tile_X0Y3_RES2_O2(W_RES2[29]),
	.Tile_X0Y3_RES2_O3(W_RES2[28]),
	.Tile_X0Y4_RES2_O0(W_RES2[27]),
	.Tile_X0Y4_RES2_O1(W_RES2[26]),
	.Tile_X0Y4_RES2_O2(W_RES2[25]),
	.Tile_X0Y4_RES2_O3(W_RES2[24]),
	.Tile_X0Y5_RES2_O0(W_RES2[23]),
	.Tile_X0Y5_RES2_O1(W_RES2[22]),
	.Tile_X0Y5_RES2_O2(W_RES2[21]),
	.Tile_X0Y5_RES2_O3(W_RES2[20]),
	.Tile_X0Y6_RES2_O0(W_RES2[19]),
	.Tile_X0Y6_RES2_O1(W_RES2[18]),
	.Tile_X0Y6_RES2_O2(W_RES2[17]),
	.Tile_X0Y6_RES2_O3(W_RES2[16]),
	.Tile_X0Y7_RES2_O0(W_RES2[15]),
	.Tile_X0Y7_RES2_O1(W_RES2[14]),
	.Tile_X0Y7_RES2_O2(W_RES2[13]),
	.Tile_X0Y7_RES2_O3(W_RES2[12]),
	.Tile_X0Y8_RES2_O0(W_RES2[11]),
	.Tile_X0Y8_RES2_O1(W_RES2[10]),
	.Tile_X0Y8_RES2_O2(W_RES2[9]),
	.Tile_X0Y8_RES2_O3(W_RES2[8]),
	.Tile_X0Y9_RES2_O0(W_RES2[7]),
	.Tile_X0Y9_RES2_O1(W_RES2[6]),
	.Tile_X0Y9_RES2_O2(W_RES2[5]),
	.Tile_X0Y9_RES2_O3(W_RES2[4]),
	.Tile_X0Y10_RES2_O0(W_RES2[3]),
	.Tile_X0Y10_RES2_O1(W_RES2[2]),
	.Tile_X0Y10_RES2_O2(W_RES2[1]),
	.Tile_X0Y10_RES2_O3(W_RES2[0]),

	.Tile_X7Y1_OPA_I0(E_OPA[39]),
	.Tile_X7Y1_OPA_I1(E_OPA[38]),
	.Tile_X7Y1_OPA_I2(E_OPA[37]),
	.Tile_X7Y1_OPA_I3(E_OPA[36]),
	.Tile_X7Y2_OPA_I0(E_OPA[35]),
	.Tile_X7Y2_OPA_I1(E_OPA[34]),
	.Tile_X7Y2_OPA_I2(E_OPA[33]),
	.Tile_X7Y2_OPA_I3(E_OPA[32]),
	.Tile_X7Y3_OPA_I0(E_OPA[31]),
	.Tile_X7Y3_OPA_I1(E_OPA[30]),
	.Tile_X7Y3_OPA_I2(E_OPA[29]),
	.Tile_X7Y3_OPA_I3(E_OPA[28]),
	.Tile_X7Y4_OPA_I0(E_OPA[27]),
	.Tile_X7Y4_OPA_I1(E_OPA[26]),
	.Tile_X7Y4_OPA_I2(E_OPA[25]),
	.Tile_X7Y4_OPA_I3(E_OPA[24]),
	.Tile_X7Y5_OPA_I0(E_OPA[23]),
	.Tile_X7Y5_OPA_I1(E_OPA[22]),
	.Tile_X7Y5_OPA_I2(E_OPA[21]),
	.Tile_X7Y5_OPA_I3(E_OPA[20]),
	.Tile_X7Y6_OPA_I0(E_OPA[19]),
	.Tile_X7Y6_OPA_I1(E_OPA[18]),
	.Tile_X7Y6_OPA_I2(E_OPA[17]),
	.Tile_X7Y6_OPA_I3(E_OPA[16]),
	.Tile_X7Y7_OPA_I0(E_OPA[15]),
	.Tile_X7Y7_OPA_I1(E_OPA[14]),
	.Tile_X7Y7_OPA_I2(E_OPA[13]),
	.Tile_X7Y7_OPA_I3(E_OPA[12]),
	.Tile_X7Y8_OPA_I0(E_OPA[11]),
	.Tile_X7Y8_OPA_I1(E_OPA[10]),
	.Tile_X7Y8_OPA_I2(E_OPA[9]),
	.Tile_X7Y8_OPA_I3(E_OPA[8]),
	.Tile_X7Y9_OPA_I0(E_OPA[7]),
	.Tile_X7Y9_OPA_I1(E_OPA[6]),
	.Tile_X7Y9_OPA_I2(E_OPA[5]),
	.Tile_X7Y9_OPA_I3(E_OPA[4]),
	.Tile_X7Y10_OPA_I0(E_OPA[3]),
	.Tile_X7Y10_OPA_I1(E_OPA[2]),
	.Tile_X7Y10_OPA_I2(E_OPA[1]),
	.Tile_X7Y10_OPA_I3(E_OPA[0]),

	.Tile_X7Y1_OPB_I0(E_OPB[39]),
	.Tile_X7Y1_OPB_I1(E_OPB[38]),
	.Tile_X7Y1_OPB_I2(E_OPB[37]),
	.Tile_X7Y1_OPB_I3(E_OPB[36]),
	.Tile_X7Y2_OPB_I0(E_OPB[35]),
	.Tile_X7Y2_OPB_I1(E_OPB[34]),
	.Tile_X7Y2_OPB_I2(E_OPB[33]),
	.Tile_X7Y2_OPB_I3(E_OPB[32]),
	.Tile_X7Y3_OPB_I0(E_OPB[31]),
	.Tile_X7Y3_OPB_I1(E_OPB[30]),
	.Tile_X7Y3_OPB_I2(E_OPB[29]),
	.Tile_X7Y3_OPB_I3(E_OPB[28]),
	.Tile_X7Y4_OPB_I0(E_OPB[27]),
	.Tile_X7Y4_OPB_I1(E_OPB[26]),
	.Tile_X7Y4_OPB_I2(E_OPB[25]),
	.Tile_X7Y4_OPB_I3(E_OPB[24]),
	.Tile_X7Y5_OPB_I0(E_OPB[23]),
	.Tile_X7Y5_OPB_I1(E_OPB[22]),
	.Tile_X7Y5_OPB_I2(E_OPB[21]),
	.Tile_X7Y5_OPB_I3(E_OPB[20]),
	.Tile_X7Y6_OPB_I0(E_OPB[19]),
	.Tile_X7Y6_OPB_I1(E_OPB[18]),
	.Tile_X7Y6_OPB_I2(E_OPB[17]),
	.Tile_X7Y6_OPB_I3(E_OPB[16]),
	.Tile_X7Y7_OPB_I0(E_OPB[15]),
	.Tile_X7Y7_OPB_I1(E_OPB[14]),
	.Tile_X7Y7_OPB_I2(E_OPB[13]),
	.Tile_X7Y7_OPB_I3(E_OPB[12]),
	.Tile_X7Y8_OPB_I0(E_OPB[11]),
	.Tile_X7Y8_OPB_I1(E_OPB[10]),
	.Tile_X7Y8_OPB_I2(E_OPB[9]),
	.Tile_X7Y8_OPB_I3(E_OPB[8]),
	.Tile_X7Y9_OPB_I0(E_OPB[7]),
	.Tile_X7Y9_OPB_I1(E_OPB[6]),
	.Tile_X7Y9_OPB_I2(E_OPB[5]),
	.Tile_X7Y9_OPB_I3(E_OPB[4]),
	.Tile_X7Y10_OPB_I0(E_OPB[3]),
	.Tile_X7Y10_OPB_I1(E_OPB[2]),
	.Tile_X7Y10_OPB_I2(E_OPB[1]),
	.Tile_X7Y10_OPB_I3(E_OPB[0]),

	.Tile_X7Y1_RES0_O0(E_RES0[39]),
	.Tile_X7Y1_RES0_O1(E_RES0[38]),
	.Tile_X7Y1_RES0_O2(E_RES0[37]),
	.Tile_X7Y1_RES0_O3(E_RES0[36]),
	.Tile_X7Y2_RES0_O0(E_RES0[35]),
	.Tile_X7Y2_RES0_O1(E_RES0[34]),
	.Tile_X7Y2_RES0_O2(E_RES0[33]),
	.Tile_X7Y2_RES0_O3(E_RES0[32]),
	.Tile_X7Y3_RES0_O0(E_RES0[31]),
	.Tile_X7Y3_RES0_O1(E_RES0[30]),
	.Tile_X7Y3_RES0_O2(E_RES0[29]),
	.Tile_X7Y3_RES0_O3(E_RES0[28]),
	.Tile_X7Y4_RES0_O0(E_RES0[27]),
	.Tile_X7Y4_RES0_O1(E_RES0[26]),
	.Tile_X7Y4_RES0_O2(E_RES0[25]),
	.Tile_X7Y4_RES0_O3(E_RES0[24]),
	.Tile_X7Y5_RES0_O0(E_RES0[23]),
	.Tile_X7Y5_RES0_O1(E_RES0[22]),
	.Tile_X7Y5_RES0_O2(E_RES0[21]),
	.Tile_X7Y5_RES0_O3(E_RES0[20]),
	.Tile_X7Y6_RES0_O0(E_RES0[19]),
	.Tile_X7Y6_RES0_O1(E_RES0[18]),
	.Tile_X7Y6_RES0_O2(E_RES0[17]),
	.Tile_X7Y6_RES0_O3(E_RES0[16]),
	.Tile_X7Y7_RES0_O0(E_RES0[15]),
	.Tile_X7Y7_RES0_O1(E_RES0[14]),
	.Tile_X7Y7_RES0_O2(E_RES0[13]),
	.Tile_X7Y7_RES0_O3(E_RES0[12]),
	.Tile_X7Y8_RES0_O0(E_RES0[11]),
	.Tile_X7Y8_RES0_O1(E_RES0[10]),
	.Tile_X7Y8_RES0_O2(E_RES0[9]),
	.Tile_X7Y8_RES0_O3(E_RES0[8]),
	.Tile_X7Y9_RES0_O0(E_RES0[7]),
	.Tile_X7Y9_RES0_O1(E_RES0[6]),
	.Tile_X7Y9_RES0_O2(E_RES0[5]),
	.Tile_X7Y9_RES0_O3(E_RES0[4]),
	.Tile_X7Y10_RES0_O0(E_RES0[3]),
	.Tile_X7Y10_RES0_O1(E_RES0[2]),
	.Tile_X7Y10_RES0_O2(E_RES0[1]),
	.Tile_X7Y10_RES0_O3(E_RES0[0]),

	.Tile_X7Y1_RES1_O0(E_RES1[39]),
	.Tile_X7Y1_RES1_O1(E_RES1[38]),
	.Tile_X7Y1_RES1_O2(E_RES1[37]),
	.Tile_X7Y1_RES1_O3(E_RES1[36]),
	.Tile_X7Y2_RES1_O0(E_RES1[35]),
	.Tile_X7Y2_RES1_O1(E_RES1[34]),
	.Tile_X7Y2_RES1_O2(E_RES1[33]),
	.Tile_X7Y2_RES1_O3(E_RES1[32]),
	.Tile_X7Y3_RES1_O0(E_RES1[31]),
	.Tile_X7Y3_RES1_O1(E_RES1[30]),
	.Tile_X7Y3_RES1_O2(E_RES1[29]),
	.Tile_X7Y3_RES1_O3(E_RES1[28]),
	.Tile_X7Y4_RES1_O0(E_RES1[27]),
	.Tile_X7Y4_RES1_O1(E_RES1[26]),
	.Tile_X7Y4_RES1_O2(E_RES1[25]),
	.Tile_X7Y4_RES1_O3(E_RES1[24]),
	.Tile_X7Y5_RES1_O0(E_RES1[23]),
	.Tile_X7Y5_RES1_O1(E_RES1[22]),
	.Tile_X7Y5_RES1_O2(E_RES1[21]),
	.Tile_X7Y5_RES1_O3(E_RES1[20]),
	.Tile_X7Y6_RES1_O0(E_RES1[19]),
	.Tile_X7Y6_RES1_O1(E_RES1[18]),
	.Tile_X7Y6_RES1_O2(E_RES1[17]),
	.Tile_X7Y6_RES1_O3(E_RES1[16]),
	.Tile_X7Y7_RES1_O0(E_RES1[15]),
	.Tile_X7Y7_RES1_O1(E_RES1[14]),
	.Tile_X7Y7_RES1_O2(E_RES1[13]),
	.Tile_X7Y7_RES1_O3(E_RES1[12]),
	.Tile_X7Y8_RES1_O0(E_RES1[11]),
	.Tile_X7Y8_RES1_O1(E_RES1[10]),
	.Tile_X7Y8_RES1_O2(E_RES1[9]),
	.Tile_X7Y8_RES1_O3(E_RES1[8]),
	.Tile_X7Y9_RES1_O0(E_RES1[7]),
	.Tile_X7Y9_RES1_O1(E_RES1[6]),
	.Tile_X7Y9_RES1_O2(E_RES1[5]),
	.Tile_X7Y9_RES1_O3(E_RES1[4]),
	.Tile_X7Y10_RES1_O0(E_RES1[3]),
	.Tile_X7Y10_RES1_O1(E_RES1[2]),
	.Tile_X7Y10_RES1_O2(E_RES1[1]),
	.Tile_X7Y10_RES1_O3(E_RES1[0]),

	.Tile_X7Y1_RES2_O0(E_RES2[39]),
	.Tile_X7Y1_RES2_O1(E_RES2[38]),
	.Tile_X7Y1_RES2_O2(E_RES2[37]),
	.Tile_X7Y1_RES2_O3(E_RES2[36]),
	.Tile_X7Y2_RES2_O0(E_RES2[35]),
	.Tile_X7Y2_RES2_O1(E_RES2[34]),
	.Tile_X7Y2_RES2_O2(E_RES2[33]),
	.Tile_X7Y2_RES2_O3(E_RES2[32]),
	.Tile_X7Y3_RES2_O0(E_RES2[31]),
	.Tile_X7Y3_RES2_O1(E_RES2[30]),
	.Tile_X7Y3_RES2_O2(E_RES2[29]),
	.Tile_X7Y3_RES2_O3(E_RES2[28]),
	.Tile_X7Y4_RES2_O0(E_RES2[27]),
	.Tile_X7Y4_RES2_O1(E_RES2[26]),
	.Tile_X7Y4_RES2_O2(E_RES2[25]),
	.Tile_X7Y4_RES2_O3(E_RES2[24]),
	.Tile_X7Y5_RES2_O0(E_RES2[23]),
	.Tile_X7Y5_RES2_O1(E_RES2[22]),
	.Tile_X7Y5_RES2_O2(E_RES2[21]),
	.Tile_X7Y5_RES2_O3(E_RES2[20]),
	.Tile_X7Y6_RES2_O0(E_RES2[19]),
	.Tile_X7Y6_RES2_O1(E_RES2[18]),
	.Tile_X7Y6_RES2_O2(E_RES2[17]),
	.Tile_X7Y6_RES2_O3(E_RES2[16]),
	.Tile_X7Y7_RES2_O0(E_RES2[15]),
	.Tile_X7Y7_RES2_O1(E_RES2[14]),
	.Tile_X7Y7_RES2_O2(E_RES2[13]),
	.Tile_X7Y7_RES2_O3(E_RES2[12]),
	.Tile_X7Y8_RES2_O0(E_RES2[11]),
	.Tile_X7Y8_RES2_O1(E_RES2[10]),
	.Tile_X7Y8_RES2_O2(E_RES2[9]),
	.Tile_X7Y8_RES2_O3(E_RES2[8]),
	.Tile_X7Y9_RES2_O0(E_RES2[7]),
	.Tile_X7Y9_RES2_O1(E_RES2[6]),
	.Tile_X7Y9_RES2_O2(E_RES2[5]),
	.Tile_X7Y9_RES2_O3(E_RES2[4]),
	.Tile_X7Y10_RES2_O0(E_RES2[3]),
	.Tile_X7Y10_RES2_O1(E_RES2[2]),
	.Tile_X7Y10_RES2_O2(E_RES2[1]),
	.Tile_X7Y10_RES2_O3(E_RES2[0]),

	//declarations
	.UserCLK(CLK),
	.FrameData(FrameData),
	.FrameStrobe(FrameSelect)
	);

	assign FrameData = {32'h12345678,FrameRegister,32'h12345678};

endmodule
