// Copyright lowRISC contributors.
// Copyright 2017 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
module forte_soc_top (
	clk_i,
	debug_req_i,
	fetch_enable_i,
	irq_ack_o,
	irq_i,
	irq_id_i,
	irq_id_o,
	reset,
	eFPGA_operand_a_o,
	eFPGA_operand_b_o,
	eFPGA_result_a_i,
	eFPGA_result_b_i,
	eFPGA_result_c_i,
	eFPGA_write_strobe_o,
	eFPGA_fpga_done_i,
	eFPGA_delay_o,
	eFPGA_en_o,
	eFPGA_operator_o,
	ext_data_addr_i,
	ext_data_be_i,
	ext_data_rdata_o,
	ext_data_req_i,
	ext_data_rvalid_o,
	ext_data_wdata_i,
	ext_data_we_i
);
	parameter ADDR_WIDTH = 10;
	input clk_i;
	input debug_req_i;
	input fetch_enable_i;
	output irq_ack_o;
	input irq_i;
	input [4:0] irq_id_i;
	output [4:0] irq_id_o;
	input reset;
	output [31:0] eFPGA_operand_a_o;
	output [31:0] eFPGA_operand_b_o;
	input [31:0] eFPGA_result_a_i;
	input [31:0] eFPGA_result_b_i;
	input [31:0] eFPGA_result_c_i;
	output eFPGA_write_strobe_o;
	input eFPGA_fpga_done_i;
	output eFPGA_en_o;
	output [1:0] eFPGA_operator_o;
	output [3:0] eFPGA_delay_o;
	wire [ADDR_WIDTH - 1:0] flexbex_data_addr_o;
	wire [3:0] flexbex_data_be_o;
	wire flexbex_data_gnt_i;
	wire [31:0] flexbex_data_rdata_i;
	wire flexbex_data_req_o;
	wire flexbex_data_rvalid_o;
	wire [31:0] flexbex_data_wdata_o;
	wire flexbex_data_we_o;
	input [ADDR_WIDTH - 1:0] ext_data_addr_i;
	input [3:0] ext_data_be_i;
	output [31:0] ext_data_rdata_o;
	input ext_data_req_i;
	output ext_data_rvalid_o;
	input [31:0] ext_data_wdata_i;
	input ext_data_we_i;
	wire [ADDR_WIDTH - 1:0] flexbex_instr_addr_o;
	wire flexbex_instr_gnt_o;
	wire [31:0] flexbex_instr_rdata_o;
	wire flexbex_instr_req_o;
	wire flexbex_instr_rvalid_o;
	wire flexbex_data_rdata_o;
	wire ext_data_wdata_o;
	ram ram_0(
		.clk(clk_i),
		.ibex_data_addr_i(flexbex_data_addr_o),
		.ibex_data_be_i(flexbex_data_be_o),
		.ibex_data_gnt_o(flexbex_data_gnt_i),
		.ibex_data_rdata_o(flexbex_data_rdata_o),
		.ibex_data_req_i(flexbex_data_req_o),
		.ibex_data_rvalid_o(flexbex_data_rvalid_o),
		.ibex_data_wdata_i(flexbex_data_wdata_o),
		.ibex_data_we_i(flexbex_data_we_o),
		.instr_addr_i(flexbex_instr_addr_o),
		.instr_gnt_o(flexbex_instr_gnt_o),
		.instr_rdata_o(flexbex_instr_rdata_o),
		.instr_req_i(flexbex_instr_req_o),
		.instr_rvalid_o(flexbex_instr_rvalid_o),
		.ext_data_addr_i(ext_data_addr_i),
		.ext_data_be_i(ext_data_be_i),
		.ext_data_rdata_o(ext_data_rdata_o),
		.ext_data_req_i(ext_data_req_i),
		.ext_data_rvalid_o(ext_data_rvalid_o),
		.ext_data_wdata_i(ext_data_wdata_o),
		.ext_data_we_i(ext_data_we_i)
	);
	wire reset_ni;
	assign reset_ni = ~reset;
	ibex_core ibex_core_i(
		.boot_addr_i(32'h00000000),
		.clk_i(clk_i),
		.cluster_id_i(6'd0),
		.core_id_i(4'd0),
		.data_addr_o(flexbex_data_addr_o),
		.data_be_o(flexbex_data_be_o),
		.data_err_i(1'b0),
		.data_gnt_i(flexbex_data_gnt_i),
		.data_rdata_i(flexbex_data_rdata_i),
		.data_req_o(flexbex_data_req_o),
		.data_rvalid_i(flexbex_data_rvalid_o),
		.data_wdata_o(flexbex_data_wdata_o),
		.data_we_o(flexbex_data_we_o),
		.debug_req_i(debug_req_i),
		.ext_perf_counters_i(1'b0),
		.fetch_enable_i(fetch_enable_i),
		.instr_addr_o(flexbex_instr_addr_o),
		.instr_gnt_i(flexbex_instr_gnt_o),
		.instr_rdata_i(flexbex_instr_rdata_o),
		.instr_req_o(flexbex_instr_req_o),
		.instr_rvalid_i(flexbex_instr_rvalid_o),
		.irq_ack_o(irq_ack_o),
		.irq_i(irq_i),
		.irq_id_i(irq_id_i),
		.irq_id_o(irq_id_o),
		.rst_ni(reset_ni),
		.test_en_i(1'b1),
		.eFPGA_operand_a_o(eFPGA_operand_a_o),
		.eFPGA_operand_b_o(eFPGA_operand_b_o),
		.eFPGA_result_a_i(eFPGA_result_a_i),
		.eFPGA_result_b_i(eFPGA_result_b_i),
		.eFPGA_result_c_i(eFPGA_result_c_i),
		.eFPGA_write_strobe_o(eFPGA_write_strobe_o),
		.eFPGA_fpga_done_i(eFPGA_fpga_done_i),
		.eFPGA_en_o(eFPGA_en_o),
		.eFPGA_operator_o(eFPGA_operator_o),
		.eFPGA_delay_o(eFPGA_delay_o)
	);
endmodule
module ibex_alu (
	operator_i,
	operand_a_i,
	operand_b_i,
	multdiv_operand_a_i,
	multdiv_operand_b_i,
	multdiv_en_i,
	adder_result_o,
	adder_result_ext_o,
	result_o,
	comparison_result_o,
	is_equal_result_o
);
	input wire [4:0] operator_i;
	input wire [31:0] operand_a_i;
	input wire [31:0] operand_b_i;
	input wire [32:0] multdiv_operand_a_i;
	input wire [32:0] multdiv_operand_b_i;
	input wire multdiv_en_i;
	output wire [31:0] adder_result_o;
	output wire [33:0] adder_result_ext_o;
	output reg [31:0] result_o;
	output wire comparison_result_o;
	output wire is_equal_result_o;
	wire [31:0] operand_a_rev;
	wire [32:0] operand_b_neg;
	generate
		genvar k;
		for (k = 0; k < 32; k = k + 1) begin : gen_revloop
			assign operand_a_rev[k] = operand_a_i[31 - k];
		end
	endgenerate
	reg adder_op_b_negate;
	wire [32:0] adder_in_a;
	wire [32:0] adder_in_b;
	wire [31:0] adder_result;
	localparam [4:0] ibex_defines_ALU_EQ = 16;
	localparam [4:0] ibex_defines_ALU_GE = 14;
	localparam [4:0] ibex_defines_ALU_GEU = 15;
	localparam [4:0] ibex_defines_ALU_GT = 12;
	localparam [4:0] ibex_defines_ALU_GTU = 13;
	localparam [4:0] ibex_defines_ALU_LE = 10;
	localparam [4:0] ibex_defines_ALU_LEU = 11;
	localparam [4:0] ibex_defines_ALU_LT = 8;
	localparam [4:0] ibex_defines_ALU_LTU = 9;
	localparam [4:0] ibex_defines_ALU_NE = 17;
	localparam [4:0] ibex_defines_ALU_SLET = 20;
	localparam [4:0] ibex_defines_ALU_SLETU = 21;
	localparam [4:0] ibex_defines_ALU_SLT = 18;
	localparam [4:0] ibex_defines_ALU_SLTU = 19;
	localparam [4:0] ibex_defines_ALU_SUB = 1;
	always @(*) begin
		adder_op_b_negate = 1'b0;
		case (operator_i)
			ibex_defines_ALU_SUB, ibex_defines_ALU_EQ, ibex_defines_ALU_NE, ibex_defines_ALU_GTU, ibex_defines_ALU_GEU, ibex_defines_ALU_LTU, ibex_defines_ALU_LEU, ibex_defines_ALU_GT, ibex_defines_ALU_GE, ibex_defines_ALU_LT, ibex_defines_ALU_LE, ibex_defines_ALU_SLT, ibex_defines_ALU_SLTU, ibex_defines_ALU_SLET, ibex_defines_ALU_SLETU: adder_op_b_negate = 1'b1;
			default:
				;
		endcase
	end
	assign adder_in_a = (multdiv_en_i ? multdiv_operand_a_i : {operand_a_i, 1'b1});
	assign operand_b_neg = {operand_b_i, 1'b0} ^ {33 {adder_op_b_negate}};
	assign adder_in_b = (multdiv_en_i ? multdiv_operand_b_i : operand_b_neg);
	assign adder_result_ext_o = $unsigned(adder_in_a) + $unsigned(adder_in_b);
	assign adder_result = adder_result_ext_o[32:1];
	assign adder_result_o = adder_result;
	wire shift_left;
	wire shift_arithmetic;
	wire [4:0] shift_amt;
	wire [31:0] shift_op_a;
	wire [31:0] shift_result;
	wire [31:0] shift_right_result;
	wire [31:0] shift_left_result;
	assign shift_amt = operand_b_i[4:0];
	localparam [4:0] ibex_defines_ALU_SLL = 7;
	assign shift_left = operator_i == ibex_defines_ALU_SLL;
	localparam [4:0] ibex_defines_ALU_SRA = 5;
	assign shift_arithmetic = operator_i == ibex_defines_ALU_SRA;
	assign shift_op_a = (shift_left ? operand_a_rev : operand_a_i);
	wire [32:0] shift_op_a_32;
	assign shift_op_a_32 = {shift_arithmetic & shift_op_a[31], shift_op_a};
	wire signed [32:0] shift_right_result_signed;
	assign shift_right_result_signed = $signed(shift_op_a_32) >>> shift_amt[4:0];
	assign shift_right_result = shift_right_result_signed[31:0];
	generate
		genvar j;
		for (j = 0; j < 32; j = j + 1) begin : gen_resrevloop
			assign shift_left_result[j] = shift_right_result[31 - j];
		end
	endgenerate
	assign shift_result = (shift_left ? shift_left_result : shift_right_result);
	wire is_equal;
	reg is_greater_equal;
	reg cmp_signed;
	always @(*) begin
		cmp_signed = 1'b0;
		case (operator_i)
			ibex_defines_ALU_GT, ibex_defines_ALU_GE, ibex_defines_ALU_LT, ibex_defines_ALU_LE, ibex_defines_ALU_SLT, ibex_defines_ALU_SLET: cmp_signed = 1'b1;
			default:
				;
		endcase
	end
	assign is_equal = adder_result == 32'b00000000000000000000000000000000;
	assign is_equal_result_o = is_equal;
	always @(*)
		if ((operand_a_i[31] ^ operand_b_i[31]) == 1'b0)
			is_greater_equal = adder_result[31] == 1'b0;
		else
			is_greater_equal = operand_a_i[31] ^ cmp_signed;
	reg cmp_result;
	always @(*) begin
		cmp_result = is_equal;
		case (operator_i)
			ibex_defines_ALU_EQ: cmp_result = is_equal;
			ibex_defines_ALU_NE: cmp_result = ~is_equal;
			ibex_defines_ALU_GT, ibex_defines_ALU_GTU: cmp_result = is_greater_equal & ~is_equal;
			ibex_defines_ALU_GE, ibex_defines_ALU_GEU: cmp_result = is_greater_equal;
			ibex_defines_ALU_LT, ibex_defines_ALU_SLT, ibex_defines_ALU_LTU, ibex_defines_ALU_SLTU: cmp_result = ~is_greater_equal;
			ibex_defines_ALU_SLET, ibex_defines_ALU_SLETU, ibex_defines_ALU_LE, ibex_defines_ALU_LEU: cmp_result = ~is_greater_equal | is_equal;
			default:
				;
		endcase
	end
	assign comparison_result_o = cmp_result;
	localparam [4:0] ibex_defines_ALU_ADD = 0;
	localparam [4:0] ibex_defines_ALU_AND = 4;
	localparam [4:0] ibex_defines_ALU_OR = 3;
	localparam [4:0] ibex_defines_ALU_SRL = 6;
	localparam [4:0] ibex_defines_ALU_XOR = 2;
	always @(*) begin
		result_o = {32 {1'sb0}};
		case (operator_i)
			ibex_defines_ALU_AND: result_o = operand_a_i & operand_b_i;
			ibex_defines_ALU_OR: result_o = operand_a_i | operand_b_i;
			ibex_defines_ALU_XOR: result_o = operand_a_i ^ operand_b_i;
			ibex_defines_ALU_ADD, ibex_defines_ALU_SUB: result_o = adder_result;
			ibex_defines_ALU_SLL, ibex_defines_ALU_SRL, ibex_defines_ALU_SRA: result_o = shift_result;
			ibex_defines_ALU_EQ, ibex_defines_ALU_NE, ibex_defines_ALU_GTU, ibex_defines_ALU_GEU, ibex_defines_ALU_LTU, ibex_defines_ALU_LEU, ibex_defines_ALU_GT, ibex_defines_ALU_GE, ibex_defines_ALU_LT, ibex_defines_ALU_LE, ibex_defines_ALU_SLT, ibex_defines_ALU_SLTU, ibex_defines_ALU_SLET, ibex_defines_ALU_SLETU: result_o = {31'h00000000, cmp_result};
			default:
				;
		endcase
	end
endmodule
module ibex_compressed_decoder (
	instr_i,
	instr_o,
	is_compressed_o,
	illegal_instr_o
);
	input wire [31:0] instr_i;
	output reg [31:0] instr_o;
	output wire is_compressed_o;
	output reg illegal_instr_o;
	localparam [6:0] ibex_defines_OPCODE_BRANCH = 7'h63;
	localparam [6:0] ibex_defines_OPCODE_JAL = 7'h6f;
	localparam [6:0] ibex_defines_OPCODE_JALR = 7'h67;
	localparam [6:0] ibex_defines_OPCODE_LOAD = 7'h03;
	localparam [6:0] ibex_defines_OPCODE_LUI = 7'h37;
	localparam [6:0] ibex_defines_OPCODE_OP = 7'h33;
	localparam [6:0] ibex_defines_OPCODE_OPIMM = 7'h13;
	localparam [6:0] ibex_defines_OPCODE_STORE = 7'h23;
	always @(*) begin
		illegal_instr_o = 1'b0;
		instr_o = {32 {1'sb0}};
		case (instr_i[1:0])
			2'b00:
				case (instr_i[15:13])
					3'b000: begin
						instr_o = {2'b00, instr_i[10:7], instr_i[12:11], instr_i[5], instr_i[6], 2'b00, 5'h02, 3'b000, 2'b01, instr_i[4:2], {ibex_defines_OPCODE_OPIMM}};
						if (instr_i[12:5] == 8'b00000000)
							illegal_instr_o = 1'b1;
					end
					3'b010: instr_o = {5'b00000, instr_i[5], instr_i[12:10], instr_i[6], 2'b00, 2'b01, instr_i[9:7], 3'b010, 2'b01, instr_i[4:2], {ibex_defines_OPCODE_LOAD}};
					3'b110: instr_o = {5'b00000, instr_i[5], instr_i[12], 2'b01, instr_i[4:2], 2'b01, instr_i[9:7], 3'b010, instr_i[11:10], instr_i[6], 2'b00, {ibex_defines_OPCODE_STORE}};
					default: illegal_instr_o = 1'b1;
				endcase
			2'b01:
				case (instr_i[15:13])
					3'b000: instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2], instr_i[11:7], 3'b000, instr_i[11:7], {ibex_defines_OPCODE_OPIMM}};
					3'b001, 3'b101: instr_o = {instr_i[12], instr_i[8], instr_i[10:9], instr_i[6], instr_i[7], instr_i[2], instr_i[11], instr_i[5:3], {9 {instr_i[12]}}, 4'b0000, ~instr_i[15], {ibex_defines_OPCODE_JAL}};
					3'b010: begin
						instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2], 5'b00000, 3'b000, instr_i[11:7], {ibex_defines_OPCODE_OPIMM}};
						if (instr_i[11:7] == 5'b00000)
							illegal_instr_o = 1'b1;
					end
					3'b011: begin
						instr_o = {{15 {instr_i[12]}}, instr_i[6:2], instr_i[11:7], {ibex_defines_OPCODE_LUI}};
						if (instr_i[11:7] == 5'h02)
							instr_o = {{3 {instr_i[12]}}, instr_i[4:3], instr_i[5], instr_i[2], instr_i[6], 4'b0000, 5'h02, 3'b000, 5'h02, {ibex_defines_OPCODE_OPIMM}};
						else if (instr_i[11:7] == 5'b00000)
							illegal_instr_o = 1'b1;
						if ({instr_i[12], instr_i[6:2]} == 6'b000000)
							illegal_instr_o = 1'b1;
					end
					3'b100:
						case (instr_i[11:10])
							2'b00, 2'b01: begin
								instr_o = {1'b0, instr_i[10], 5'b00000, instr_i[6:2], 2'b01, instr_i[9:7], 3'b101, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OPIMM}};
								if (instr_i[12] == 1'b1)
									illegal_instr_o = 1'b1;
								if (instr_i[6:2] == 5'b00000)
									illegal_instr_o = 1'b1;
							end
							2'b10: instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2], 2'b01, instr_i[9:7], 3'b111, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OPIMM}};
							2'b11:
								case ({instr_i[12], instr_i[6:5]})
									3'b000: instr_o = {9'b010000001, instr_i[4:2], 2'b01, instr_i[9:7], 3'b000, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OP}};
									3'b001: instr_o = {9'b000000001, instr_i[4:2], 2'b01, instr_i[9:7], 3'b100, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OP}};
									3'b010: instr_o = {9'b000000001, instr_i[4:2], 2'b01, instr_i[9:7], 3'b110, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OP}};
									3'b011: instr_o = {9'b000000001, instr_i[4:2], 2'b01, instr_i[9:7], 3'b111, 2'b01, instr_i[9:7], {ibex_defines_OPCODE_OP}};
									3'b100, 3'b101, 3'b110, 3'b111: illegal_instr_o = 1'b1;
								endcase
						endcase
					3'b110, 3'b111: instr_o = {{4 {instr_i[12]}}, instr_i[6:5], instr_i[2], 5'b00000, 2'b01, instr_i[9:7], 2'b00, instr_i[13], instr_i[11:10], instr_i[4:3], instr_i[12], {ibex_defines_OPCODE_BRANCH}};
					default:
						;
				endcase
			2'b10:
				case (instr_i[15:13])
					3'b000: begin
						instr_o = {7'b0000000, instr_i[6:2], instr_i[11:7], 3'b001, instr_i[11:7], {ibex_defines_OPCODE_OPIMM}};
						if (instr_i[11:7] == 5'b00000)
							illegal_instr_o = 1'b1;
						if ((instr_i[12] == 1'b1) || (instr_i[6:2] == 5'b00000))
							illegal_instr_o = 1'b1;
					end
					3'b010: begin
						instr_o = {4'b0000, instr_i[3:2], instr_i[12], instr_i[6:4], 2'b00, 5'h02, 3'b010, instr_i[11:7], ibex_defines_OPCODE_LOAD};
						if (instr_i[11:7] == 5'b00000)
							illegal_instr_o = 1'b1;
					end
					3'b100:
						if (instr_i[12] == 1'b0) begin
							instr_o = {7'b0000000, instr_i[6:2], 5'b00000, 3'b000, instr_i[11:7], {ibex_defines_OPCODE_OP}};
							if (instr_i[6:2] == 5'b00000)
								instr_o = {12'b000000000000, instr_i[11:7], 3'b000, 5'b00000, {ibex_defines_OPCODE_JALR}};
						end
						else begin
							instr_o = {7'b0000000, instr_i[6:2], instr_i[11:7], 3'b000, instr_i[11:7], {ibex_defines_OPCODE_OP}};
							if (instr_i[11:7] == 5'b00000) begin
								instr_o = 32'h00100073;
								if (instr_i[6:2] != 5'b00000)
									illegal_instr_o = 1'b1;
							end
							else if (instr_i[6:2] == 5'b00000)
								instr_o = {12'b000000000000, instr_i[11:7], 3'b000, 5'b00001, {ibex_defines_OPCODE_JALR}};
						end
					3'b110: instr_o = {4'b0000, instr_i[8:7], instr_i[12], instr_i[6:2], 5'h02, 3'b010, instr_i[11:9], 2'b00, {ibex_defines_OPCODE_STORE}};
					default: illegal_instr_o = 1'b1;
				endcase
			default: instr_o = instr_i;
		endcase
	end
	assign is_compressed_o = instr_i[1:0] != 2'b11;
endmodule
module ibex_controller (
	clk,
	rst_n,
	fetch_enable_i,
	ctrl_busy_o,
	first_fetch_o,
	is_decoding_o,
	deassert_we_o,
	illegal_insn_i,
	ecall_insn_i,
	mret_insn_i,
	dret_insn_i,
	pipe_flush_i,
	ebrk_insn_i,
	csr_status_i,
	instr_valid_i,
	instr_req_o,
	pc_set_o,
	pc_mux_o,
	exc_pc_mux_o,
	data_misaligned_i,
	branch_in_id_i,
	branch_set_i,
	jump_set_i,
	instr_multicyle_i,
	irq_i,
	irq_req_ctrl_i,
	irq_id_ctrl_i,
	m_IE_i,
	irq_ack_o,
	irq_id_o,
	exc_cause_o,
	exc_ack_o,
	exc_kill_o,
	debug_req_i,
	debug_cause_o,
	debug_csr_save_o,
	debug_single_step_i,
	debug_ebreakm_i,
	csr_save_if_o,
	csr_save_id_o,
	csr_cause_o,
	csr_restore_mret_id_o,
	csr_restore_dret_id_o,
	csr_save_cause_o,
	operand_a_fw_mux_sel_o,
	halt_if_o,
	halt_id_o,
	id_ready_i,
	perf_jump_o,
	perf_tbranch_o
);
	input wire clk;
	input wire rst_n;
	input wire fetch_enable_i;
	output reg ctrl_busy_o;
	output reg first_fetch_o;
	output reg is_decoding_o;
	output wire deassert_we_o;
	input wire illegal_insn_i;
	input wire ecall_insn_i;
	input wire mret_insn_i;
	input wire dret_insn_i;
	input wire pipe_flush_i;
	input wire ebrk_insn_i;
	input wire csr_status_i;
	input wire instr_valid_i;
	output reg instr_req_o;
	output reg pc_set_o;
	output reg [2:0] pc_mux_o;
	output reg [2:0] exc_pc_mux_o;
	input wire data_misaligned_i;
	input wire branch_in_id_i;
	input wire branch_set_i;
	input wire jump_set_i;
	input wire instr_multicyle_i;
	input wire irq_i;
	input wire irq_req_ctrl_i;
	input wire [4:0] irq_id_ctrl_i;
	input wire m_IE_i;
	output reg irq_ack_o;
	output reg [4:0] irq_id_o;
	output reg [5:0] exc_cause_o;
	output reg exc_ack_o;
	output reg exc_kill_o;
	input wire debug_req_i;
	output reg [2:0] debug_cause_o;
	output reg debug_csr_save_o;
	input wire debug_single_step_i;
	input wire debug_ebreakm_i;
	output reg csr_save_if_o;
	output reg csr_save_id_o;
	output reg [5:0] csr_cause_o;
	output reg csr_restore_mret_id_o;
	output reg csr_restore_dret_id_o;
	output reg csr_save_cause_o;
	output wire operand_a_fw_mux_sel_o;
	output reg halt_if_o;
	output reg halt_id_o;
	input wire id_ready_i;
	output reg perf_jump_o;
	output reg perf_tbranch_o;
	reg [3:0] ctrl_fsm_cs;
	reg [3:0] ctrl_fsm_ns;
	reg irq_enable_int;
	reg debug_mode_q;
	reg debug_mode_n;
	always @(negedge clk)
		if (is_decoding_o && illegal_insn_i)
			$display("%t: Illegal instruction (core %0d) at PC 0x%h: 0x%h", $time, ibex_core.core_id_i, ibex_id_stage.pc_id_i, ibex_id_stage.instr_rdata_i);
	localparam [3:0] BOOT_SET = 1;
	localparam [3:0] DBG_TAKEN_ID = 9;
	localparam [3:0] DBG_TAKEN_IF = 8;
	localparam [3:0] DECODE = 5;
	localparam [3:0] FIRST_FETCH = 4;
	localparam [3:0] FLUSH = 6;
	localparam [3:0] IRQ_TAKEN = 7;
	localparam [3:0] RESET = 0;
	localparam [3:0] SLEEP = 3;
	localparam [3:0] WAIT_SLEEP = 2;
	localparam [2:0] ibex_defines_DBG_CAUSE_EBREAK = 3'h1;
	localparam [2:0] ibex_defines_DBG_CAUSE_HALTREQ = 3'h3;
	localparam [2:0] ibex_defines_DBG_CAUSE_STEP = 3'h4;
	localparam [5:0] ibex_defines_EXC_CAUSE_BREAKPOINT = 6'h03;
	localparam [5:0] ibex_defines_EXC_CAUSE_CLEAR = 6'h00;
	localparam [5:0] ibex_defines_EXC_CAUSE_ECALL_MMODE = 6'h0b;
	localparam [5:0] ibex_defines_EXC_CAUSE_ILLEGAL_INSN = 6'h02;
	localparam [2:0] ibex_defines_EXC_PC_BREAKPOINT = 7;
	localparam [2:0] ibex_defines_EXC_PC_DBD = 5;
	localparam [2:0] ibex_defines_EXC_PC_DBGEXC = 6;
	localparam [2:0] ibex_defines_EXC_PC_ECALL = 1;
	localparam [2:0] ibex_defines_EXC_PC_ILLINSN = 0;
	localparam [2:0] ibex_defines_EXC_PC_IRQ = 4;
	localparam [2:0] ibex_defines_PC_BOOT = 0;
	localparam [2:0] ibex_defines_PC_DRET = 4;
	localparam [2:0] ibex_defines_PC_ERET = 3;
	localparam [2:0] ibex_defines_PC_EXCEPTION = 2;
	localparam [2:0] ibex_defines_PC_JUMP = 1;
	function automatic [5:0] sv2v_cast_6;
		input reg [5:0] inp;
		sv2v_cast_6 = inp;
	endfunction
	always @(*) begin
		instr_req_o = 1'b1;
		exc_ack_o = 1'b0;
		exc_kill_o = 1'b0;
		csr_save_if_o = 1'b0;
		csr_save_id_o = 1'b0;
		csr_restore_mret_id_o = 1'b0;
		csr_restore_dret_id_o = 1'b0;
		csr_save_cause_o = 1'b0;
		exc_cause_o = ibex_defines_EXC_CAUSE_CLEAR;
		exc_pc_mux_o = ibex_defines_EXC_PC_IRQ;
		csr_cause_o = ibex_defines_EXC_CAUSE_CLEAR;
		pc_mux_o = ibex_defines_PC_BOOT;
		pc_set_o = 1'b0;
		ctrl_fsm_ns = ctrl_fsm_cs;
		ctrl_busy_o = 1'b1;
		is_decoding_o = 1'b0;
		first_fetch_o = 1'b0;
		halt_if_o = 1'b0;
		halt_id_o = 1'b0;
		irq_ack_o = 1'b0;
		irq_id_o = irq_id_ctrl_i;
		irq_enable_int = m_IE_i;
		debug_csr_save_o = 1'b0;
		debug_cause_o = ibex_defines_DBG_CAUSE_EBREAK;
		debug_mode_n = debug_mode_q;
		perf_tbranch_o = 1'b0;
		perf_jump_o = 1'b0;
		case (ctrl_fsm_cs)
			RESET: begin
				instr_req_o = 1'b0;
				pc_mux_o = ibex_defines_PC_BOOT;
				pc_set_o = 1'b1;
				if (fetch_enable_i)
					ctrl_fsm_ns = BOOT_SET;
			end
			BOOT_SET: begin
				instr_req_o = 1'b1;
				pc_mux_o = ibex_defines_PC_BOOT;
				pc_set_o = 1'b1;
				ctrl_fsm_ns = FIRST_FETCH;
			end
			WAIT_SLEEP: begin
				ctrl_busy_o = 1'b0;
				instr_req_o = 1'b0;
				halt_if_o = 1'b1;
				halt_id_o = 1'b1;
				ctrl_fsm_ns = SLEEP;
			end
			SLEEP: begin
				ctrl_busy_o = 1'b0;
				instr_req_o = 1'b0;
				halt_if_o = 1'b1;
				halt_id_o = 1'b1;
				if (((irq_i || debug_req_i) || debug_mode_q) || debug_single_step_i)
					ctrl_fsm_ns = FIRST_FETCH;
			end
			FIRST_FETCH: begin
				first_fetch_o = 1'b1;
				if (id_ready_i)
					ctrl_fsm_ns = DECODE;
				if (irq_req_ctrl_i && irq_enable_int) begin
					ctrl_fsm_ns = IRQ_TAKEN;
					halt_if_o = 1'b1;
					halt_id_o = 1'b1;
				end
				if (debug_req_i && !debug_mode_q) begin
					ctrl_fsm_ns = DBG_TAKEN_IF;
					halt_if_o = 1'b1;
					halt_id_o = 1'b1;
				end
			end
			DECODE: begin
				is_decoding_o = 1'b0;
				case (1'b1)
					debug_req_i && !debug_mode_q: begin
						ctrl_fsm_ns = DBG_TAKEN_ID;
						halt_if_o = 1'b1;
						halt_id_o = 1'b1;
					end
					((irq_req_ctrl_i && irq_enable_int) && !debug_req_i) && !debug_mode_q: begin
						ctrl_fsm_ns = IRQ_TAKEN;
						halt_if_o = 1'b1;
						halt_id_o = 1'b1;
					end
					default: begin
						exc_kill_o = (irq_req_ctrl_i & ~instr_multicyle_i) & ~branch_in_id_i;
						if (instr_valid_i) begin
							is_decoding_o = 1'b1;
							if (branch_set_i || jump_set_i) begin
								pc_mux_o = ibex_defines_PC_JUMP;
								pc_set_o = 1'b1;
								perf_tbranch_o = branch_set_i;
								perf_jump_o = jump_set_i;
							end
							else if ((((((mret_insn_i || dret_insn_i) || ecall_insn_i) || pipe_flush_i) || ebrk_insn_i) || illegal_insn_i) || csr_status_i) begin
								ctrl_fsm_ns = FLUSH;
								halt_if_o = 1'b1;
								halt_id_o = 1'b1;
							end
						end
					end
				endcase
				if (debug_single_step_i && !debug_mode_q) begin
					halt_if_o = 1'b1;
					ctrl_fsm_ns = DBG_TAKEN_IF;
				end
			end
			IRQ_TAKEN: begin
				pc_mux_o = ibex_defines_PC_EXCEPTION;
				pc_set_o = 1'b1;
				exc_pc_mux_o = ibex_defines_EXC_PC_IRQ;
				exc_cause_o = sv2v_cast_6({1'b0, irq_id_ctrl_i});
				csr_save_cause_o = 1'b1;
				csr_cause_o = sv2v_cast_6({1'b1, irq_id_ctrl_i});
				csr_save_if_o = 1'b1;
				irq_ack_o = 1'b1;
				exc_ack_o = 1'b1;
				ctrl_fsm_ns = DECODE;
			end
			DBG_TAKEN_IF: begin
				pc_mux_o = ibex_defines_PC_EXCEPTION;
				pc_set_o = 1'b1;
				exc_pc_mux_o = ibex_defines_EXC_PC_DBD;
				csr_save_if_o = 1'b1;
				debug_csr_save_o = 1'b1;
				csr_save_cause_o = 1'b1;
				if (debug_single_step_i)
					debug_cause_o = ibex_defines_DBG_CAUSE_STEP;
				else if (debug_req_i)
					debug_cause_o = ibex_defines_DBG_CAUSE_HALTREQ;
				else if (ebrk_insn_i)
					debug_cause_o = ibex_defines_DBG_CAUSE_EBREAK;
				debug_mode_n = 1'b1;
				ctrl_fsm_ns = DECODE;
			end
			DBG_TAKEN_ID: begin
				pc_mux_o = ibex_defines_PC_EXCEPTION;
				pc_set_o = 1'b1;
				exc_pc_mux_o = ibex_defines_EXC_PC_DBD;
				if (((ebrk_insn_i && debug_ebreakm_i) && !debug_mode_q) || (debug_req_i && !debug_mode_q)) begin
					csr_save_cause_o = 1'b1;
					csr_save_id_o = 1'b1;
					debug_csr_save_o = 1'b1;
					if (debug_req_i)
						debug_cause_o = ibex_defines_DBG_CAUSE_HALTREQ;
					else if (ebrk_insn_i)
						debug_cause_o = ibex_defines_DBG_CAUSE_EBREAK;
				end
				debug_mode_n = 1'b1;
				ctrl_fsm_ns = DECODE;
			end
			FLUSH: begin
				halt_if_o = 1'b1;
				halt_id_o = 1'b1;
				if (!pipe_flush_i)
					ctrl_fsm_ns = DECODE;
				else
					ctrl_fsm_ns = WAIT_SLEEP;
				case (1'b1)
					ecall_insn_i: begin
						pc_mux_o = ibex_defines_PC_EXCEPTION;
						pc_set_o = 1'b1;
						csr_save_id_o = 1'b1;
						csr_save_cause_o = 1'b1;
						exc_pc_mux_o = ibex_defines_EXC_PC_ECALL;
						exc_cause_o = ibex_defines_EXC_CAUSE_ECALL_MMODE;
						csr_cause_o = ibex_defines_EXC_CAUSE_ECALL_MMODE;
					end
					illegal_insn_i: begin
						pc_mux_o = ibex_defines_PC_EXCEPTION;
						pc_set_o = 1'b1;
						csr_save_id_o = 1'b1;
						csr_save_cause_o = 1'b1;
						if (debug_mode_q)
							exc_pc_mux_o = ibex_defines_EXC_PC_DBGEXC;
						else
							exc_pc_mux_o = ibex_defines_EXC_PC_ILLINSN;
						exc_cause_o = ibex_defines_EXC_CAUSE_ILLEGAL_INSN;
						csr_cause_o = ibex_defines_EXC_CAUSE_ILLEGAL_INSN;
					end
					mret_insn_i: begin
						pc_mux_o = ibex_defines_PC_ERET;
						pc_set_o = 1'b1;
						csr_restore_mret_id_o = 1'b1;
					end
					dret_insn_i: begin
						pc_mux_o = ibex_defines_PC_DRET;
						pc_set_o = 1'b1;
						debug_mode_n = 1'b0;
						csr_restore_dret_id_o = 1'b1;
					end
					ebrk_insn_i:
						if (debug_mode_q)
							ctrl_fsm_ns = DBG_TAKEN_ID;
						else if (debug_ebreakm_i)
							ctrl_fsm_ns = DBG_TAKEN_ID;
						else begin
							pc_mux_o = ibex_defines_PC_EXCEPTION;
							pc_set_o = 1'b1;
							csr_save_id_o = 1'b1;
							csr_save_cause_o = 1'b1;
							exc_pc_mux_o = ibex_defines_EXC_PC_BREAKPOINT;
							exc_cause_o = ibex_defines_EXC_CAUSE_BREAKPOINT;
							csr_cause_o = ibex_defines_EXC_CAUSE_BREAKPOINT;
						end
					default:
						;
				endcase
			end
			default: begin
				instr_req_o = 1'b0;
				ctrl_fsm_ns = RESET;
			end
		endcase
	end
	assign deassert_we_o = ~is_decoding_o | illegal_insn_i;
	localparam [0:0] ibex_defines_SEL_MISALIGNED = 1;
	localparam [0:0] ibex_defines_SEL_REGFILE = 0;
	assign operand_a_fw_mux_sel_o = (data_misaligned_i ? ibex_defines_SEL_MISALIGNED : ibex_defines_SEL_REGFILE);
	always @(posedge clk or negedge rst_n) begin : UPDATE_REGS
		if (!rst_n) begin
			ctrl_fsm_cs <= RESET;
			debug_mode_q <= 1'b0;
		end
		else begin
			ctrl_fsm_cs <= ctrl_fsm_ns;
			debug_mode_q <= debug_mode_n;
		end
	end
endmodule
module ibex_core (
	clk_i,
	rst_ni,
	test_en_i,
	core_id_i,
	cluster_id_i,
	boot_addr_i,
	instr_req_o,
	instr_gnt_i,
	instr_rvalid_i,
	instr_addr_o,
	instr_rdata_i,
	data_req_o,
	data_gnt_i,
	data_rvalid_i,
	data_we_o,
	data_be_o,
	data_addr_o,
	data_wdata_o,
	data_rdata_i,
	data_err_i,
	irq_i,
	irq_id_i,
	irq_ack_o,
	irq_id_o,
	debug_req_i,
	fetch_enable_i,
	ext_perf_counters_i,
	eFPGA_operand_a_o,
	eFPGA_operand_b_o,
	eFPGA_result_a_i,
	eFPGA_result_b_i,
	eFPGA_result_c_i,
	eFPGA_write_strobe_o,
	eFPGA_fpga_done_i,
	eFPGA_en_o,
	eFPGA_operator_o,
	eFPGA_delay_o
);
	parameter N_EXT_PERF_COUNTERS = 1;
	parameter [0:0] RV32E = 0;
	parameter [0:0] RV32M = 1;
	parameter DM_HALT_ADDRESS = 32'h000000d8;
	parameter DM_EXCEPTION_ADDRESS = 32'h000000f4;
	input wire clk_i;
	input wire rst_ni;
	input wire test_en_i;
	input wire [3:0] core_id_i;
	input wire [5:0] cluster_id_i;
	input wire [31:0] boot_addr_i;
	output wire instr_req_o;
	input wire instr_gnt_i;
	input wire instr_rvalid_i;
	output wire [31:0] instr_addr_o;
	input wire [31:0] instr_rdata_i;
	output wire data_req_o;
	input wire data_gnt_i;
	input wire data_rvalid_i;
	output wire data_we_o;
	output wire [3:0] data_be_o;
	output wire [31:0] data_addr_o;
	output wire [31:0] data_wdata_o;
	input wire [31:0] data_rdata_i;
	input wire data_err_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	output wire irq_ack_o;
	output wire [4:0] irq_id_o;
	input wire debug_req_i;
	input wire fetch_enable_i;
	input wire [N_EXT_PERF_COUNTERS - 1:0] ext_perf_counters_i;
	output wire [31:0] eFPGA_operand_a_o;
	output wire [31:0] eFPGA_operand_b_o;
	input wire [31:0] eFPGA_result_a_i;
	input wire [31:0] eFPGA_result_b_i;
	input wire [31:0] eFPGA_result_c_i;
	output wire eFPGA_write_strobe_o;
	input eFPGA_fpga_done_i;
	output eFPGA_en_o;
	output [1:0] eFPGA_operator_o;
	output [3:0] eFPGA_delay_o;
	wire eFPGA_en;
	assign eFPGA_en_o = eFPGA_en;
	wire [1:0] eFPGA_operator;
	assign eFPGA_operator_o = eFPGA_operator;
	wire [3:0] eFPGA_delay;
	assign eFPGA_delay_o = eFPGA_delay;
	wire instr_valid_id;
	wire [31:0] instr_rdata_id;
	wire is_compressed_id;
	wire illegal_c_insn_id;
	wire [31:0] pc_if;
	wire [31:0] pc_id;
	wire clear_instr_valid;
	wire pc_set;
	wire [2:0] pc_mux_id;
	wire [2:0] exc_pc_mux_id;
	wire [5:0] exc_cause;
	wire lsu_load_err;
	wire lsu_store_err;
	wire is_decoding;
	wire data_misaligned;
	wire [31:0] misaligned_addr;
	wire [31:0] jump_target_ex;
	wire branch_decision;
	wire ctrl_busy;
	wire if_busy;
	wire lsu_busy;
	wire core_busy;
	wire core_ctrl_firstfetch;
	wire core_busy_int;
	reg core_busy_q;
	wire [4:0] alu_operator_ex;
	wire [31:0] alu_operand_a_ex;
	wire [31:0] alu_operand_b_ex;
	wire [31:0] alu_adder_result_ex;
	wire [31:0] regfile_wdata_ex;
	wire mult_en_ex;
	wire div_en_ex;
	wire [1:0] multdiv_operator_ex;
	wire [1:0] multdiv_signed_mode_ex;
	wire [31:0] multdiv_operand_a_ex;
	wire [31:0] multdiv_operand_b_ex;
	wire csr_access_ex;
	wire [1:0] csr_op_ex;
	wire csr_access;
	wire [1:0] csr_op;
	wire [11:0] csr_addr;
	wire [31:0] csr_rdata;
	wire [31:0] csr_wdata;
	wire data_we_ex;
	wire [1:0] data_type_ex;
	wire data_sign_ext_ex;
	wire [1:0] data_reg_offset_ex;
	wire data_req_ex;
	wire [31:0] data_wdata_ex;
	wire [31:0] regfile_wdata_lsu;
	wire halt_if;
	wire id_ready;
	wire ex_ready;
	wire if_valid;
	wire id_valid;
	wire data_valid_lsu;
	wire instr_req_int;
	wire m_irq_enable;
	wire [31:0] mepc;
	wire [31:0] depc;
	wire csr_save_cause;
	wire csr_save_if;
	wire csr_save_id;
	wire [5:0] csr_cause;
	wire csr_restore_mret_id;
	wire csr_restore_dret_id;
	wire [2:0] debug_cause;
	wire debug_csr_save;
	wire debug_single_step;
	wire debug_ebreakm;
	wire perf_imiss;
	wire perf_jump;
	wire perf_branch;
	wire perf_tbranch;
	wire clk;
	wire clock_en;
	assign core_busy_int = (if_busy | ctrl_busy) | lsu_busy;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			core_busy_q <= 1'b0;
		else
			core_busy_q <= core_busy_int;
	assign core_busy = (core_ctrl_firstfetch ? 1'b1 : core_busy_q);
	assign clock_en = (core_busy | irq_i) | debug_req_i;
	prim_clock_gating core_clock_gate_i(
		.clk_i(clk_i),
		.en_i(clock_en),
		.test_en_i(test_en_i),
		.clk_o(clk)
	);
	ibex_if_stage #(
		.DM_HALT_ADDRESS(DM_HALT_ADDRESS),
		.DM_EXCEPTION_ADDRESS(DM_EXCEPTION_ADDRESS)
	) if_stage_i(
		.clk(clk),
		.rst_n(rst_ni),
		.boot_addr_i(boot_addr_i),
		.req_i(instr_req_int),
		.instr_req_o(instr_req_o),
		.instr_addr_o(instr_addr_o),
		.instr_gnt_i(instr_gnt_i),
		.instr_rvalid_i(instr_rvalid_i),
		.instr_rdata_i(instr_rdata_i),
		.instr_valid_id_o(instr_valid_id),
		.instr_rdata_id_o(instr_rdata_id),
		.is_compressed_id_o(is_compressed_id),
		.illegal_c_insn_id_o(illegal_c_insn_id),
		.pc_if_o(pc_if),
		.pc_id_o(pc_id),
		.clear_instr_valid_i(clear_instr_valid),
		.pc_set_i(pc_set),
		.exception_pc_reg_i(mepc),
		.depc_i(depc),
		.pc_mux_i(pc_mux_id),
		.exc_pc_mux_i(exc_pc_mux_id),
		.exc_vec_pc_mux_i(exc_cause),
		.jump_target_ex_i(jump_target_ex),
		.halt_if_i(halt_if),
		.id_ready_i(id_ready),
		.if_valid_o(if_valid),
		.if_busy_o(if_busy),
		.perf_imiss_o(perf_imiss)
	);
	ibex_id_stage #(
		.RV32E(RV32E),
		.RV32M(RV32M)
	) id_stage_i(
		.clk(clk),
		.rst_n(rst_ni),
		.test_en_i(test_en_i),
		.fetch_enable_i(fetch_enable_i),
		.ctrl_busy_o(ctrl_busy),
		.core_ctrl_firstfetch_o(core_ctrl_firstfetch),
		.is_decoding_o(is_decoding),
		.instr_valid_i(instr_valid_id),
		.instr_rdata_i(instr_rdata_id),
		.instr_req_o(instr_req_int),
		.branch_decision_i(branch_decision),
		.clear_instr_valid_o(clear_instr_valid),
		.pc_set_o(pc_set),
		.pc_mux_o(pc_mux_id),
		.exc_pc_mux_o(exc_pc_mux_id),
		.exc_cause_o(exc_cause),
		.illegal_c_insn_i(illegal_c_insn_id),
		.is_compressed_i(is_compressed_id),
		.pc_id_i(pc_id),
		.halt_if_o(halt_if),
		.id_ready_o(id_ready),
		.ex_ready_i(ex_ready),
		.id_valid_o(id_valid),
		.alu_operator_ex_o(alu_operator_ex),
		.alu_operand_a_ex_o(alu_operand_a_ex),
		.alu_operand_b_ex_o(alu_operand_b_ex),
		.mult_en_ex_o(mult_en_ex),
		.div_en_ex_o(div_en_ex),
		.multdiv_operator_ex_o(multdiv_operator_ex),
		.multdiv_signed_mode_ex_o(multdiv_signed_mode_ex),
		.multdiv_operand_a_ex_o(multdiv_operand_a_ex),
		.multdiv_operand_b_ex_o(multdiv_operand_b_ex),
		.eFPGA_en_o(eFPGA_en),
		.eFPGA_operator_o(eFPGA_operator),
		.eFPGA_operand_a_o(eFPGA_operand_a_o),
		.eFPGA_operand_b_o(eFPGA_operand_b_o),
		.eFPGA_delay_o(eFPGA_delay),
		.csr_access_ex_o(csr_access_ex),
		.csr_op_ex_o(csr_op_ex),
		.csr_cause_o(csr_cause),
		.csr_save_if_o(csr_save_if),
		.csr_save_id_o(csr_save_id),
		.csr_restore_mret_id_o(csr_restore_mret_id),
		.csr_restore_dret_id_o(csr_restore_dret_id),
		.csr_save_cause_o(csr_save_cause),
		.data_req_ex_o(data_req_ex),
		.data_we_ex_o(data_we_ex),
		.data_type_ex_o(data_type_ex),
		.data_sign_ext_ex_o(data_sign_ext_ex),
		.data_reg_offset_ex_o(data_reg_offset_ex),
		.data_wdata_ex_o(data_wdata_ex),
		.data_misaligned_i(data_misaligned),
		.misaligned_addr_i(misaligned_addr),
		.irq_i(irq_i),
		.irq_id_i(irq_id_i),
		.m_irq_enable_i(m_irq_enable),
		.irq_ack_o(irq_ack_o),
		.irq_id_o(irq_id_o),
		.lsu_load_err_i(lsu_load_err),
		.lsu_store_err_i(lsu_store_err),
		.debug_cause_o(debug_cause),
		.debug_csr_save_o(debug_csr_save),
		.debug_req_i(debug_req_i),
		.debug_single_step_i(debug_single_step),
		.debug_ebreakm_i(debug_ebreakm),
		.regfile_wdata_lsu_i(regfile_wdata_lsu),
		.regfile_wdata_ex_i(regfile_wdata_ex),
		.csr_rdata_i(csr_rdata),
		.perf_jump_o(perf_jump),
		.perf_branch_o(perf_branch),
		.perf_tbranch_o(perf_tbranch)
	);
	ibex_ex_block #(.RV32M(RV32M)) ex_block_i(
		.clk(clk),
		.rst_n(rst_ni),
		.alu_operator_i(alu_operator_ex),
		.multdiv_operator_i(multdiv_operator_ex),
		.alu_operand_a_i(alu_operand_a_ex),
		.alu_operand_b_i(alu_operand_b_ex),
		.mult_en_i(mult_en_ex),
		.div_en_i(div_en_ex),
		.multdiv_signed_mode_i(multdiv_signed_mode_ex),
		.multdiv_operand_a_i(multdiv_operand_a_ex),
		.multdiv_operand_b_i(multdiv_operand_b_ex),
		.alu_adder_result_ex_o(alu_adder_result_ex),
		.regfile_wdata_ex_o(regfile_wdata_ex),
		.eFPGA_en_i(eFPGA_en),
		.eFPGA_operator_i(eFPGA_operator),
		.eFPGA_fpga_done_i(eFPGA_fpga_done_i),
		.eFPGA_result_a_i(eFPGA_result_a_i),
		.eFPGA_result_b_i(eFPGA_result_b_i),
		.eFPGA_result_c_i(eFPGA_result_c_i),
		.eFPGA_delay_i(eFPGA_delay),
		.eFPGA_write_strobe_o(eFPGA_write_strobe_o),
		.jump_target_o(jump_target_ex),
		.branch_decision_o(branch_decision),
		.lsu_en_i(data_req_ex),
		.lsu_ready_ex_i(data_valid_lsu),
		.ex_ready_o(ex_ready)
	);
	ibex_load_store_unit load_store_unit_i(
		.clk(clk),
		.rst_n(rst_ni),
		.data_req_o(data_req_o),
		.data_gnt_i(data_gnt_i),
		.data_rvalid_i(data_rvalid_i),
		.data_err_i(data_err_i),
		.data_addr_o(data_addr_o),
		.data_we_o(data_we_o),
		.data_be_o(data_be_o),
		.data_wdata_o(data_wdata_o),
		.data_rdata_i(data_rdata_i),
		.data_we_ex_i(data_we_ex),
		.data_type_ex_i(data_type_ex),
		.data_wdata_ex_i(data_wdata_ex),
		.data_reg_offset_ex_i(data_reg_offset_ex),
		.data_sign_ext_ex_i(data_sign_ext_ex),
		.data_rdata_ex_o(regfile_wdata_lsu),
		.data_req_ex_i(data_req_ex),
		.adder_result_ex_i(alu_adder_result_ex),
		.data_misaligned_o(data_misaligned),
		.misaligned_addr_o(misaligned_addr),
		.load_err_o(lsu_load_err),
		.store_err_o(lsu_store_err),
		.data_valid_o(data_valid_lsu),
		.lsu_update_addr_o(),
		.busy_o(lsu_busy)
	);
	ibex_cs_registers #(
		.N_EXT_CNT(N_EXT_PERF_COUNTERS),
		.RV32E(RV32E),
		.RV32M(RV32M)
	) cs_registers_i(
		.clk(clk),
		.rst_n(rst_ni),
		.core_id_i(core_id_i),
		.cluster_id_i(cluster_id_i),
		.boot_addr_i(boot_addr_i),
		.csr_access_i(csr_access),
		.csr_addr_i(csr_addr),
		.csr_wdata_i(csr_wdata),
		.csr_op_i(csr_op),
		.csr_rdata_o(csr_rdata),
		.m_irq_enable_o(m_irq_enable),
		.mepc_o(mepc),
		.debug_cause_i(debug_cause),
		.debug_csr_save_i(debug_csr_save),
		.depc_o(depc),
		.debug_single_step_o(debug_single_step),
		.debug_ebreakm_o(debug_ebreakm),
		.pc_if_i(pc_if),
		.pc_id_i(pc_id),
		.csr_save_if_i(csr_save_if),
		.csr_save_id_i(csr_save_id),
		.csr_restore_mret_i(csr_restore_mret_id),
		.csr_restore_dret_i(csr_restore_dret_id),
		.csr_cause_i(csr_cause),
		.csr_save_cause_i(csr_save_cause),
		.if_valid_i(if_valid),
		.id_valid_i(id_valid),
		.is_compressed_i(is_compressed_id),
		.is_decoding_i(is_decoding),
		.imiss_i(perf_imiss),
		.pc_set_i(pc_set),
		.jump_i(perf_jump),
		.branch_i(perf_branch),
		.branch_taken_i(perf_tbranch),
		.mem_load_i((data_req_o & data_gnt_i) & ~data_we_o),
		.mem_store_i((data_req_o & data_gnt_i) & data_we_o),
		.ext_counters_i(ext_perf_counters_i)
	);
	assign csr_access = csr_access_ex;
	assign csr_wdata = alu_operand_a_ex;
	assign csr_op = csr_op_ex;
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	assign csr_addr = sv2v_cast_12((csr_access_ex ? alu_operand_b_ex[11:0] : 12'b000000000000));
endmodule
module ibex_cs_registers (
	clk,
	rst_n,
	core_id_i,
	cluster_id_i,
	boot_addr_i,
	csr_access_i,
	csr_addr_i,
	csr_wdata_i,
	csr_op_i,
	csr_rdata_o,
	m_irq_enable_o,
	mepc_o,
	debug_cause_i,
	debug_csr_save_i,
	depc_o,
	debug_single_step_o,
	debug_ebreakm_o,
	pc_if_i,
	pc_id_i,
	csr_save_if_i,
	csr_save_id_i,
	csr_restore_mret_i,
	csr_restore_dret_i,
	csr_cause_i,
	csr_save_cause_i,
	if_valid_i,
	id_valid_i,
	is_compressed_i,
	is_decoding_i,
	imiss_i,
	pc_set_i,
	jump_i,
	branch_i,
	branch_taken_i,
	mem_load_i,
	mem_store_i,
	ext_counters_i
);
	parameter N_EXT_CNT = 0;
	parameter [0:0] RV32E = 0;
	parameter [0:0] RV32M = 0;
	input wire clk;
	input wire rst_n;
	input wire [3:0] core_id_i;
	input wire [5:0] cluster_id_i;
	input wire [31:0] boot_addr_i;
	input wire csr_access_i;
	input wire [11:0] csr_addr_i;
	input wire [31:0] csr_wdata_i;
	input wire [1:0] csr_op_i;
	output wire [31:0] csr_rdata_o;
	output wire m_irq_enable_o;
	output wire [31:0] mepc_o;
	input wire [2:0] debug_cause_i;
	input wire debug_csr_save_i;
	output wire [31:0] depc_o;
	output wire debug_single_step_o;
	output wire debug_ebreakm_o;
	input wire [31:0] pc_if_i;
	input wire [31:0] pc_id_i;
	input wire csr_save_if_i;
	input wire csr_save_id_i;
	input wire csr_restore_mret_i;
	input wire csr_restore_dret_i;
	input wire [5:0] csr_cause_i;
	input wire csr_save_cause_i;
	input wire if_valid_i;
	input wire id_valid_i;
	input wire is_compressed_i;
	input wire is_decoding_i;
	input wire imiss_i;
	input wire pc_set_i;
	input wire jump_i;
	input wire branch_i;
	input wire branch_taken_i;
	input wire mem_load_i;
	input wire mem_store_i;
	input wire [N_EXT_CNT - 1:0] ext_counters_i;
	localparam [1:0] MXL = 2'd1;
	localparam [31:0] MISA_VALUE = ((((((((((0 | 4) | 0) | (RV32E << 4)) | 0) | 256) | (RV32M << 12)) | 0) | 0) | 0) | 0) | (MXL << 30);
	localparam N_PERF_COUNTERS = 11 + N_EXT_CNT;
	localparam N_PERF_REGS = 1;
	wire [N_PERF_COUNTERS - 1:0] PCCR_in;
	wire [N_PERF_COUNTERS - 1:0] PCCR_inc;
	reg [N_PERF_COUNTERS - 1:0] PCCR_inc_q;
	reg [31:0] PCCR_q;
	reg [31:0] PCCR_n;
	reg [1:0] PCMR_n;
	reg [1:0] PCMR_q;
	reg [N_PERF_COUNTERS - 1:0] PCER_n;
	reg [N_PERF_COUNTERS - 1:0] PCER_q;
	reg [31:0] perf_rdata;
	reg [4:0] pccr_index;
	reg pccr_all_sel;
	reg is_pccr;
	reg is_pcer;
	reg is_pcmr;
	reg [31:0] csr_wdata_int;
	reg [31:0] csr_rdata_int;
	reg csr_we_int;
	reg [31:0] mepc_q;
	reg [31:0] mepc_n;
	reg [31:0] dcsr_q;
	reg [31:0] dcsr_n;
	reg [31:0] depc_q;
	reg [31:0] depc_n;
	reg [31:0] dscratch0_q;
	reg [31:0] dscratch0_n;
	reg [31:0] dscratch1_q;
	reg [31:0] dscratch1_n;
	reg [5:0] mcause_q;
	reg [5:0] mcause_n;
	reg [3:0] mstatus_q;
	reg [3:0] mstatus_n;
	reg [31:0] exception_pc;
	localparam [11:0] ibex_defines_CSR_DCSR = 12'h7b0;
	localparam [11:0] ibex_defines_CSR_DPC = 12'h7b1;
	localparam [11:0] ibex_defines_CSR_DSCRATCH0 = 12'h7b2;
	localparam [11:0] ibex_defines_CSR_DSCRATCH1 = 12'h7b3;
	localparam [11:0] ibex_defines_CSR_MCAUSE = 12'h342;
	localparam [11:0] ibex_defines_CSR_MEPC = 12'h341;
	localparam [11:0] ibex_defines_CSR_MHARTID = 12'hf14;
	localparam [11:0] ibex_defines_CSR_MISA = 12'h301;
	localparam [11:0] ibex_defines_CSR_MSTATUS = 12'h300;
	localparam [11:0] ibex_defines_CSR_MTVEC = 12'h305;
	always @(*) begin
		csr_rdata_int = {32 {1'sb0}};
		case (csr_addr_i)
			ibex_defines_CSR_MSTATUS: csr_rdata_int = {19'b0000000000000000000, mstatus_q[1-:2], 3'b000, mstatus_q[2], 3'h0, mstatus_q[3], 3'h0};
			ibex_defines_CSR_MTVEC: csr_rdata_int = boot_addr_i;
			ibex_defines_CSR_MEPC: csr_rdata_int = mepc_q;
			ibex_defines_CSR_MCAUSE: csr_rdata_int = {mcause_q[5], 26'b00000000000000000000000000, mcause_q[4:0]};
			ibex_defines_CSR_MHARTID: csr_rdata_int = {21'b000000000000000000000, cluster_id_i[5:0], 1'b0, core_id_i[3:0]};
			ibex_defines_CSR_MISA: csr_rdata_int = MISA_VALUE;
			ibex_defines_CSR_DCSR: csr_rdata_int = dcsr_q;
			ibex_defines_CSR_DPC: csr_rdata_int = depc_q;
			ibex_defines_CSR_DSCRATCH0: csr_rdata_int = dscratch0_q;
			ibex_defines_CSR_DSCRATCH1: csr_rdata_int = dscratch1_q;
			default:
				;
		endcase
	end
	localparam [1:0] ibex_defines_PRIV_LVL_M = 2'b11;
	localparam [3:0] ibex_defines_XDEBUGVER_STD = 4'd4;
	always @(*) begin
		mepc_n = mepc_q;
		depc_n = depc_q;
		dcsr_n = dcsr_q;
		dscratch0_n = dscratch0_q;
		dscratch1_n = dscratch1_q;
		mstatus_n = mstatus_q;
		mcause_n = mcause_q;
		exception_pc = pc_id_i;
		case (csr_addr_i)
			ibex_defines_CSR_MSTATUS:
				if (csr_we_int)
					mstatus_n = {csr_wdata_int[3], csr_wdata_int[7], ibex_defines_PRIV_LVL_M};
			ibex_defines_CSR_MEPC:
				if (csr_we_int)
					mepc_n = csr_wdata_int;
			ibex_defines_CSR_MCAUSE:
				if (csr_we_int)
					mcause_n = {csr_wdata_int[31], csr_wdata_int[4:0]};
			ibex_defines_CSR_DCSR:
				if (csr_we_int) begin
					dcsr_n = csr_wdata_int;
					dcsr_n[31-:4] = ibex_defines_XDEBUGVER_STD;
					dcsr_n[1-:2] = ibex_defines_PRIV_LVL_M;
					dcsr_n[3] = 1'b0;
					dcsr_n[4] = 1'b0;
					dcsr_n[10] = 1'b0;
					dcsr_n[9] = 1'b0;
					dcsr_n[5] = 1'b0;
					dcsr_n[14] = 1'b0;
					dcsr_n[27-:12] = 12'h000;
				end
			ibex_defines_CSR_DPC:
				if (csr_we_int && (csr_wdata_int[0] == 1'b0))
					depc_n = csr_wdata_int;
			ibex_defines_CSR_DSCRATCH0:
				if (csr_we_int)
					dscratch0_n = csr_wdata_int;
			ibex_defines_CSR_DSCRATCH1:
				if (csr_we_int)
					dscratch1_n = csr_wdata_int;
			default:
				;
		endcase
		case (1'b1)
			csr_save_cause_i: begin
				case (1'b1)
					csr_save_if_i: exception_pc = pc_if_i;
					csr_save_id_i: exception_pc = pc_id_i;
					default:
						;
				endcase
				if (debug_csr_save_i) begin
					dcsr_n[1-:2] = ibex_defines_PRIV_LVL_M;
					dcsr_n[8-:3] = debug_cause_i;
					depc_n = exception_pc;
				end
				else begin
					mstatus_n[2] = mstatus_q[3];
					mstatus_n[3] = 1'b0;
					mstatus_n[1-:2] = ibex_defines_PRIV_LVL_M;
					mepc_n = exception_pc;
					mcause_n = csr_cause_i;
				end
			end
			csr_restore_mret_i: begin
				mstatus_n[3] = mstatus_q[2];
				mstatus_n[2] = 1'b1;
			end
			csr_restore_dret_i: begin
				mstatus_n[3] = mstatus_q[2];
				mstatus_n[2] = 1'b1;
			end
			default:
				;
		endcase
	end
	localparam [1:0] ibex_defines_CSR_OP_CLEAR = 3;
	localparam [1:0] ibex_defines_CSR_OP_NONE = 0;
	localparam [1:0] ibex_defines_CSR_OP_SET = 2;
	localparam [1:0] ibex_defines_CSR_OP_WRITE = 1;
	always @(*) begin
		csr_wdata_int = csr_wdata_i;
		csr_we_int = 1'b1;
		case (csr_op_i)
			ibex_defines_CSR_OP_WRITE: csr_wdata_int = csr_wdata_i;
			ibex_defines_CSR_OP_SET: csr_wdata_int = csr_wdata_i | csr_rdata_o;
			ibex_defines_CSR_OP_CLEAR: csr_wdata_int = ~csr_wdata_i & csr_rdata_o;
			ibex_defines_CSR_OP_NONE: begin
				csr_wdata_int = csr_wdata_i;
				csr_we_int = 1'b0;
			end
			default:
				;
		endcase
	end
	assign csr_rdata_o = ((is_pccr || is_pcer) || is_pcmr ? perf_rdata : csr_rdata_int);
	assign m_irq_enable_o = mstatus_q[3];
	assign mepc_o = mepc_q;
	assign depc_o = depc_q;
	assign debug_single_step_o = dcsr_q[2];
	assign debug_ebreakm_o = dcsr_q[15];
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			mstatus_q <= {2'b00, ibex_defines_PRIV_LVL_M};
			mepc_q <= {32 {1'sb0}};
			mcause_q <= {6 {1'sb0}};
			depc_q <= {32 {1'sb0}};
			dcsr_q <= {30'b000000000000000000000000000000, ibex_defines_PRIV_LVL_M};
			dscratch0_q <= {32 {1'sb0}};
			dscratch1_q <= {32 {1'sb0}};
		end
		else begin
			mstatus_q <= {mstatus_n[3], mstatus_n[2], ibex_defines_PRIV_LVL_M};
			mepc_q <= mepc_n;
			mcause_q <= mcause_n;
			depc_q <= depc_n;
			dcsr_q <= dcsr_n;
			dscratch0_q <= dscratch0_n;
			dscratch1_q <= dscratch1_n;
		end
	wire [11:0] csr_addr;
	assign csr_addr = {csr_addr_i};
	assign PCCR_in[0] = 1'b1;
	assign PCCR_in[1] = if_valid_i;
	assign PCCR_in[2] = 1'b0;
	assign PCCR_in[3] = 1'b0;
	assign PCCR_in[4] = imiss_i & ~pc_set_i;
	assign PCCR_in[5] = mem_load_i;
	assign PCCR_in[6] = mem_store_i;
	assign PCCR_in[7] = jump_i;
	assign PCCR_in[8] = branch_i;
	assign PCCR_in[9] = branch_taken_i;
	assign PCCR_in[10] = (id_valid_i & is_decoding_i) & is_compressed_i;
	generate
		genvar i;
		for (i = 0; i < N_EXT_CNT; i = i + 1) begin : gen_extcounters
			assign PCCR_in[(N_PERF_COUNTERS - N_EXT_CNT) + i] = ext_counters_i[i];
		end
	endgenerate
	localparam [11:0] ibex_defines_CSR_PCCR31 = 12'h79f;
	localparam [11:0] ibex_defines_CSR_TDATA1 = 12'h7a1;
	localparam [11:0] ibex_defines_CSR_TSELECT = 12'h7a0;
	always @(*) begin
		is_pccr = 1'b0;
		is_pcmr = 1'b0;
		is_pcer = 1'b0;
		pccr_all_sel = 1'b0;
		pccr_index = {5 {1'sb0}};
		perf_rdata = {32 {1'sb0}};
		if (csr_access_i) begin
			case (csr_addr_i)
				ibex_defines_CSR_TSELECT: begin
					is_pcer = 1'b1;
					perf_rdata[N_PERF_COUNTERS - 1:0] = PCER_q;
				end
				ibex_defines_CSR_TDATA1: begin
					is_pcmr = 1'b1;
					perf_rdata[1:0] = PCMR_q;
				end
				ibex_defines_CSR_PCCR31: begin
					is_pccr = 1'b1;
					pccr_all_sel = 1'b1;
				end
				default:
					;
			endcase
			if (csr_addr[11:5] == 7'b0111100) begin
				is_pccr = 1'b1;
				pccr_index = csr_addr[4:0];
				perf_rdata = PCCR_q[0+:32];
			end
		end
	end
	assign PCCR_inc[0] = |(PCCR_in & PCER_q) & PCMR_q[0];
	always @(*) begin
		PCCR_n[0+:32] = PCCR_q[0+:32];
		if ((PCCR_inc_q[0] == 1'b1) && ((PCCR_q[0+:32] != 32'hffffffff) || (PCMR_q[1] == 1'b0)))
			PCCR_n[0+:32] = PCCR_q[0+:32] + 32'h00000001;
		if (is_pccr)
			case (csr_op_i)
				ibex_defines_CSR_OP_NONE:
					;
				ibex_defines_CSR_OP_WRITE: PCCR_n[0+:32] = csr_wdata_i;
				ibex_defines_CSR_OP_SET: PCCR_n[0+:32] = csr_wdata_i | PCCR_q[0+:32];
				ibex_defines_CSR_OP_CLEAR: PCCR_n[0+:32] = csr_wdata_i & ~PCCR_q[0+:32];
			endcase
	end
	always @(*) begin
		PCMR_n = PCMR_q;
		PCER_n = PCER_q;
		if (is_pcmr)
			case (csr_op_i)
				ibex_defines_CSR_OP_NONE:
					;
				ibex_defines_CSR_OP_WRITE: PCMR_n = csr_wdata_i[1:0];
				ibex_defines_CSR_OP_SET: PCMR_n = csr_wdata_i[1:0] | PCMR_q;
				ibex_defines_CSR_OP_CLEAR: PCMR_n = csr_wdata_i[1:0] & ~PCMR_q;
			endcase
		if (is_pcer)
			case (csr_op_i)
				ibex_defines_CSR_OP_NONE:
					;
				ibex_defines_CSR_OP_WRITE: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0];
				ibex_defines_CSR_OP_SET: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0] | PCER_q;
				ibex_defines_CSR_OP_CLEAR: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0] & ~PCER_q;
			endcase
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			PCER_q <= {N_PERF_COUNTERS {1'sb0}};
			PCMR_q <= 2'h3;
			begin : sv2v_autoblock_15
				reg signed [31:0] r;
				for (r = 0; r < N_PERF_REGS; r = r + 1)
					begin
						PCCR_q[r * 32+:32] <= {32 {1'sb0}};
						PCCR_inc_q[r] <= 1'b0;
					end
			end
		end
		else begin
			PCER_q <= PCER_n;
			PCMR_q <= PCMR_n;
			begin : sv2v_autoblock_16
				reg signed [31:0] r;
				for (r = 0; r < N_PERF_REGS; r = r + 1)
					begin
						PCCR_q[r * 32+:32] <= PCCR_n[r * 32+:32];
						PCCR_inc_q[r] <= PCCR_inc[r];
					end
			end
		end
endmodule
module ibex_decoder (
	deassert_we_i,
	data_misaligned_i,
	branch_mux_i,
	jump_mux_i,
	illegal_insn_o,
	ebrk_insn_o,
	mret_insn_o,
	dret_insn_o,
	ecall_insn_o,
	pipe_flush_o,
	instr_rdata_i,
	illegal_c_insn_i,
	alu_operator_o,
	alu_op_a_mux_sel_o,
	alu_op_b_mux_sel_o,
	imm_a_mux_sel_o,
	imm_b_mux_sel_o,
	mult_int_en_o,
	div_int_en_o,
	multdiv_operator_o,
	multdiv_signed_mode_o,
	regfile_we_o,
	csr_access_o,
	csr_op_o,
	csr_status_o,
	data_req_o,
	data_we_o,
	data_type_o,
	data_sign_extension_o,
	data_reg_offset_o,
	jump_in_id_o,
	branch_in_id_o,
	eFPGA_operator_o,
	eFPGA_int_en_o,
	eFPGA_delay_o
);
	parameter [0:0] RV32M = 1;
	input wire deassert_we_i;
	input wire data_misaligned_i;
	input wire branch_mux_i;
	input wire jump_mux_i;
	output reg illegal_insn_o;
	output reg ebrk_insn_o;
	output reg mret_insn_o;
	output reg dret_insn_o;
	output reg ecall_insn_o;
	output reg pipe_flush_o;
	input wire [31:0] instr_rdata_i;
	input wire illegal_c_insn_i;
	output reg [4:0] alu_operator_o;
	output reg [1:0] alu_op_a_mux_sel_o;
	output reg alu_op_b_mux_sel_o;
	output reg imm_a_mux_sel_o;
	output reg [2:0] imm_b_mux_sel_o;
	output wire mult_int_en_o;
	output wire div_int_en_o;
	output reg [1:0] multdiv_operator_o;
	output reg [1:0] multdiv_signed_mode_o;
	output wire regfile_we_o;
	output reg csr_access_o;
	output wire [1:0] csr_op_o;
	output reg csr_status_o;
	output wire data_req_o;
	output reg data_we_o;
	output reg [1:0] data_type_o;
	output reg data_sign_extension_o;
	output reg [1:0] data_reg_offset_o;
	output wire jump_in_id_o;
	output wire branch_in_id_o;
	output reg [1:0] eFPGA_operator_o;
	output wire eFPGA_int_en_o;
	output reg [3:0] eFPGA_delay_o;
	reg regfile_we;
	reg data_req;
	reg mult_int_en;
	reg div_int_en;
	reg branch_in_id;
	reg jump_in_id;
	reg eFPGA_int_en;
	reg [1:0] csr_op;
	reg csr_illegal;
	reg [6:0] opcode;
	localparam [4:0] ibex_defines_ALU_ADD = 0;
	localparam [4:0] ibex_defines_ALU_AND = 4;
	localparam [4:0] ibex_defines_ALU_EQ = 16;
	localparam [4:0] ibex_defines_ALU_GE = 14;
	localparam [4:0] ibex_defines_ALU_GEU = 15;
	localparam [4:0] ibex_defines_ALU_LT = 8;
	localparam [4:0] ibex_defines_ALU_LTU = 9;
	localparam [4:0] ibex_defines_ALU_NE = 17;
	localparam [4:0] ibex_defines_ALU_OR = 3;
	localparam [4:0] ibex_defines_ALU_SLL = 7;
	localparam [4:0] ibex_defines_ALU_SLT = 18;
	localparam [4:0] ibex_defines_ALU_SLTU = 19;
	localparam [4:0] ibex_defines_ALU_SRA = 5;
	localparam [4:0] ibex_defines_ALU_SRL = 6;
	localparam [4:0] ibex_defines_ALU_SUB = 1;
	localparam [4:0] ibex_defines_ALU_XOR = 2;
	localparam [11:0] ibex_defines_CSR_DCSR = 12'h7b0;
	localparam [11:0] ibex_defines_CSR_DPC = 12'h7b1;
	localparam [11:0] ibex_defines_CSR_DSCRATCH0 = 12'h7b2;
	localparam [11:0] ibex_defines_CSR_DSCRATCH1 = 12'h7b3;
	localparam [11:0] ibex_defines_CSR_MSTATUS = 12'h300;
	localparam [1:0] ibex_defines_CSR_OP_CLEAR = 3;
	localparam [1:0] ibex_defines_CSR_OP_NONE = 0;
	localparam [1:0] ibex_defines_CSR_OP_SET = 2;
	localparam [1:0] ibex_defines_CSR_OP_WRITE = 1;
	localparam [0:0] ibex_defines_IMM_A_Z = 0;
	localparam [0:0] ibex_defines_IMM_A_ZERO = 1;
	localparam [2:0] ibex_defines_IMM_B_B = 2;
	localparam [2:0] ibex_defines_IMM_B_I = 0;
	localparam [2:0] ibex_defines_IMM_B_J = 4;
	localparam [2:0] ibex_defines_IMM_B_PCINCR = 5;
	localparam [2:0] ibex_defines_IMM_B_S = 1;
	localparam [2:0] ibex_defines_IMM_B_U = 3;
	localparam [1:0] ibex_defines_MD_OP_DIV = 2;
	localparam [1:0] ibex_defines_MD_OP_MULH = 1;
	localparam [1:0] ibex_defines_MD_OP_MULL = 0;
	localparam [1:0] ibex_defines_MD_OP_REM = 3;
	localparam [6:0] ibex_defines_OPCODE_AUIPC = 7'h17;
	localparam [6:0] ibex_defines_OPCODE_BRANCH = 7'h63;
	localparam [6:0] ibex_defines_OPCODE_FENCE = 7'h0f;
	localparam [6:0] ibex_defines_OPCODE_JAL = 7'h6f;
	localparam [6:0] ibex_defines_OPCODE_JALR = 7'h67;
	localparam [6:0] ibex_defines_OPCODE_LOAD = 7'h03;
	localparam [6:0] ibex_defines_OPCODE_LUI = 7'h37;
	localparam [6:0] ibex_defines_OPCODE_OP = 7'h33;
	localparam [6:0] ibex_defines_OPCODE_OPIMM = 7'h13;
	localparam [6:0] ibex_defines_OPCODE_STORE = 7'h23;
	localparam [6:0] ibex_defines_OPCODE_SYSTEM = 7'h73;
	localparam [6:0] ibex_defines_OPCODE_eFPGA = 7'h0b;
	localparam [1:0] ibex_defines_OP_A_CURRPC = 1;
	localparam [1:0] ibex_defines_OP_A_IMM = 2;
	localparam [1:0] ibex_defines_OP_A_REGA_OR_FWD = 0;
	localparam [0:0] ibex_defines_OP_B_IMM = 1;
	localparam [0:0] ibex_defines_OP_B_REGB_OR_FWD = 0;
	always @(*) begin
		jump_in_id = 1'b0;
		branch_in_id = 1'b0;
		alu_operator_o = ibex_defines_ALU_SLTU;
		alu_op_a_mux_sel_o = ibex_defines_OP_A_REGA_OR_FWD;
		alu_op_b_mux_sel_o = ibex_defines_OP_B_REGB_OR_FWD;
		imm_a_mux_sel_o = ibex_defines_IMM_A_ZERO;
		imm_b_mux_sel_o = ibex_defines_IMM_B_I;
		mult_int_en = 1'b0;
		div_int_en = 1'b0;
		multdiv_operator_o = ibex_defines_MD_OP_MULL;
		multdiv_signed_mode_o = 2'b00;
		eFPGA_int_en = 1'b0;
		eFPGA_operator_o = 2'b00;
		regfile_we = 1'b0;
		csr_access_o = 1'b0;
		csr_status_o = 1'b0;
		csr_illegal = 1'b0;
		csr_op = ibex_defines_CSR_OP_NONE;
		data_we_o = 1'b0;
		data_type_o = 2'b00;
		data_sign_extension_o = 1'b0;
		data_reg_offset_o = 2'b00;
		data_req = 1'b0;
		illegal_insn_o = 1'b0;
		ebrk_insn_o = 1'b0;
		mret_insn_o = 1'b0;
		dret_insn_o = 1'b0;
		ecall_insn_o = 1'b0;
		pipe_flush_o = 1'b0;
		opcode = instr_rdata_i[6:0];
		case (opcode)
			ibex_defines_OPCODE_JAL: begin
				jump_in_id = 1'b1;
				if (jump_mux_i) begin
					alu_op_a_mux_sel_o = ibex_defines_OP_A_CURRPC;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_b_mux_sel_o = ibex_defines_IMM_B_J;
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b0;
				end
				else begin
					alu_op_a_mux_sel_o = ibex_defines_OP_A_CURRPC;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_b_mux_sel_o = ibex_defines_IMM_B_PCINCR;
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b1;
				end
			end
			ibex_defines_OPCODE_JALR: begin
				jump_in_id = 1'b1;
				if (jump_mux_i) begin
					alu_op_a_mux_sel_o = ibex_defines_OP_A_REGA_OR_FWD;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_b_mux_sel_o = ibex_defines_IMM_B_I;
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b0;
				end
				else begin
					alu_op_a_mux_sel_o = ibex_defines_OP_A_CURRPC;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_b_mux_sel_o = ibex_defines_IMM_B_PCINCR;
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b1;
				end
				if (instr_rdata_i[14:12] != 3'b000) begin
					jump_in_id = 1'b0;
					regfile_we = 1'b0;
					illegal_insn_o = 1'b1;
				end
			end
			ibex_defines_OPCODE_BRANCH: begin
				branch_in_id = 1'b1;
				if (branch_mux_i)
					case (instr_rdata_i[14:12])
						3'b000: alu_operator_o = ibex_defines_ALU_EQ;
						3'b001: alu_operator_o = ibex_defines_ALU_NE;
						3'b100: alu_operator_o = ibex_defines_ALU_LT;
						3'b101: alu_operator_o = ibex_defines_ALU_GE;
						3'b110: alu_operator_o = ibex_defines_ALU_LTU;
						3'b111: alu_operator_o = ibex_defines_ALU_GEU;
						default: illegal_insn_o = 1'b1;
					endcase
				else begin
					alu_op_a_mux_sel_o = ibex_defines_OP_A_CURRPC;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_b_mux_sel_o = ibex_defines_IMM_B_B;
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b0;
				end
			end
			ibex_defines_OPCODE_STORE: begin
				data_req = 1'b1;
				data_we_o = 1'b1;
				alu_operator_o = ibex_defines_ALU_ADD;
				if (!instr_rdata_i[14]) begin
					imm_b_mux_sel_o = ibex_defines_IMM_B_S;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
				end
				else begin
					data_req = 1'b0;
					data_we_o = 1'b0;
					illegal_insn_o = 1'b1;
				end
				case (instr_rdata_i[13:12])
					2'b00: data_type_o = 2'b10;
					2'b01: data_type_o = 2'b01;
					2'b10: data_type_o = 2'b00;
					default: begin
						data_req = 1'b0;
						data_we_o = 1'b0;
						illegal_insn_o = 1'b1;
					end
				endcase
			end
			ibex_defines_OPCODE_LOAD: begin
				data_req = 1'b1;
				regfile_we = 1'b1;
				data_type_o = 2'b00;
				alu_operator_o = ibex_defines_ALU_ADD;
				alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
				imm_b_mux_sel_o = ibex_defines_IMM_B_I;
				data_sign_extension_o = ~instr_rdata_i[14];
				case (instr_rdata_i[13:12])
					2'b00: data_type_o = 2'b10;
					2'b01: data_type_o = 2'b01;
					2'b10: data_type_o = 2'b00;
					default: data_type_o = 2'b00;
				endcase
				if (instr_rdata_i[14:12] == 3'b111) begin
					alu_op_b_mux_sel_o = ibex_defines_OP_B_REGB_OR_FWD;
					data_sign_extension_o = ~instr_rdata_i[30];
					case (instr_rdata_i[31:25])
						7'b0000000, 7'b0100000: data_type_o = 2'b10;
						7'b0001000, 7'b0101000: data_type_o = 2'b01;
						7'b0010000: data_type_o = 2'b00;
						default: illegal_insn_o = 1'b1;
					endcase
				end
				if (instr_rdata_i[14:12] == 3'b011)
					illegal_insn_o = 1'b1;
			end
			ibex_defines_OPCODE_LUI: begin
				alu_op_a_mux_sel_o = ibex_defines_OP_A_IMM;
				alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
				imm_a_mux_sel_o = ibex_defines_IMM_A_ZERO;
				imm_b_mux_sel_o = ibex_defines_IMM_B_U;
				alu_operator_o = ibex_defines_ALU_ADD;
				regfile_we = 1'b1;
			end
			ibex_defines_OPCODE_AUIPC: begin
				alu_op_a_mux_sel_o = ibex_defines_OP_A_CURRPC;
				alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
				imm_b_mux_sel_o = ibex_defines_IMM_B_U;
				alu_operator_o = ibex_defines_ALU_ADD;
				regfile_we = 1'b1;
			end
			ibex_defines_OPCODE_OPIMM: begin
				alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
				imm_b_mux_sel_o = ibex_defines_IMM_B_I;
				regfile_we = 1'b1;
				case (instr_rdata_i[14:12])
					3'b000: alu_operator_o = ibex_defines_ALU_ADD;
					3'b010: alu_operator_o = ibex_defines_ALU_SLT;
					3'b011: alu_operator_o = ibex_defines_ALU_SLTU;
					3'b100: alu_operator_o = ibex_defines_ALU_XOR;
					3'b110: alu_operator_o = ibex_defines_ALU_OR;
					3'b111: alu_operator_o = ibex_defines_ALU_AND;
					3'b001: begin
						alu_operator_o = ibex_defines_ALU_SLL;
						if (instr_rdata_i[31:25] != 7'b0000000)
							illegal_insn_o = 1'b1;
					end
					3'b101:
						if (instr_rdata_i[31:25] == 7'b0000000)
							alu_operator_o = ibex_defines_ALU_SRL;
						else if (instr_rdata_i[31:25] == 7'b0100000)
							alu_operator_o = ibex_defines_ALU_SRA;
						else
							illegal_insn_o = 1'b1;
					default:
						;
				endcase
			end
			ibex_defines_OPCODE_OP: begin
				regfile_we = 1'b1;
				if (instr_rdata_i[31])
					illegal_insn_o = 1'b1;
				else if (!instr_rdata_i[28])
					case ({instr_rdata_i[30:25], instr_rdata_i[14:12]})
						9'b000000000: alu_operator_o = ibex_defines_ALU_ADD;
						9'b100000000: alu_operator_o = ibex_defines_ALU_SUB;
						9'b000000010: alu_operator_o = ibex_defines_ALU_SLT;
						9'b000000011: alu_operator_o = ibex_defines_ALU_SLTU;
						9'b000000100: alu_operator_o = ibex_defines_ALU_XOR;
						9'b000000110: alu_operator_o = ibex_defines_ALU_OR;
						9'b000000111: alu_operator_o = ibex_defines_ALU_AND;
						9'b000000001: alu_operator_o = ibex_defines_ALU_SLL;
						9'b000000101: alu_operator_o = ibex_defines_ALU_SRL;
						9'b100000101: alu_operator_o = ibex_defines_ALU_SRA;
						9'b000001000: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_MULL;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001001: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001010: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b01;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001011: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001100: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_DIV;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001101: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_DIV;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001110: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_REM;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001111: begin
							alu_operator_o = ibex_defines_ALU_ADD;
							multdiv_operator_o = ibex_defines_MD_OP_REM;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						default: illegal_insn_o = 1'b1;
					endcase
			end
			ibex_defines_OPCODE_eFPGA: begin
				regfile_we = 1'b1;
				eFPGA_operator_o = instr_rdata_i[13:12];
				eFPGA_delay_o = instr_rdata_i[28:25];
				eFPGA_int_en = 1'b1;
			end
			ibex_defines_OPCODE_FENCE:
				if (instr_rdata_i[14:12] == 3'b000) begin
					alu_operator_o = ibex_defines_ALU_ADD;
					regfile_we = 1'b0;
				end
				else
					illegal_insn_o = 1'b1;
			ibex_defines_OPCODE_SYSTEM:
				if (instr_rdata_i[14:12] == 3'b000)
					case (instr_rdata_i[31:20])
						12'h000: ecall_insn_o = 1'b1;
						12'h001: ebrk_insn_o = 1'b1;
						12'h302: mret_insn_o = 1'b1;
						12'h7b2: dret_insn_o = 1'b1;
						12'h105: pipe_flush_o = 1'b1;
						default: illegal_insn_o = 1'b1;
					endcase
				else begin
					csr_access_o = 1'b1;
					regfile_we = 1'b1;
					alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
					imm_a_mux_sel_o = ibex_defines_IMM_A_Z;
					imm_b_mux_sel_o = ibex_defines_IMM_B_I;
					if (instr_rdata_i[14])
						alu_op_a_mux_sel_o = ibex_defines_OP_A_IMM;
					else
						alu_op_a_mux_sel_o = ibex_defines_OP_A_REGA_OR_FWD;
					case (instr_rdata_i[13:12])
						2'b01: csr_op = ibex_defines_CSR_OP_WRITE;
						2'b10: csr_op = ibex_defines_CSR_OP_SET;
						2'b11: csr_op = ibex_defines_CSR_OP_CLEAR;
						default: csr_illegal = 1'b1;
					endcase
					if (!csr_illegal)
						if (((((instr_rdata_i[31:20] == ibex_defines_CSR_MSTATUS) || (instr_rdata_i[31:20] == ibex_defines_CSR_DCSR)) || (instr_rdata_i[31:20] == ibex_defines_CSR_DPC)) || (instr_rdata_i[31:20] == ibex_defines_CSR_DSCRATCH0)) || (instr_rdata_i[31:20] == ibex_defines_CSR_DSCRATCH1))
							csr_status_o = 1'b1;
					illegal_insn_o = csr_illegal;
				end
			default: illegal_insn_o = 1'b1;
		endcase
		if (illegal_c_insn_i)
			illegal_insn_o = 1'b1;
		if (data_misaligned_i) begin
			alu_op_a_mux_sel_o = ibex_defines_OP_A_REGA_OR_FWD;
			alu_op_b_mux_sel_o = ibex_defines_OP_B_IMM;
			imm_b_mux_sel_o = ibex_defines_IMM_B_PCINCR;
			regfile_we = 1'b0;
		end
	end
	assign regfile_we_o = (deassert_we_i ? 1'b0 : regfile_we);
	assign mult_int_en_o = (RV32M ? (deassert_we_i ? 1'b0 : mult_int_en) : 1'b0);
	assign div_int_en_o = (RV32M ? (deassert_we_i ? 1'b0 : div_int_en) : 1'b0);
	assign data_req_o = (deassert_we_i ? 1'b0 : data_req);
	assign csr_op_o = (deassert_we_i ? ibex_defines_CSR_OP_NONE : csr_op);
	assign jump_in_id_o = (deassert_we_i ? 1'b0 : jump_in_id);
	assign branch_in_id_o = (deassert_we_i ? 1'b0 : branch_in_id);
	assign eFPGA_int_en_o = (deassert_we_i ? 1'b0 : eFPGA_int_en);
endmodule
module ibex_eFPGA (
	clk,
	rst_n,
	en_i,
	operator_i,
	ready_o,
	endresult_o,
	result_a_i,
	result_b_i,
	result_c_i,
	delay_i,
	write_strobe,
	efpga_done_i
);
	input wire clk;
	input wire rst_n;
	input wire en_i;
	input wire [1:0] operator_i;
	output wire ready_o;
	output reg [31:0] endresult_o;
	input wire [31:0] result_a_i;
	input wire [31:0] result_b_i;
	input wire [31:0] result_c_i;
	input wire [3:0] delay_i;
	output reg write_strobe;
	input wire efpga_done_i;
	reg [1:0] eFPGA_fsm_r;
	reg [3:0] count;
	localparam [1:0] eFINISH = 2;
	localparam [1:0] eIDLE = 0;
	localparam [1:0] ePROCESSING = 1;
	always @(posedge clk)
		if (!rst_n) begin
			eFPGA_fsm_r <= eIDLE;
			count <= 0;
			write_strobe <= 1'b0;
		end
		else
			case (eFPGA_fsm_r)
				eIDLE: begin
					count <= 0;
					if (en_i == 1) begin
						eFPGA_fsm_r <= ePROCESSING;
						if (operator_i == 2'b11)
							write_strobe <= 1'b1;
					end
				end
				ePROCESSING: begin
					count <= count + 1;
					if (((count == delay_i) & (delay_i != 4'b1111)) | ((delay_i == 4'b1111) & efpga_done_i)) begin
						eFPGA_fsm_r <= eFINISH;
						case (operator_i)
							2'b00: endresult_o <= result_a_i;
							2'b01: endresult_o <= result_b_i;
							2'b10: endresult_o <= result_c_i;
							2'b11: begin
								endresult_o <= result_a_i;
								write_strobe <= 1'b0;
							end
							default: endresult_o <= result_a_i;
						endcase
					end
				end
				eFINISH: eFPGA_fsm_r <= eIDLE;
				default:
					;
			endcase
	assign ready_o = eFPGA_fsm_r == eFINISH;
endmodule
module ibex_ex_block (
	clk,
	rst_n,
	alu_operator_i,
	multdiv_operator_i,
	mult_en_i,
	div_en_i,
	eFPGA_en_i,
	eFPGA_operator_i,
	eFPGA_result_a_i,
	eFPGA_result_b_i,
	eFPGA_result_c_i,
	eFPGA_delay_i,
	eFPGA_fpga_done_i,
	eFPGA_write_strobe_o,
	alu_operand_a_i,
	alu_operand_b_i,
	multdiv_signed_mode_i,
	multdiv_operand_a_i,
	multdiv_operand_b_i,
	alu_adder_result_ex_o,
	regfile_wdata_ex_o,
	jump_target_o,
	branch_decision_o,
	lsu_en_i,
	lsu_ready_ex_i,
	ex_ready_o
);
	parameter [0:0] RV32M = 1;
	input wire clk;
	input wire rst_n;
	input wire [4:0] alu_operator_i;
	input wire [1:0] multdiv_operator_i;
	input wire mult_en_i;
	input wire div_en_i;
	input wire eFPGA_en_i;
	input wire [1:0] eFPGA_operator_i;
	input wire [31:0] eFPGA_result_a_i;
	input wire [31:0] eFPGA_result_b_i;
	input wire [31:0] eFPGA_result_c_i;
	input wire [3:0] eFPGA_delay_i;
	input wire eFPGA_fpga_done_i;
	output wire eFPGA_write_strobe_o;
	input wire [31:0] alu_operand_a_i;
	input wire [31:0] alu_operand_b_i;
	input wire [1:0] multdiv_signed_mode_i;
	input wire [31:0] multdiv_operand_a_i;
	input wire [31:0] multdiv_operand_b_i;
	output wire [31:0] alu_adder_result_ex_o;
	output wire [31:0] regfile_wdata_ex_o;
	output wire [31:0] jump_target_o;
	output wire branch_decision_o;
	input wire lsu_en_i;
	input wire lsu_ready_ex_i;
	output reg ex_ready_o;
	localparam MULT_TYPE = 1;
	wire [31:0] alu_result;
	wire [31:0] multdiv_result;
	wire [31:0] eFPGA_result;
	wire [32:0] multdiv_alu_operand_b;
	wire [32:0] multdiv_alu_operand_a;
	wire [33:0] alu_adder_result_ext;
	wire alu_cmp_result;
	wire alu_is_equal_result;
	wire multdiv_ready;
	wire multdiv_en_sel;
	wire multdiv_en;
	generate
		if (RV32M) begin : gen_multdiv_m
			assign multdiv_en_sel = (MULT_TYPE ? div_en_i : mult_en_i | div_en_i);
			assign multdiv_en = mult_en_i | div_en_i;
		end
		else begin : gen_multdiv_nom
			assign multdiv_en_sel = 1'b0;
			assign multdiv_en = 1'b0;
		end
	endgenerate
	assign regfile_wdata_ex_o = (multdiv_en ? multdiv_result : (eFPGA_en_i ? eFPGA_result : alu_result));
	assign branch_decision_o = alu_cmp_result;
	assign jump_target_o = alu_adder_result_ex_o;
	ibex_alu alu_i(
		.operator_i(alu_operator_i),
		.operand_a_i(alu_operand_a_i),
		.operand_b_i(alu_operand_b_i),
		.multdiv_operand_a_i(multdiv_alu_operand_a),
		.multdiv_operand_b_i(multdiv_alu_operand_b),
		.multdiv_en_i(multdiv_en_sel),
		.adder_result_o(alu_adder_result_ex_o),
		.adder_result_ext_o(alu_adder_result_ext),
		.result_o(alu_result),
		.comparison_result_o(alu_cmp_result),
		.is_equal_result_o(alu_is_equal_result)
	);
	ibex_multdiv_fast multdiv_i(
		.clk(clk),
		.rst_n(rst_n),
		.mult_en_i(mult_en_i),
		.div_en_i(div_en_i),
		.operator_i(multdiv_operator_i),
		.signed_mode_i(multdiv_signed_mode_i),
		.op_a_i(multdiv_operand_a_i),
		.op_b_i(multdiv_operand_b_i),
		.alu_operand_a_o(multdiv_alu_operand_a),
		.alu_operand_b_o(multdiv_alu_operand_b),
		.alu_adder_ext_i(alu_adder_result_ext),
		.alu_adder_i(alu_adder_result_ex_o),
		.equal_to_zero(alu_is_equal_result),
		.ready_o(multdiv_ready),
		.multdiv_result_o(multdiv_result)
	);
	wire eFPGA_ready;
	ibex_eFPGA eFPGA_i(
		.clk(clk),
		.rst_n(rst_n),
		.en_i(eFPGA_en_i),
		.operator_i(eFPGA_operator_i),
		.ready_o(eFPGA_ready),
		.endresult_o(eFPGA_result),
		.result_a_i(eFPGA_result_a_i),
		.result_b_i(eFPGA_result_b_i),
		.result_c_i(eFPGA_result_c_i),
		.delay_i(eFPGA_delay_i),
		.write_strobe(eFPGA_write_strobe_o),
		.efpga_done_i(eFPGA_fpga_done_i)
	);
	always @(*)
		case (1'b1)
			multdiv_en: ex_ready_o = multdiv_ready;
			lsu_en_i: ex_ready_o = lsu_ready_ex_i;
			eFPGA_en_i: ex_ready_o = eFPGA_ready;
			default: ex_ready_o = 1'b1;
		endcase
endmodule
module ibex_fetch_fifo (
	clk,
	rst_n,
	clear_i,
	in_addr_i,
	in_rdata_i,
	in_valid_i,
	in_ready_o,
	out_valid_o,
	out_ready_i,
	out_rdata_o,
	out_addr_o,
	out_valid_stored_o
);
	input wire clk;
	input wire rst_n;
	input wire clear_i;
	input wire [31:0] in_addr_i;
	input wire [31:0] in_rdata_i;
	input wire in_valid_i;
	output wire in_ready_o;
	output reg out_valid_o;
	input wire out_ready_i;
	output reg [31:0] out_rdata_o;
	output wire [31:0] out_addr_o;
	output reg out_valid_stored_o;
	localparam DEPTH = 3;
	reg [95:0] addr_n;
	reg [95:0] addr_int;
	reg [95:0] addr_Q;
	reg [95:0] rdata_n;
	reg [95:0] rdata_int;
	reg [95:0] rdata_Q;
	reg [2:0] valid_n;
	reg [2:0] valid_int;
	reg [2:0] valid_Q;
	wire [31:2] addr_next;
	wire [31:0] rdata;
	wire [31:0] rdata_unaligned;
	wire valid;
	wire valid_unaligned;
	wire aligned_is_compressed;
	wire unaligned_is_compressed;
	wire unaligned_is_compressed_st;
	assign rdata = (valid_Q[0] ? rdata_Q[0+:32] : in_rdata_i);
	assign valid = valid_Q[0] | in_valid_i;
	assign rdata_unaligned = (valid_Q[1] ? {rdata_Q[47-:16], rdata[31:16]} : {in_rdata_i[15:0], rdata[31:16]});
	assign valid_unaligned = valid_Q[1] | (valid_Q[0] & in_valid_i);
	assign unaligned_is_compressed = rdata[17:16] != 2'b11;
	assign aligned_is_compressed = rdata[1:0] != 2'b11;
	assign unaligned_is_compressed_st = rdata_Q[17-:2] != 2'b11;
	always @(*)
		if (out_addr_o[1]) begin
			out_rdata_o = rdata_unaligned;
			if (unaligned_is_compressed)
				out_valid_o = valid;
			else
				out_valid_o = valid_unaligned;
		end
		else begin
			out_rdata_o = rdata;
			out_valid_o = valid;
		end
	assign out_addr_o = (valid_Q[0] ? addr_Q[0+:32] : in_addr_i);
	always @(*) begin
		out_valid_stored_o = 1'b1;
		if (out_addr_o[1]) begin
			if (unaligned_is_compressed_st)
				out_valid_stored_o = 1'b1;
			else
				out_valid_stored_o = valid_Q[1];
		end
		else
			out_valid_stored_o = valid_Q[0];
	end
	assign in_ready_o = ~valid_Q[1];
	always @(*) begin : sv2v_autoblock_17
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		addr_int = addr_Q;
		rdata_int = rdata_Q;
		valid_int = valid_Q;
		if (in_valid_i) begin
			begin : sv2v_autoblock_18
				reg signed [31:0] j;
				for (j = 0; j < DEPTH; j = j + 1)
					if (_sv2v_jump < 2'b10) begin
						_sv2v_jump = 2'b00;
						if (!valid_Q[j]) begin
							addr_int[j * 32+:32] = in_addr_i;
							rdata_int[j * 32+:32] = in_rdata_i;
							valid_int[j] = 1'b1;
							_sv2v_jump = 2'b10;
						end
					end
			end
			if (_sv2v_jump != 2'b11)
				_sv2v_jump = 2'b00;
		end
	end
	assign addr_next[31:2] = addr_int[31-:30] + 30'h00000001;
	always @(*) begin
		addr_n = addr_int;
		rdata_n = rdata_int;
		valid_n = valid_int;
		if (out_ready_i && out_valid_o)
			if (addr_int[1]) begin
				if (unaligned_is_compressed)
					addr_n[0+:32] = {addr_next[31:2], 2'b00};
				else
					addr_n[0+:32] = {addr_next[31:2], 2'b10};
				rdata_n = {32'b00000000000000000000000000000000, rdata_int[32+:64]};
				valid_n = {1'b0, valid_int[2:1]};
			end
			else if (aligned_is_compressed)
				addr_n[0+:32] = {addr_int[31-:30], 2'b10};
			else begin
				addr_n[0+:32] = {addr_next[31:2], 2'b00};
				rdata_n = {32'b00000000000000000000000000000000, rdata_int[32+:64]};
				valid_n = {1'b0, valid_int[2:1]};
			end
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			addr_Q <= {3 {32'b00000000000000000000000000000000}};
			rdata_Q <= {3 {32'b00000000000000000000000000000000}};
			valid_Q <= {3 {1'sb0}};
		end
		else if (clear_i)
			valid_Q <= {3 {1'sb0}};
		else begin
			addr_Q <= addr_n;
			rdata_Q <= rdata_n;
			valid_Q <= valid_n;
		end
endmodule
module ibex_id_stage (
	clk,
	rst_n,
	test_en_i,
	fetch_enable_i,
	ctrl_busy_o,
	core_ctrl_firstfetch_o,
	is_decoding_o,
	instr_valid_i,
	instr_rdata_i,
	instr_req_o,
	branch_decision_i,
	clear_instr_valid_o,
	pc_set_o,
	pc_mux_o,
	exc_pc_mux_o,
	illegal_c_insn_i,
	is_compressed_i,
	pc_id_i,
	halt_if_o,
	id_ready_o,
	ex_ready_i,
	id_valid_o,
	alu_operator_ex_o,
	alu_operand_a_ex_o,
	alu_operand_b_ex_o,
	mult_en_ex_o,
	div_en_ex_o,
	multdiv_operator_ex_o,
	multdiv_signed_mode_ex_o,
	multdiv_operand_a_ex_o,
	multdiv_operand_b_ex_o,
	eFPGA_en_o,
	eFPGA_operator_o,
	eFPGA_operand_a_o,
	eFPGA_operand_b_o,
	eFPGA_delay_o,
	csr_access_ex_o,
	csr_op_ex_o,
	csr_cause_o,
	csr_save_if_o,
	csr_save_id_o,
	csr_restore_mret_id_o,
	csr_restore_dret_id_o,
	csr_save_cause_o,
	data_req_ex_o,
	data_we_ex_o,
	data_type_ex_o,
	data_sign_ext_ex_o,
	data_reg_offset_ex_o,
	data_wdata_ex_o,
	data_misaligned_i,
	misaligned_addr_i,
	irq_i,
	irq_id_i,
	m_irq_enable_i,
	irq_ack_o,
	irq_id_o,
	exc_cause_o,
	lsu_load_err_i,
	lsu_store_err_i,
	debug_cause_o,
	debug_csr_save_o,
	debug_req_i,
	debug_single_step_i,
	debug_ebreakm_i,
	regfile_wdata_lsu_i,
	regfile_wdata_ex_i,
	csr_rdata_i,
	perf_jump_o,
	perf_branch_o,
	perf_tbranch_o
);
	parameter [0:0] RV32M = 1;
	parameter [0:0] RV32E = 0;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire fetch_enable_i;
	output wire ctrl_busy_o;
	output wire core_ctrl_firstfetch_o;
	output wire is_decoding_o;
	input wire instr_valid_i;
	input wire [31:0] instr_rdata_i;
	output wire instr_req_o;
	input wire branch_decision_i;
	output wire clear_instr_valid_o;
	output wire pc_set_o;
	output wire [2:0] pc_mux_o;
	output wire [2:0] exc_pc_mux_o;
	input wire illegal_c_insn_i;
	input wire is_compressed_i;
	input wire [31:0] pc_id_i;
	output wire halt_if_o;
	output wire id_ready_o;
	input wire ex_ready_i;
	output wire id_valid_o;
	output wire [4:0] alu_operator_ex_o;
	output wire [31:0] alu_operand_a_ex_o;
	output wire [31:0] alu_operand_b_ex_o;
	output wire mult_en_ex_o;
	output wire div_en_ex_o;
	output wire [1:0] multdiv_operator_ex_o;
	output wire [1:0] multdiv_signed_mode_ex_o;
	output wire [31:0] multdiv_operand_a_ex_o;
	output wire [31:0] multdiv_operand_b_ex_o;
	output wire eFPGA_en_o;
	output wire [1:0] eFPGA_operator_o;
	output wire [31:0] eFPGA_operand_a_o;
	output wire [31:0] eFPGA_operand_b_o;
	output wire [3:0] eFPGA_delay_o;
	output wire csr_access_ex_o;
	output wire [1:0] csr_op_ex_o;
	output wire [5:0] csr_cause_o;
	output wire csr_save_if_o;
	output wire csr_save_id_o;
	output wire csr_restore_mret_id_o;
	output wire csr_restore_dret_id_o;
	output wire csr_save_cause_o;
	output wire data_req_ex_o;
	output wire data_we_ex_o;
	output wire [1:0] data_type_ex_o;
	output wire data_sign_ext_ex_o;
	output wire [1:0] data_reg_offset_ex_o;
	output wire [31:0] data_wdata_ex_o;
	input wire data_misaligned_i;
	input wire [31:0] misaligned_addr_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	input wire m_irq_enable_i;
	output wire irq_ack_o;
	output wire [4:0] irq_id_o;
	output wire [5:0] exc_cause_o;
	input wire lsu_load_err_i;
	input wire lsu_store_err_i;
	output wire [2:0] debug_cause_o;
	output wire debug_csr_save_o;
	input wire debug_req_i;
	input wire debug_single_step_i;
	input wire debug_ebreakm_i;
	input wire [31:0] regfile_wdata_lsu_i;
	input wire [31:0] regfile_wdata_ex_i;
	input wire [31:0] csr_rdata_i;
	output wire perf_jump_o;
	output reg perf_branch_o;
	output wire perf_tbranch_o;
	wire [31:0] instr;
	wire deassert_we;
	wire illegal_insn_dec;
	wire illegal_reg_rv32e;
	wire ebrk_insn;
	wire mret_insn_dec;
	wire dret_insn_dec;
	wire ecall_insn_dec;
	wire pipe_flush_dec;
	wire branch_in_id;
	reg branch_set_n;
	reg branch_set_q;
	reg branch_mux_dec;
	reg jump_set;
	reg jump_mux_dec;
	wire jump_in_id;
	reg instr_multicyle;
	reg load_stall;
	reg multdiv_stall;
	reg branch_stall;
	reg jump_stall;
	reg eFPGA_stall;
	wire halt_id;
	reg regfile_we;
	reg select_data_rf;
	wire [31:0] imm_i_type;
	wire [31:0] imm_s_type;
	wire [31:0] imm_b_type;
	wire [31:0] imm_u_type;
	wire [31:0] imm_j_type;
	wire [31:0] zimm_rs1_type;
	wire [31:0] imm_a;
	reg [31:0] imm_b;
	wire irq_req_ctrl;
	wire [4:0] irq_id_ctrl;
	wire exc_ack;
	wire exc_kill;
	wire [4:0] regfile_addr_ra_id;
	wire [4:0] regfile_addr_rb_id;
	wire [4:0] regfile_alu_waddr_id;
	wire regfile_we_id;
	wire [31:0] regfile_data_ra_id;
	wire [31:0] regfile_data_rb_id;
	wire [4:0] alu_operator;
	wire [1:0] alu_op_a_mux_sel;
	wire alu_op_b_mux_sel;
	wire imm_a_mux_sel;
	wire [2:0] imm_b_mux_sel;
	wire mult_int_en;
	wire div_int_en;
	wire multdiv_int_en;
	wire [1:0] multdiv_operator;
	wire [1:0] multdiv_signed_mode;
	wire eFPGA_en;
	wire eFPGA_int_en;
	wire [1:0] eFPGA_operator;
	wire [3:0] eFPGA_delay;
	assign eFPGA_en_o = eFPGA_int_en;
	wire data_we_id;
	wire [1:0] data_type_id;
	wire data_sign_ext_id;
	wire [1:0] data_reg_offset_id;
	wire data_req_id;
	wire csr_access;
	wire [1:0] csr_op;
	wire csr_status;
	wire operand_a_fw_mux_sel;
	wire [31:0] operand_a_fw_id;
	reg [31:0] alu_operand_a;
	wire [31:0] alu_operand_b;
	assign instr = instr_rdata_i;
	assign imm_i_type = {{20 {instr[31]}}, instr[31:20]};
	assign imm_s_type = {{20 {instr[31]}}, instr[31:25], instr[11:7]};
	assign imm_b_type = {{19 {instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
	assign imm_u_type = {instr[31:12], 12'b000000000000};
	assign imm_j_type = {{12 {instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
	assign zimm_rs1_type = {27'b000000000000000000000000000, instr[19:15]};
	assign regfile_addr_ra_id = instr[19:15];
	assign regfile_addr_rb_id = instr[24:20];
	assign regfile_alu_waddr_id = instr[11:7];
	assign illegal_reg_rv32e = 1'b0;
	assign clear_instr_valid_o = id_ready_o | halt_id;
	localparam [1:0] ibex_defines_OP_A_CURRPC = 1;
	localparam [1:0] ibex_defines_OP_A_IMM = 2;
	localparam [1:0] ibex_defines_OP_A_REGA_OR_FWD = 0;
	always @(*) begin : alu_operand_a_mux
		case (alu_op_a_mux_sel)
			ibex_defines_OP_A_REGA_OR_FWD: alu_operand_a = operand_a_fw_id;
			ibex_defines_OP_A_CURRPC: alu_operand_a = pc_id_i;
			ibex_defines_OP_A_IMM: alu_operand_a = imm_a;
			default: alu_operand_a = operand_a_fw_id;
		endcase
	end
	localparam [0:0] ibex_defines_IMM_A_Z = 0;
	assign imm_a = (imm_a_mux_sel == ibex_defines_IMM_A_Z ? zimm_rs1_type : {32 {1'sb0}});
	localparam [0:0] ibex_defines_SEL_MISALIGNED = 1;
	assign operand_a_fw_id = (operand_a_fw_mux_sel == ibex_defines_SEL_MISALIGNED ? misaligned_addr_i : regfile_data_ra_id);
	localparam [2:0] ibex_defines_IMM_B_B = 2;
	localparam [2:0] ibex_defines_IMM_B_I = 0;
	localparam [2:0] ibex_defines_IMM_B_J = 4;
	localparam [2:0] ibex_defines_IMM_B_PCINCR = 5;
	localparam [2:0] ibex_defines_IMM_B_S = 1;
	localparam [2:0] ibex_defines_IMM_B_U = 3;
	always @(*) begin : immediate_b_mux
		case (imm_b_mux_sel)
			ibex_defines_IMM_B_I: imm_b = imm_i_type;
			ibex_defines_IMM_B_S: imm_b = imm_s_type;
			ibex_defines_IMM_B_B: imm_b = imm_b_type;
			ibex_defines_IMM_B_U: imm_b = imm_u_type;
			ibex_defines_IMM_B_J: imm_b = imm_j_type;
			ibex_defines_IMM_B_PCINCR: imm_b = (is_compressed_i && !data_misaligned_i ? 32'h00000002 : 32'h00000004);
			default: imm_b = imm_i_type;
		endcase
	end
	localparam [0:0] ibex_defines_OP_B_IMM = 1;
	assign alu_operand_b = (alu_op_b_mux_sel == ibex_defines_OP_B_IMM ? imm_b : regfile_data_rb_id);
	reg [31:0] regfile_wdata_mux;
	reg regfile_we_mux;
	reg [4:0] regfile_waddr_mux;
	localparam [0:0] RF_LSU = 0;
	always @(*) begin
		regfile_we_mux = regfile_we;
		regfile_waddr_mux = regfile_alu_waddr_id;
		if (select_data_rf == RF_LSU)
			regfile_wdata_mux = regfile_wdata_lsu_i;
		else if (csr_access)
			regfile_wdata_mux = csr_rdata_i;
		else
			regfile_wdata_mux = regfile_wdata_ex_i;
	end
	ibex_register_file #(.RV32E(RV32E)) registers_i(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.raddr_a_i(regfile_addr_ra_id),
		.rdata_a_o(regfile_data_ra_id),
		.raddr_b_i(regfile_addr_rb_id),
		.rdata_b_o(regfile_data_rb_id),
		.waddr_a_i(regfile_waddr_mux),
		.wdata_a_i(regfile_wdata_mux),
		.we_a_i(regfile_we_mux)
	);
	assign multdiv_int_en = mult_int_en | div_int_en;
	ibex_decoder #(.RV32M(RV32M)) decoder_i(
		.deassert_we_i(deassert_we),
		.data_misaligned_i(data_misaligned_i),
		.branch_mux_i(branch_mux_dec),
		.jump_mux_i(jump_mux_dec),
		.illegal_insn_o(illegal_insn_dec),
		.ebrk_insn_o(ebrk_insn),
		.mret_insn_o(mret_insn_dec),
		.dret_insn_o(dret_insn_dec),
		.ecall_insn_o(ecall_insn_dec),
		.pipe_flush_o(pipe_flush_dec),
		.instr_rdata_i(instr),
		.illegal_c_insn_i(illegal_c_insn_i),
		.alu_operator_o(alu_operator),
		.alu_op_a_mux_sel_o(alu_op_a_mux_sel),
		.alu_op_b_mux_sel_o(alu_op_b_mux_sel),
		.imm_a_mux_sel_o(imm_a_mux_sel),
		.imm_b_mux_sel_o(imm_b_mux_sel),
		.mult_int_en_o(mult_int_en),
		.div_int_en_o(div_int_en),
		.multdiv_operator_o(multdiv_operator),
		.multdiv_signed_mode_o(multdiv_signed_mode),
		.regfile_we_o(regfile_we_id),
		.csr_access_o(csr_access),
		.csr_op_o(csr_op),
		.csr_status_o(csr_status),
		.data_req_o(data_req_id),
		.data_we_o(data_we_id),
		.data_type_o(data_type_id),
		.data_sign_extension_o(data_sign_ext_id),
		.data_reg_offset_o(data_reg_offset_id),
		.jump_in_id_o(jump_in_id),
		.branch_in_id_o(branch_in_id),
		.eFPGA_operator_o(eFPGA_operator),
		.eFPGA_int_en_o(eFPGA_int_en),
		.eFPGA_delay_o(eFPGA_delay)
	);
	assign eFPGA_operator_o = eFPGA_operator;
	assign eFPGA_delay_o = eFPGA_delay;
	ibex_controller controller_i(
		.clk(clk),
		.rst_n(rst_n),
		.fetch_enable_i(fetch_enable_i),
		.ctrl_busy_o(ctrl_busy_o),
		.first_fetch_o(core_ctrl_firstfetch_o),
		.is_decoding_o(is_decoding_o),
		.deassert_we_o(deassert_we),
		.illegal_insn_i(illegal_insn_dec | illegal_reg_rv32e),
		.ecall_insn_i(ecall_insn_dec),
		.mret_insn_i(mret_insn_dec),
		.dret_insn_i(dret_insn_dec),
		.pipe_flush_i(pipe_flush_dec),
		.ebrk_insn_i(ebrk_insn),
		.csr_status_i(csr_status),
		.instr_valid_i(instr_valid_i),
		.instr_req_o(instr_req_o),
		.pc_set_o(pc_set_o),
		.pc_mux_o(pc_mux_o),
		.exc_pc_mux_o(exc_pc_mux_o),
		.exc_cause_o(exc_cause_o),
		.data_misaligned_i(data_misaligned_i),
		.branch_in_id_i(branch_in_id),
		.branch_set_i(branch_set_q),
		.jump_set_i(jump_set),
		.instr_multicyle_i(instr_multicyle),
		.irq_i(irq_i),
		.irq_req_ctrl_i(irq_req_ctrl),
		.irq_id_ctrl_i(irq_id_ctrl),
		.m_IE_i(m_irq_enable_i),
		.irq_ack_o(irq_ack_o),
		.irq_id_o(irq_id_o),
		.exc_ack_o(exc_ack),
		.exc_kill_o(exc_kill),
		.csr_save_cause_o(csr_save_cause_o),
		.csr_cause_o(csr_cause_o),
		.csr_save_if_o(csr_save_if_o),
		.csr_save_id_o(csr_save_id_o),
		.csr_restore_mret_id_o(csr_restore_mret_id_o),
		.csr_restore_dret_id_o(csr_restore_dret_id_o),
		.debug_cause_o(debug_cause_o),
		.debug_csr_save_o(debug_csr_save_o),
		.debug_req_i(debug_req_i),
		.debug_single_step_i(debug_single_step_i),
		.debug_ebreakm_i(debug_ebreakm_i),
		.operand_a_fw_mux_sel_o(operand_a_fw_mux_sel),
		.halt_if_o(halt_if_o),
		.halt_id_o(halt_id),
		.id_ready_i(id_ready_o),
		.perf_jump_o(perf_jump_o),
		.perf_tbranch_o(perf_tbranch_o)
	);
	ibex_int_controller int_controller_i(
		.clk(clk),
		.rst_n(rst_n),
		.irq_req_ctrl_o(irq_req_ctrl),
		.irq_id_ctrl_o(irq_id_ctrl),
		.ctrl_ack_i(exc_ack),
		.ctrl_kill_i(exc_kill),
		.irq_i(irq_i),
		.irq_id_i(irq_id_i),
		.m_IE_i(m_irq_enable_i)
	);
	assign data_we_ex_o = data_we_id;
	assign data_type_ex_o = data_type_id;
	assign data_sign_ext_ex_o = data_sign_ext_id;
	assign data_wdata_ex_o = regfile_data_rb_id;
	assign data_req_ex_o = data_req_id;
	assign data_reg_offset_ex_o = data_reg_offset_id;
	assign alu_operator_ex_o = alu_operator;
	assign alu_operand_a_ex_o = alu_operand_a;
	assign alu_operand_b_ex_o = alu_operand_b;
	assign csr_access_ex_o = csr_access;
	assign csr_op_ex_o = csr_op;
	assign mult_en_ex_o = mult_int_en;
	assign div_en_ex_o = div_int_en;
	assign multdiv_operator_ex_o = multdiv_operator;
	assign multdiv_signed_mode_ex_o = multdiv_signed_mode;
	assign multdiv_operand_a_ex_o = regfile_data_ra_id;
	assign multdiv_operand_b_ex_o = regfile_data_rb_id;
	assign eFPGA_operand_a_o = regfile_data_ra_id;
	assign eFPGA_operand_b_o = regfile_data_rb_id;
	reg id_wb_fsm_cs;
	reg id_wb_fsm_ns;
	localparam [0:0] IDLE = 0;
	always @(posedge clk or negedge rst_n) begin : EX_WB_Pipeline_Register
		if (!rst_n) begin
			id_wb_fsm_cs <= IDLE;
			branch_set_q <= 1'b0;
		end
		else begin
			id_wb_fsm_cs <= id_wb_fsm_ns;
			branch_set_q <= branch_set_n;
		end
	end
	localparam [0:0] RF_EX = 1;
	localparam [0:0] WAIT_MULTICYCLE = 1;
	always @(*) begin
		id_wb_fsm_ns = id_wb_fsm_cs;
		regfile_we = regfile_we_id;
		load_stall = 1'b0;
		multdiv_stall = 1'b0;
		eFPGA_stall = 1'b0;
		jump_stall = 1'b0;
		branch_stall = 1'b0;
		select_data_rf = RF_EX;
		instr_multicyle = 1'b0;
		branch_set_n = 1'b0;
		branch_mux_dec = 1'b0;
		jump_set = 1'b0;
		jump_mux_dec = 1'b0;
		perf_branch_o = 1'b0;
		case (id_wb_fsm_cs)
			IDLE: begin
				jump_mux_dec = 1'b1;
				branch_mux_dec = 1'b1;
				case (1'b1)
					data_req_id: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = WAIT_MULTICYCLE;
						load_stall = 1'b1;
						instr_multicyle = 1'b1;
					end
					branch_in_id: begin
						id_wb_fsm_ns = (branch_decision_i ? WAIT_MULTICYCLE : IDLE);
						branch_stall = branch_decision_i;
						instr_multicyle = branch_decision_i;
						branch_set_n = branch_decision_i;
						perf_branch_o = 1'b1;
					end
					multdiv_int_en: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = WAIT_MULTICYCLE;
						multdiv_stall = 1'b1;
						instr_multicyle = 1'b1;
					end
					eFPGA_int_en: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = WAIT_MULTICYCLE;
						eFPGA_stall = 1'b1;
						instr_multicyle = 1'b1;
					end
					jump_in_id: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = WAIT_MULTICYCLE;
						jump_stall = 1'b1;
						instr_multicyle = 1'b1;
						jump_set = 1'b1;
					end
					default:
						;
				endcase
			end
			WAIT_MULTICYCLE:
				if (ex_ready_i) begin
					regfile_we = regfile_we_id;
					id_wb_fsm_ns = IDLE;
					load_stall = 1'b0;
					multdiv_stall = 1'b0;
					eFPGA_stall = 1'b0;
					select_data_rf = (data_req_id ? RF_LSU : RF_EX);
				end
				else begin
					regfile_we = 1'b0;
					instr_multicyle = 1'b1;
					case (1'b1)
						data_req_id: load_stall = 1'b1;
						multdiv_int_en: multdiv_stall = 1'b1;
						eFPGA_int_en: eFPGA_stall = 1'b1;
						default:
							;
					endcase
				end
			default:
				;
		endcase
	end
	assign id_ready_o = (((~load_stall & ~branch_stall) & ~jump_stall) & ~multdiv_stall) & ~eFPGA_stall;
	assign id_valid_o = ~halt_id & id_ready_o;
endmodule
module ibex_if_stage (
	clk,
	rst_n,
	boot_addr_i,
	req_i,
	instr_req_o,
	instr_addr_o,
	instr_gnt_i,
	instr_rvalid_i,
	instr_rdata_i,
	instr_valid_id_o,
	instr_rdata_id_o,
	is_compressed_id_o,
	illegal_c_insn_id_o,
	pc_if_o,
	pc_id_o,
	clear_instr_valid_i,
	pc_set_i,
	exception_pc_reg_i,
	depc_i,
	pc_mux_i,
	exc_pc_mux_i,
	exc_vec_pc_mux_i,
	jump_target_ex_i,
	halt_if_i,
	id_ready_i,
	if_valid_o,
	if_busy_o,
	perf_imiss_o
);
	parameter DM_HALT_ADDRESS = 32'h1a110800;
	parameter DM_EXCEPTION_ADDRESS = 32'h1a110808;
	input wire clk;
	input wire rst_n;
	input wire [31:0] boot_addr_i;
	input wire req_i;
	output wire instr_req_o;
	output wire [31:0] instr_addr_o;
	input wire instr_gnt_i;
	input wire instr_rvalid_i;
	input wire [31:0] instr_rdata_i;
	output reg instr_valid_id_o;
	output reg [31:0] instr_rdata_id_o;
	output reg is_compressed_id_o;
	output reg illegal_c_insn_id_o;
	output wire [31:0] pc_if_o;
	output reg [31:0] pc_id_o;
	input wire clear_instr_valid_i;
	input wire pc_set_i;
	input wire [31:0] exception_pc_reg_i;
	input wire [31:0] depc_i;
	input wire [2:0] pc_mux_i;
	input wire [2:0] exc_pc_mux_i;
	input wire [5:0] exc_vec_pc_mux_i;
	input wire [31:0] jump_target_ex_i;
	input wire halt_if_i;
	input wire id_ready_i;
	output wire if_valid_o;
	output wire if_busy_o;
	output wire perf_imiss_o;
	reg offset_in_init_d;
	reg offset_in_init_q;
	reg valid;
	wire if_ready;
	wire prefetch_busy;
	reg branch_req;
	reg [31:0] fetch_addr_n;
	wire fetch_valid;
	reg fetch_ready;
	wire [31:0] fetch_rdata;
	wire [31:0] fetch_addr;
	reg [31:0] exc_pc;
	localparam [7:0] ibex_defines_EXC_OFF_BREAKPOINT = 8'h90;
	localparam [7:0] ibex_defines_EXC_OFF_ECALL = 8'h88;
	localparam [7:0] ibex_defines_EXC_OFF_ILLINSN = 8'h84;
	localparam [2:0] ibex_defines_EXC_PC_BREAKPOINT = 7;
	localparam [2:0] ibex_defines_EXC_PC_DBD = 5;
	localparam [2:0] ibex_defines_EXC_PC_DBGEXC = 6;
	localparam [2:0] ibex_defines_EXC_PC_ECALL = 1;
	localparam [2:0] ibex_defines_EXC_PC_ILLINSN = 0;
	localparam [2:0] ibex_defines_EXC_PC_IRQ = 4;
	always @(*) begin : EXC_PC_MUX
		exc_pc = {32 {1'sb0}};
		case (exc_pc_mux_i)
			ibex_defines_EXC_PC_ILLINSN: exc_pc = {boot_addr_i[31:8], {ibex_defines_EXC_OFF_ILLINSN}};
			ibex_defines_EXC_PC_ECALL: exc_pc = {boot_addr_i[31:8], {ibex_defines_EXC_OFF_ECALL}};
			ibex_defines_EXC_PC_BREAKPOINT: exc_pc = {boot_addr_i[31:8], {ibex_defines_EXC_OFF_BREAKPOINT}};
			ibex_defines_EXC_PC_IRQ: exc_pc = {boot_addr_i[31:8], {exc_vec_pc_mux_i}, 2'b00};
			ibex_defines_EXC_PC_DBD: exc_pc = {DM_HALT_ADDRESS};
			ibex_defines_EXC_PC_DBGEXC: exc_pc = {DM_EXCEPTION_ADDRESS};
			default:
				;
		endcase
	end
	localparam [7:0] ibex_defines_EXC_OFF_RST = 8'h80;
	localparam [2:0] ibex_defines_PC_BOOT = 0;
	localparam [2:0] ibex_defines_PC_DRET = 4;
	localparam [2:0] ibex_defines_PC_ERET = 3;
	localparam [2:0] ibex_defines_PC_EXCEPTION = 2;
	localparam [2:0] ibex_defines_PC_JUMP = 1;
	always @(*) begin
		fetch_addr_n = {32 {1'sb0}};
		case (pc_mux_i)
			ibex_defines_PC_BOOT: fetch_addr_n = {boot_addr_i[31:8], {ibex_defines_EXC_OFF_RST}};
			ibex_defines_PC_JUMP: fetch_addr_n = jump_target_ex_i;
			ibex_defines_PC_EXCEPTION: fetch_addr_n = exc_pc;
			ibex_defines_PC_ERET: fetch_addr_n = exception_pc_reg_i;
			ibex_defines_PC_DRET: fetch_addr_n = depc_i;
			default:
				;
		endcase
	end
	ibex_prefetch_buffer prefetch_buffer_i(
		.clk(clk),
		.rst_n(rst_n),
		.req_i(req_i),
		.branch_i(branch_req),
		.addr_i({fetch_addr_n[31:1], 1'b0}),
		.ready_i(fetch_ready),
		.valid_o(fetch_valid),
		.rdata_o(fetch_rdata),
		.addr_o(fetch_addr),
		.instr_req_o(instr_req_o),
		.instr_addr_o(instr_addr_o),
		.instr_gnt_i(instr_gnt_i),
		.instr_rvalid_i(instr_rvalid_i),
		.instr_rdata_i(instr_rdata_i),
		.busy_o(prefetch_busy)
	);
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			offset_in_init_q <= 1'b1;
		else
			offset_in_init_q <= offset_in_init_d;
	always @(*) begin
		offset_in_init_d = offset_in_init_q;
		fetch_ready = 1'b0;
		branch_req = 1'b0;
		valid = 1'b0;
		if (offset_in_init_q) begin
			if (req_i) begin
				branch_req = 1'b1;
				offset_in_init_d = 1'b0;
			end
		end
		else if (fetch_valid) begin
			valid = 1'b1;
			if (req_i && if_valid_o) begin
				fetch_ready = 1'b1;
				offset_in_init_d = 1'b0;
			end
		end
		if (pc_set_i) begin
			valid = 1'b0;
			branch_req = 1'b1;
			offset_in_init_d = 1'b0;
		end
	end
	assign pc_if_o = fetch_addr;
	assign if_busy_o = prefetch_busy;
	assign perf_imiss_o = ~fetch_valid | branch_req;
	wire [31:0] instr_decompressed;
	wire illegal_c_insn;
	wire instr_compressed_int;
	ibex_compressed_decoder compressed_decoder_i(
		.instr_i(fetch_rdata),
		.instr_o(instr_decompressed),
		.is_compressed_o(instr_compressed_int),
		.illegal_instr_o(illegal_c_insn)
	);
	always @(posedge clk or negedge rst_n) begin : IF_ID_PIPE_REGISTERS
		if (!rst_n) begin
			instr_valid_id_o <= 1'b0;
			instr_rdata_id_o <= {32 {1'sb0}};
			illegal_c_insn_id_o <= 1'b0;
			is_compressed_id_o <= 1'b0;
			pc_id_o <= {32 {1'sb0}};
		end
		else if (if_valid_o) begin
			instr_valid_id_o <= 1'b1;
			instr_rdata_id_o <= instr_decompressed;
			illegal_c_insn_id_o <= illegal_c_insn;
			is_compressed_id_o <= instr_compressed_int;
			pc_id_o <= pc_if_o;
		end
		else if (clear_instr_valid_i)
			instr_valid_id_o <= 1'b0;
	end
	assign if_ready = valid & id_ready_i;
	assign if_valid_o = ~halt_if_i & if_ready;
endmodule
module ibex_int_controller (
	clk,
	rst_n,
	irq_req_ctrl_o,
	irq_id_ctrl_o,
	ctrl_ack_i,
	ctrl_kill_i,
	irq_i,
	irq_id_i,
	m_IE_i
);
	input wire clk;
	input wire rst_n;
	output wire irq_req_ctrl_o;
	output wire [4:0] irq_id_ctrl_o;
	input wire ctrl_ack_i;
	input wire ctrl_kill_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	input wire m_IE_i;
	reg [1:0] exc_ctrl_ns;
	reg [1:0] exc_ctrl_cs;
	wire irq_enable_ext;
	reg [4:0] irq_id_d;
	reg [4:0] irq_id_q;
	assign irq_enable_ext = m_IE_i;
	localparam [1:0] IRQ_PENDING = 1;
	assign irq_req_ctrl_o = exc_ctrl_cs == IRQ_PENDING;
	assign irq_id_ctrl_o = irq_id_q;
	localparam [1:0] IDLE = 0;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			irq_id_q <= {5 {1'sb0}};
			exc_ctrl_cs <= IDLE;
		end
		else begin
			irq_id_q <= irq_id_d;
			exc_ctrl_cs <= exc_ctrl_ns;
		end
	localparam [1:0] IRQ_DONE = 2;
	always @(*) begin
		irq_id_d = irq_id_q;
		exc_ctrl_ns = exc_ctrl_cs;
		case (exc_ctrl_cs)
			IDLE:
				if (irq_enable_ext && irq_i) begin
					exc_ctrl_ns = IRQ_PENDING;
					irq_id_d = irq_id_i;
				end
			IRQ_PENDING:
				case (1'b1)
					ctrl_ack_i: exc_ctrl_ns = IRQ_DONE;
					ctrl_kill_i: exc_ctrl_ns = IDLE;
					default: exc_ctrl_ns = IRQ_PENDING;
				endcase
			IRQ_DONE: exc_ctrl_ns = IDLE;
		endcase
	end
endmodule
module ibex_load_store_unit (
	clk,
	rst_n,
	data_req_o,
	data_gnt_i,
	data_rvalid_i,
	data_err_i,
	data_addr_o,
	data_we_o,
	data_be_o,
	data_wdata_o,
	data_rdata_i,
	data_we_ex_i,
	data_type_ex_i,
	data_wdata_ex_i,
	data_reg_offset_ex_i,
	data_sign_ext_ex_i,
	data_rdata_ex_o,
	data_req_ex_i,
	adder_result_ex_i,
	data_misaligned_o,
	misaligned_addr_o,
	load_err_o,
	store_err_o,
	lsu_update_addr_o,
	data_valid_o,
	busy_o
);
	input wire clk;
	input wire rst_n;
	output reg data_req_o;
	input wire data_gnt_i;
	input wire data_rvalid_i;
	input wire data_err_i;
	output wire [31:0] data_addr_o;
	output wire data_we_o;
	output wire [3:0] data_be_o;
	output wire [31:0] data_wdata_o;
	input wire [31:0] data_rdata_i;
	input wire data_we_ex_i;
	input wire [1:0] data_type_ex_i;
	input wire [31:0] data_wdata_ex_i;
	input wire [1:0] data_reg_offset_ex_i;
	input wire data_sign_ext_ex_i;
	output wire [31:0] data_rdata_ex_o;
	input wire data_req_ex_i;
	input wire [31:0] adder_result_ex_i;
	output reg data_misaligned_o;
	output reg [31:0] misaligned_addr_o;
	output wire load_err_o;
	output wire store_err_o;
	output reg lsu_update_addr_o;
	output reg data_valid_o;
	output wire busy_o;
	wire [31:0] data_addr_int;
	reg [1:0] data_type_q;
	reg [1:0] rdata_offset_q;
	reg data_sign_ext_q;
	reg data_we_q;
	wire [1:0] wdata_offset;
	reg [3:0] data_be;
	reg [31:0] data_wdata;
	wire misaligned_st;
	reg data_misaligned;
	reg data_misaligned_q;
	reg increase_address;
	reg [2:0] CS;
	reg [2:0] NS;
	reg [31:0] rdata_q;
	always @(*)
		case (data_type_ex_i)
			2'b00:
				if (!misaligned_st)
					case (data_addr_int[1:0])
						2'b00: data_be = 4'b1111;
						2'b01: data_be = 4'b1110;
						2'b10: data_be = 4'b1100;
						2'b11: data_be = 4'b1000;
					endcase
				else
					case (data_addr_int[1:0])
						2'b00: data_be = 4'b0000;
						2'b01: data_be = 4'b0001;
						2'b10: data_be = 4'b0011;
						2'b11: data_be = 4'b0111;
					endcase
			2'b01:
				if (!misaligned_st)
					case (data_addr_int[1:0])
						2'b00: data_be = 4'b0011;
						2'b01: data_be = 4'b0110;
						2'b10: data_be = 4'b1100;
						2'b11: data_be = 4'b1000;
					endcase
				else
					data_be = 4'b0001;
			2'b10, 2'b11:
				case (data_addr_int[1:0])
					2'b00: data_be = 4'b0001;
					2'b01: data_be = 4'b0010;
					2'b10: data_be = 4'b0100;
					2'b11: data_be = 4'b1000;
				endcase
		endcase
	assign wdata_offset = data_addr_int[1:0] - data_reg_offset_ex_i[1:0];
	always @(*)
		case (wdata_offset)
			2'b00: data_wdata = data_wdata_ex_i[31:0];
			2'b01: data_wdata = {data_wdata_ex_i[23:0], data_wdata_ex_i[31:24]};
			2'b10: data_wdata = {data_wdata_ex_i[15:0], data_wdata_ex_i[31:16]};
			2'b11: data_wdata = {data_wdata_ex_i[7:0], data_wdata_ex_i[31:8]};
		endcase
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			data_type_q <= 2'h0;
			rdata_offset_q <= 2'h0;
			data_sign_ext_q <= 1'b0;
			data_we_q <= 1'b0;
		end
		else if (data_gnt_i) begin
			data_type_q <= data_type_ex_i;
			rdata_offset_q <= data_addr_int[1:0];
			data_sign_ext_q <= data_sign_ext_ex_i;
			data_we_q <= data_we_ex_i;
		end
	reg [31:0] data_rdata_ext;
	reg [31:0] rdata_w_ext;
	reg [31:0] rdata_h_ext;
	reg [31:0] rdata_b_ext;
	always @(*)
		case (rdata_offset_q)
			2'b00: rdata_w_ext = data_rdata_i[31:0];
			2'b01: rdata_w_ext = {data_rdata_i[7:0], rdata_q[31:8]};
			2'b10: rdata_w_ext = {data_rdata_i[15:0], rdata_q[31:16]};
			2'b11: rdata_w_ext = {data_rdata_i[23:0], rdata_q[31:24]};
		endcase
	always @(*)
		case (rdata_offset_q)
			2'b00:
				if (!data_sign_ext_q)
					rdata_h_ext = {16'h0000, data_rdata_i[15:0]};
				else
					rdata_h_ext = {{16 {data_rdata_i[15]}}, data_rdata_i[15:0]};
			2'b01:
				if (!data_sign_ext_q)
					rdata_h_ext = {16'h0000, data_rdata_i[23:8]};
				else
					rdata_h_ext = {{16 {data_rdata_i[23]}}, data_rdata_i[23:8]};
			2'b10:
				if (!data_sign_ext_q)
					rdata_h_ext = {16'h0000, data_rdata_i[31:16]};
				else
					rdata_h_ext = {{16 {data_rdata_i[31]}}, data_rdata_i[31:16]};
			2'b11:
				if (!data_sign_ext_q)
					rdata_h_ext = {16'h0000, data_rdata_i[7:0], rdata_q[31:24]};
				else
					rdata_h_ext = {{16 {data_rdata_i[7]}}, data_rdata_i[7:0], rdata_q[31:24]};
		endcase
	always @(*)
		case (rdata_offset_q)
			2'b00:
				if (!data_sign_ext_q)
					rdata_b_ext = {24'h000000, data_rdata_i[7:0]};
				else
					rdata_b_ext = {{24 {data_rdata_i[7]}}, data_rdata_i[7:0]};
			2'b01:
				if (!data_sign_ext_q)
					rdata_b_ext = {24'h000000, data_rdata_i[15:8]};
				else
					rdata_b_ext = {{24 {data_rdata_i[15]}}, data_rdata_i[15:8]};
			2'b10:
				if (!data_sign_ext_q)
					rdata_b_ext = {24'h000000, data_rdata_i[23:16]};
				else
					rdata_b_ext = {{24 {data_rdata_i[23]}}, data_rdata_i[23:16]};
			2'b11:
				if (!data_sign_ext_q)
					rdata_b_ext = {24'h000000, data_rdata_i[31:24]};
				else
					rdata_b_ext = {{24 {data_rdata_i[31]}}, data_rdata_i[31:24]};
		endcase
	always @(*)
		case (data_type_q)
			2'b00: data_rdata_ext = rdata_w_ext;
			2'b01: data_rdata_ext = rdata_h_ext;
			2'b10, 2'b11: data_rdata_ext = rdata_b_ext;
		endcase
	localparam [2:0] IDLE = 0;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			CS <= IDLE;
			rdata_q <= {32 {1'sb0}};
			data_misaligned_q <= 1'b0;
			misaligned_addr_o <= 32'b00000000000000000000000000000000;
		end
		else begin
			CS <= NS;
			if (lsu_update_addr_o) begin
				data_misaligned_q <= data_misaligned;
				if (increase_address)
					misaligned_addr_o <= data_addr_int;
			end
			if (data_rvalid_i && !data_we_q)
				if (data_misaligned_q || data_misaligned)
					rdata_q <= data_rdata_i;
				else
					rdata_q <= data_rdata_ext;
		end
	assign data_rdata_ex_o = (data_rvalid_i ? data_rdata_ext : rdata_q);
	assign data_addr_o = data_addr_int;
	assign data_wdata_o = data_wdata;
	assign data_we_o = data_we_ex_i;
	assign data_be_o = data_be;
	assign misaligned_st = data_misaligned_q;
	assign load_err_o = 1'b0;
	assign store_err_o = 1'b0;
	localparam [2:0] WAIT_GNT = 3;
	localparam [2:0] WAIT_GNT_MIS = 1;
	localparam [2:0] WAIT_RVALID = 4;
	localparam [2:0] WAIT_RVALID_MIS = 2;
	always @(*) begin
		NS = CS;
		data_req_o = 1'b0;
		lsu_update_addr_o = 1'b0;
		data_valid_o = 1'b0;
		increase_address = 1'b0;
		data_misaligned_o = 1'b0;
		case (CS)
			IDLE:
				if (data_req_ex_i) begin
					data_req_o = data_req_ex_i;
					if (data_gnt_i) begin
						lsu_update_addr_o = 1'b1;
						increase_address = data_misaligned;
						NS = (data_misaligned ? WAIT_RVALID_MIS : WAIT_RVALID);
					end
					else
						NS = (data_misaligned ? WAIT_GNT_MIS : WAIT_GNT);
				end
			WAIT_GNT_MIS: begin
				data_req_o = 1'b1;
				if (data_gnt_i) begin
					lsu_update_addr_o = 1'b1;
					increase_address = data_misaligned;
					NS = WAIT_RVALID_MIS;
				end
			end
			WAIT_RVALID_MIS: begin
				increase_address = 1'b0;
				data_misaligned_o = 1'b1;
				data_req_o = 1'b0;
				lsu_update_addr_o = data_gnt_i;
				if (data_rvalid_i) begin
					data_req_o = 1'b1;
					if (data_gnt_i)
						NS = WAIT_RVALID;
					else
						NS = WAIT_GNT;
				end
				else
					NS = WAIT_RVALID_MIS;
			end
			WAIT_GNT: begin
				data_misaligned_o = data_misaligned_q;
				data_req_o = 1'b1;
				if (data_gnt_i) begin
					lsu_update_addr_o = 1'b1;
					NS = WAIT_RVALID;
				end
			end
			WAIT_RVALID: begin
				data_req_o = 1'b0;
				if (data_rvalid_i) begin
					data_valid_o = 1'b1;
					NS = IDLE;
				end
				else
					NS = WAIT_RVALID;
			end
			default: NS = IDLE;
		endcase
	end
	always @(*) begin
		data_misaligned = 1'b0;
		if (data_req_ex_i && !data_misaligned_q)
			case (data_type_ex_i)
				2'b00:
					if (data_addr_int[1:0] != 2'b00)
						data_misaligned = 1'b1;
				2'b01:
					if (data_addr_int[1:0] == 2'b11)
						data_misaligned = 1'b1;
				default:
					;
			endcase
	end
	assign data_addr_int = adder_result_ex_i;
	assign busy_o = (CS == WAIT_RVALID) | (data_req_o == 1'b1);
endmodule
module ibex_multdiv_fast (
	clk,
	rst_n,
	mult_en_i,
	div_en_i,
	operator_i,
	signed_mode_i,
	op_a_i,
	op_b_i,
	alu_adder_ext_i,
	alu_adder_i,
	equal_to_zero,
	alu_operand_a_o,
	alu_operand_b_o,
	multdiv_result_o,
	ready_o
);
	input wire clk;
	input wire rst_n;
	input wire mult_en_i;
	input wire div_en_i;
	input wire [1:0] operator_i;
	input wire [1:0] signed_mode_i;
	input wire [31:0] op_a_i;
	input wire [31:0] op_b_i;
	input wire [33:0] alu_adder_ext_i;
	input wire [31:0] alu_adder_i;
	input wire equal_to_zero;
	output reg [32:0] alu_operand_a_o;
	output reg [32:0] alu_operand_b_o;
	output wire [31:0] multdiv_result_o;
	output wire ready_o;
	reg [4:0] div_counter_q;
	reg [4:0] div_counter_n;
	reg [1:0] mult_state_q;
	reg [1:0] mult_state_n;
	reg [2:0] divcurr_state_q;
	reg [2:0] divcurr_state_n;
	wire signed [34:0] mac_res_ext;
	reg [33:0] mac_res_q;
	reg [33:0] mac_res_n;
	wire [33:0] mac_res;
	reg [33:0] op_reminder_n;
	reg [15:0] mult_op_a;
	reg [15:0] mult_op_b;
	reg [33:0] accum;
	reg sign_a;
	reg sign_b;
	wire div_sign_a;
	wire div_sign_b;
	wire signed_mult;
	reg is_greater_equal;
	wire div_change_sign;
	wire rem_change_sign;
	wire [31:0] one_shift;
	reg [31:0] op_denominator_q;
	reg [31:0] op_numerator_q;
	reg [31:0] op_quotient_q;
	reg [31:0] op_denominator_n;
	reg [31:0] op_numerator_n;
	reg [31:0] op_quotient_n;
	wire [31:0] next_reminder;
	wire [32:0] next_quotient;
	wire [32:0] res_adder_h;
	reg mult_is_ready;
	localparam [1:0] ALBL = 0;
	localparam [2:0] MD_IDLE = 0;
	always @(posedge clk or negedge rst_n) begin : proc_mult_state_q
		if (!rst_n) begin
			mult_state_q <= ALBL;
			mac_res_q <= {34 {1'sb0}};
			div_counter_q <= {5 {1'sb0}};
			divcurr_state_q <= MD_IDLE;
			op_denominator_q <= {32 {1'sb0}};
			op_numerator_q <= {32 {1'sb0}};
			op_quotient_q <= {32 {1'sb0}};
		end
		else begin
			if (mult_en_i)
				mult_state_q <= mult_state_n;
			if (div_en_i) begin
				div_counter_q <= div_counter_n;
				op_denominator_q <= op_denominator_n;
				op_numerator_q <= op_numerator_n;
				op_quotient_q <= op_quotient_n;
				divcurr_state_q <= divcurr_state_n;
			end
			case (1'b1)
				mult_en_i: mac_res_q <= mac_res_n;
				div_en_i: mac_res_q <= op_reminder_n;
				default: mac_res_q <= mac_res_q;
			endcase
		end
	end
	assign signed_mult = signed_mode_i != 2'b00;
	assign multdiv_result_o = (div_en_i ? mac_res_q[31:0] : mac_res_n[31:0]);
	assign mac_res_ext = ($signed({sign_a, mult_op_a}) * $signed({sign_b, mult_op_b})) + $signed(accum);
	assign mac_res = mac_res_ext[33:0];
	assign res_adder_h = alu_adder_ext_i[33:1];
	assign next_reminder = (is_greater_equal ? res_adder_h[31:0] : mac_res_q[31:0]);
	assign next_quotient = (is_greater_equal ? {1'b0, op_quotient_q} | {1'b0, one_shift} : {1'b0, op_quotient_q});
	assign one_shift = 32'b00000000000000000000000000000001 << div_counter_q;
	always @(*)
		if ((mac_res_q[31] ^ op_denominator_q[31]) == 1'b0)
			is_greater_equal = res_adder_h[31] == 1'b0;
		else
			is_greater_equal = mac_res_q[31];
	assign div_sign_a = op_a_i[31] & signed_mode_i[0];
	assign div_sign_b = op_b_i[31] & signed_mode_i[1];
	assign div_change_sign = div_sign_a ^ div_sign_b;
	assign rem_change_sign = div_sign_a;
	localparam [2:0] MD_ABS_A = 1;
	localparam [2:0] MD_ABS_B = 2;
	localparam [2:0] MD_CHANGE_SIGN = 5;
	localparam [2:0] MD_COMP = 3;
	localparam [2:0] MD_FINISH = 6;
	localparam [2:0] MD_LAST = 4;
	localparam [1:0] ibex_defines_MD_OP_DIV = 2;
	always @(*) begin : div_fsm
		div_counter_n = div_counter_q - 5'h01;
		op_reminder_n = mac_res_q;
		op_quotient_n = op_quotient_q;
		divcurr_state_n = divcurr_state_q;
		op_numerator_n = op_numerator_q;
		op_denominator_n = op_denominator_q;
		alu_operand_a_o = 33'b000000000000000000000000000000001;
		alu_operand_b_o = {~op_b_i, 1'b1};
		case (divcurr_state_q)
			MD_IDLE: begin
				if (operator_i == ibex_defines_MD_OP_DIV) begin
					op_reminder_n = {34 {1'sb1}};
					divcurr_state_n = (equal_to_zero ? MD_FINISH : MD_ABS_A);
				end
				else begin
					op_reminder_n = {2'b00, op_a_i};
					divcurr_state_n = (equal_to_zero ? MD_FINISH : MD_ABS_A);
				end
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_b_i, 1'b1};
				div_counter_n = 5'd31;
			end
			MD_ABS_A: begin
				op_quotient_n = {32 {1'sb0}};
				op_numerator_n = (div_sign_a ? alu_adder_i : op_a_i);
				divcurr_state_n = MD_ABS_B;
				div_counter_n = 5'd31;
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_a_i, 1'b1};
			end
			MD_ABS_B: begin
				op_reminder_n = {33'h000000000, op_numerator_q[31]};
				op_denominator_n = (div_sign_b ? alu_adder_i : op_b_i);
				divcurr_state_n = MD_COMP;
				div_counter_n = 5'd31;
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_b_i, 1'b1};
			end
			MD_COMP: begin
				op_reminder_n = {1'b0, next_reminder[31:0], op_numerator_q[div_counter_n]};
				op_quotient_n = next_quotient[31:0];
				divcurr_state_n = (div_counter_q == 5'd1 ? MD_LAST : MD_COMP);
				alu_operand_a_o = {mac_res_q[31:0], 1'b1};
				alu_operand_b_o = {~op_denominator_q[31:0], 1'b1};
			end
			MD_LAST: begin
				if (operator_i == ibex_defines_MD_OP_DIV)
					op_reminder_n = {1'b0, next_quotient};
				else
					op_reminder_n = {2'b00, next_reminder[31:0]};
				alu_operand_a_o = {mac_res_q[31:0], 1'b1};
				alu_operand_b_o = {~op_denominator_q[31:0], 1'b1};
				divcurr_state_n = MD_CHANGE_SIGN;
			end
			MD_CHANGE_SIGN: begin
				divcurr_state_n = MD_FINISH;
				if (operator_i == ibex_defines_MD_OP_DIV)
					op_reminder_n = (div_change_sign ? {2'h0, alu_adder_i} : mac_res_q);
				else
					op_reminder_n = (rem_change_sign ? {2'h0, alu_adder_i} : mac_res_q);
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~mac_res_q[31:0], 1'b1};
			end
			MD_FINISH: divcurr_state_n = MD_IDLE;
			default:
				;
		endcase
	end
	assign ready_o = mult_is_ready | (divcurr_state_q == MD_FINISH);
	localparam [1:0] AHBH = 3;
	localparam [1:0] AHBL = 2;
	localparam [1:0] ALBH = 1;
	localparam [1:0] ibex_defines_MD_OP_MULL = 0;
	always @(*) begin : mult_fsm
		mult_op_a = op_a_i[15:0];
		mult_op_b = op_b_i[15:0];
		sign_a = 1'b0;
		sign_b = 1'b0;
		accum = mac_res_q;
		mac_res_n = mac_res;
		mult_state_n = mult_state_q;
		mult_is_ready = 1'b0;
		case (mult_state_q)
			ALBL: begin
				mult_op_a = op_a_i[15:0];
				mult_op_b = op_b_i[15:0];
				sign_a = 1'b0;
				sign_b = 1'b0;
				accum = {34 {1'sb0}};
				mac_res_n = mac_res;
				mult_state_n = ALBH;
			end
			ALBH: begin
				mult_op_a = op_a_i[15:0];
				mult_op_b = op_b_i[31:16];
				sign_a = 1'b0;
				sign_b = signed_mode_i[1] & op_b_i[31];
				accum = {18'b000000000000000000, mac_res_q[31:16]};
				if (operator_i == ibex_defines_MD_OP_MULL)
					mac_res_n = {2'b00, mac_res[15:0], mac_res_q[15:0]};
				else
					mac_res_n = mac_res;
				mult_state_n = AHBL;
			end
			AHBL: begin
				mult_op_a = op_a_i[31:16];
				mult_op_b = op_b_i[15:0];
				sign_a = signed_mode_i[0] & op_a_i[31];
				sign_b = 1'b0;
				if (operator_i == ibex_defines_MD_OP_MULL) begin
					accum = {18'b000000000000000000, mac_res_q[31:16]};
					mac_res_n = {2'b00, mac_res[15:0], mac_res_q[15:0]};
					mult_is_ready = 1'b1;
					mult_state_n = ALBL;
				end
				else begin
					accum = mac_res_q;
					mac_res_n = mac_res;
					mult_state_n = AHBH;
				end
			end
			AHBH: begin
				mult_op_a = op_a_i[31:16];
				mult_op_b = op_b_i[31:16];
				sign_a = signed_mode_i[0] & op_a_i[31];
				sign_b = signed_mode_i[1] & op_b_i[31];
				accum[17:0] = mac_res_q[33:16];
				accum[33:18] = {16 {signed_mult & mac_res_q[33]}};
				mac_res_n = mac_res;
				mult_state_n = ALBL;
				mult_is_ready = 1'b1;
			end
			default:
				;
		endcase
	end
endmodule
module ibex_multdiv_slow (
	clk,
	rst_n,
	mult_en_i,
	div_en_i,
	operator_i,
	signed_mode_i,
	op_a_i,
	op_b_i,
	alu_adder_ext_i,
	alu_adder_i,
	equal_to_zero,
	alu_operand_a_o,
	alu_operand_b_o,
	multdiv_result_o,
	ready_o
);
	input wire clk;
	input wire rst_n;
	input wire mult_en_i;
	input wire div_en_i;
	input wire [1:0] operator_i;
	input wire [1:0] signed_mode_i;
	input wire [31:0] op_a_i;
	input wire [31:0] op_b_i;
	input wire [33:0] alu_adder_ext_i;
	input wire [31:0] alu_adder_i;
	input wire equal_to_zero;
	output reg [32:0] alu_operand_a_o;
	output reg [32:0] alu_operand_b_o;
	output reg [31:0] multdiv_result_o;
	output wire ready_o;
	reg [4:0] multdiv_state_q;
	reg [4:0] multdiv_state_d;
	wire [4:0] multdiv_state_m1;
	reg [2:0] curr_state_q;
	reg [2:0] curr_state_d;
	reg [32:0] accum_window_q;
	reg [32:0] accum_window_d;
	wire [32:0] res_adder_l;
	wire [32:0] res_adder_h;
	reg [32:0] op_b_shift_q;
	reg [32:0] op_b_shift_d;
	reg [32:0] op_a_shift_q;
	reg [32:0] op_a_shift_d;
	wire [32:0] op_a_ext;
	wire [32:0] op_b_ext;
	wire [32:0] one_shift;
	wire [32:0] op_a_bw_pp;
	wire [32:0] op_a_bw_last_pp;
	wire [31:0] b_0;
	wire sign_a;
	wire sign_b;
	wire [32:0] next_reminder;
	wire [32:0] next_quotient;
	wire [32:0] op_remainder;
	reg [31:0] op_numerator_q;
	reg [31:0] op_numerator_d;
	wire is_greater_equal;
	wire div_change_sign;
	wire rem_change_sign;
	assign res_adder_l = alu_adder_ext_i[32:0];
	assign res_adder_h = alu_adder_ext_i[33:1];
	localparam [2:0] MD_ABS_A = 1;
	localparam [2:0] MD_ABS_B = 2;
	localparam [2:0] MD_CHANGE_SIGN = 5;
	localparam [2:0] MD_IDLE = 0;
	localparam [2:0] MD_LAST = 4;
	localparam [1:0] ibex_defines_MD_OP_MULH = 1;
	localparam [1:0] ibex_defines_MD_OP_MULL = 0;
	always @(*) begin
		alu_operand_a_o = accum_window_q;
		multdiv_result_o = (div_en_i ? accum_window_q[31:0] : res_adder_l);
		case (operator_i)
			ibex_defines_MD_OP_MULL: alu_operand_b_o = op_a_bw_pp;
			ibex_defines_MD_OP_MULH: alu_operand_b_o = (curr_state_q == MD_LAST ? op_a_bw_last_pp : op_a_bw_pp);
			default:
				case (curr_state_q)
					MD_IDLE: begin
						alu_operand_a_o = 33'b000000000000000000000000000000001;
						alu_operand_b_o = {~op_b_i, 1'b1};
					end
					MD_ABS_A: begin
						alu_operand_a_o = 33'b000000000000000000000000000000001;
						alu_operand_b_o = {~op_a_i, 1'b1};
					end
					MD_ABS_B: begin
						alu_operand_a_o = 33'b000000000000000000000000000000001;
						alu_operand_b_o = {~op_b_i, 1'b1};
					end
					MD_CHANGE_SIGN: begin
						alu_operand_a_o = 33'b000000000000000000000000000000001;
						alu_operand_b_o = {~accum_window_q[31:0], 1'b1};
					end
					default: begin
						alu_operand_a_o = {accum_window_q[31:0], 1'b1};
						alu_operand_b_o = {~op_b_shift_q[31:0], 1'b1};
					end
				endcase
		endcase
	end
	assign is_greater_equal = ((accum_window_q[31] ^ op_b_shift_q[31]) == 1'b0 ? res_adder_h[31] == 1'b0 : accum_window_q[31]);
	assign one_shift = 33'b000000000000000000000000000000001 << multdiv_state_q;
	assign next_reminder = (is_greater_equal ? res_adder_h : op_remainder);
	assign next_quotient = (is_greater_equal ? op_a_shift_q | one_shift : op_a_shift_q);
	assign b_0 = {32 {op_b_shift_q[0]}};
	assign op_a_bw_pp = {~(op_a_shift_q[32] & op_b_shift_q[0]), op_a_shift_q[31:0] & b_0};
	assign op_a_bw_last_pp = {op_a_shift_q[32] & op_b_shift_q[0], ~(op_a_shift_q[31:0] & b_0)};
	assign sign_a = op_a_i[31] & signed_mode_i[0];
	assign sign_b = op_b_i[31] & signed_mode_i[1];
	assign op_a_ext = {sign_a, op_a_i};
	assign op_b_ext = {sign_b, op_b_i};
	assign op_remainder = accum_window_q[32:0];
	assign multdiv_state_m1 = multdiv_state_q - 5'h01;
	assign div_change_sign = sign_a ^ sign_b;
	assign rem_change_sign = sign_a;
	always @(posedge clk or negedge rst_n) begin : proc_multdiv_state_q
		if (!rst_n) begin
			multdiv_state_q <= 5'h00;
			accum_window_q <= 33'h000000000;
			op_b_shift_q <= 33'h000000000;
			op_a_shift_q <= 33'h000000000;
			op_numerator_q <= 32'h00000000;
			curr_state_q <= MD_IDLE;
		end
		else begin
			multdiv_state_q <= multdiv_state_d;
			accum_window_q <= accum_window_d;
			op_b_shift_q <= op_b_shift_d;
			op_a_shift_q <= op_a_shift_d;
			op_numerator_q <= op_numerator_d;
			curr_state_q <= curr_state_d;
		end
	end
	localparam [2:0] MD_COMP = 3;
	localparam [2:0] MD_FINISH = 6;
	localparam [1:0] ibex_defines_MD_OP_DIV = 2;
	always @(*) begin
		multdiv_state_d = multdiv_state_q;
		accum_window_d = accum_window_q;
		op_b_shift_d = op_b_shift_q;
		op_a_shift_d = op_a_shift_q;
		op_numerator_d = op_numerator_q;
		curr_state_d = curr_state_q;
		if (mult_en_i || div_en_i)
			case (curr_state_q)
				MD_IDLE: begin
					case (operator_i)
						ibex_defines_MD_OP_MULL: begin
							op_a_shift_d = op_a_ext << 1;
							accum_window_d = {~(op_a_ext[32] & op_b_i[0]), op_a_ext[31:0] & {32 {op_b_i[0]}}};
							op_b_shift_d = op_b_ext >> 1;
							curr_state_d = MD_COMP;
						end
						ibex_defines_MD_OP_MULH: begin
							op_a_shift_d = op_a_ext;
							accum_window_d = {1'b1, ~(op_a_ext[32] & op_b_i[0]), op_a_ext[31:1] & {31 {op_b_i[0]}}};
							op_b_shift_d = op_b_ext >> 1;
							curr_state_d = MD_COMP;
						end
						ibex_defines_MD_OP_DIV: begin
							accum_window_d = {33 {1'b1}};
							curr_state_d = (equal_to_zero ? MD_FINISH : MD_ABS_A);
						end
						default: begin
							accum_window_d = op_a_ext;
							curr_state_d = (equal_to_zero ? MD_FINISH : MD_ABS_A);
						end
					endcase
					multdiv_state_d = 5'd31;
				end
				MD_ABS_A: begin
					op_a_shift_d = {33 {1'sb0}};
					op_numerator_d = (sign_a ? alu_adder_i : op_a_i);
					curr_state_d = MD_ABS_B;
				end
				MD_ABS_B: begin
					accum_window_d = {32'h00000000, op_numerator_q[31]};
					op_b_shift_d = (sign_b ? alu_adder_i : op_b_i);
					curr_state_d = MD_COMP;
				end
				MD_COMP: begin
					multdiv_state_d = multdiv_state_m1;
					case (operator_i)
						ibex_defines_MD_OP_MULL: begin
							accum_window_d = res_adder_l;
							op_a_shift_d = op_a_shift_q << 1;
							op_b_shift_d = op_b_shift_q >> 1;
						end
						ibex_defines_MD_OP_MULH: begin
							accum_window_d = res_adder_h;
							op_a_shift_d = op_a_shift_q;
							op_b_shift_d = op_b_shift_q >> 1;
						end
						default: begin
							accum_window_d = {next_reminder[31:0], op_numerator_q[multdiv_state_m1]};
							op_a_shift_d = next_quotient;
						end
					endcase
					curr_state_d = (multdiv_state_q == 5'd1 ? MD_LAST : MD_COMP);
				end
				MD_LAST:
					case (operator_i)
						ibex_defines_MD_OP_MULL: begin
							accum_window_d = res_adder_l;
							curr_state_d = MD_IDLE;
						end
						ibex_defines_MD_OP_MULH: begin
							accum_window_d = res_adder_l;
							curr_state_d = MD_IDLE;
						end
						ibex_defines_MD_OP_DIV: begin
							accum_window_d = next_quotient;
							curr_state_d = MD_CHANGE_SIGN;
						end
						default: begin
							accum_window_d = {1'b0, next_reminder[31:0]};
							curr_state_d = MD_CHANGE_SIGN;
						end
					endcase
				MD_CHANGE_SIGN: begin
					curr_state_d = MD_FINISH;
					case (operator_i)
						ibex_defines_MD_OP_DIV: accum_window_d = (div_change_sign ? alu_adder_i : accum_window_q);
						default: accum_window_d = (rem_change_sign ? alu_adder_i : accum_window_q);
					endcase
				end
				MD_FINISH: curr_state_d = MD_IDLE;
				default:
					;
			endcase
	end
	assign ready_o = (curr_state_q == MD_FINISH) | ((curr_state_q == MD_LAST) & ((operator_i == ibex_defines_MD_OP_MULL) | (operator_i == ibex_defines_MD_OP_MULH)));
endmodule
module ibex_prefetch_buffer (
	clk,
	rst_n,
	req_i,
	branch_i,
	addr_i,
	ready_i,
	valid_o,
	rdata_o,
	addr_o,
	instr_req_o,
	instr_gnt_i,
	instr_addr_o,
	instr_rdata_i,
	instr_rvalid_i,
	busy_o
);
	input wire clk;
	input wire rst_n;
	input wire req_i;
	input wire branch_i;
	input wire [31:0] addr_i;
	input wire ready_i;
	output wire valid_o;
	output wire [31:0] rdata_o;
	output wire [31:0] addr_o;
	output reg instr_req_o;
	input wire instr_gnt_i;
	output reg [31:0] instr_addr_o;
	input wire [31:0] instr_rdata_i;
	input wire instr_rvalid_i;
	output wire busy_o;
	reg [1:0] CS;
	reg [1:0] NS;
	reg [31:0] instr_addr_q;
	wire [31:0] fetch_addr;
	reg addr_valid;
	reg fifo_valid;
	wire fifo_ready;
	wire fifo_clear;
	localparam [1:0] IDLE = 0;
	assign busy_o = (CS != IDLE) | instr_req_o;
	ibex_fetch_fifo fifo_i(
		.clk(clk),
		.rst_n(rst_n),
		.clear_i(fifo_clear),
		.in_addr_i(instr_addr_q),
		.in_rdata_i(instr_rdata_i),
		.in_valid_i(fifo_valid),
		.in_ready_o(fifo_ready),
		.out_valid_o(valid_o),
		.out_ready_i(ready_i),
		.out_rdata_o(rdata_o),
		.out_addr_o(addr_o),
		.out_valid_stored_o()
	);
	assign fetch_addr = {instr_addr_q[31:2], 2'b00} + 32'd4;
	assign fifo_clear = branch_i;
	localparam [1:0] WAIT_ABORTED = 3;
	localparam [1:0] WAIT_GNT = 1;
	localparam [1:0] WAIT_RVALID = 2;
	always @(*) begin
		instr_req_o = 1'b0;
		instr_addr_o = fetch_addr;
		fifo_valid = 1'b0;
		addr_valid = 1'b0;
		NS = CS;
		case (CS)
			IDLE: begin
				instr_addr_o = fetch_addr;
				instr_req_o = 1'b0;
				if (branch_i)
					instr_addr_o = addr_i;
				if (req_i && (fifo_ready || branch_i)) begin
					instr_req_o = 1'b1;
					addr_valid = 1'b1;
					NS = (instr_gnt_i ? WAIT_RVALID : WAIT_GNT);
				end
			end
			WAIT_GNT: begin
				instr_addr_o = instr_addr_q;
				instr_req_o = 1'b1;
				if (branch_i) begin
					instr_addr_o = addr_i;
					addr_valid = 1'b1;
				end
				NS = (instr_gnt_i ? WAIT_RVALID : WAIT_GNT);
			end
			WAIT_RVALID: begin
				instr_addr_o = fetch_addr;
				if (branch_i)
					instr_addr_o = addr_i;
				if (req_i && (fifo_ready || branch_i)) begin
					if (instr_rvalid_i) begin
						instr_req_o = 1'b1;
						fifo_valid = 1'b1;
						addr_valid = 1'b1;
						NS = (instr_gnt_i ? WAIT_RVALID : WAIT_GNT);
					end
					else if (branch_i) begin
						addr_valid = 1'b1;
						NS = WAIT_ABORTED;
					end
				end
				else if (instr_rvalid_i) begin
					fifo_valid = 1'b1;
					NS = IDLE;
				end
			end
			WAIT_ABORTED: begin
				instr_addr_o = instr_addr_q;
				if (branch_i) begin
					instr_addr_o = addr_i;
					addr_valid = 1'b1;
				end
				if (instr_rvalid_i) begin
					instr_req_o = 1'b1;
					NS = (instr_gnt_i ? WAIT_RVALID : WAIT_GNT);
				end
			end
			default:
				;
		endcase
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			CS <= IDLE;
			instr_addr_q <= {32 {1'sb0}};
		end
		else begin
			CS <= NS;
			if (addr_valid)
				instr_addr_q <= instr_addr_o;
		end
endmodule
module ibex_register_file (
	clk,
	rst_n,
	test_en_i,
	raddr_a_i,
	rdata_a_o,
	raddr_b_i,
	rdata_b_o,
	waddr_a_i,
	wdata_a_i,
	we_a_i
);
	parameter [0:0] RV32E = 0;
	parameter DATA_WIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [4:0] raddr_a_i;
	output wire [DATA_WIDTH - 1:0] rdata_a_o;
	input wire [4:0] raddr_b_i;
	output wire [DATA_WIDTH - 1:0] rdata_b_o;
	input wire [4:0] waddr_a_i;
	input wire [DATA_WIDTH - 1:0] wdata_a_i;
	input wire we_a_i;
	localparam ADDR_WIDTH = (RV32E ? 4 : 5);
	localparam NUM_WORDS = 2 ** ADDR_WIDTH;
	wire [(NUM_WORDS * DATA_WIDTH) - 1:0] rf_reg;
	reg [((NUM_WORDS - 1) >= 1 ? ((NUM_WORDS - 1) * DATA_WIDTH) + (DATA_WIDTH - 1) : ((3 - NUM_WORDS) * DATA_WIDTH) + (((NUM_WORDS - 1) * DATA_WIDTH) - 1)):((NUM_WORDS - 1) >= 1 ? DATA_WIDTH : (NUM_WORDS - 1) * DATA_WIDTH)] rf_reg_tmp;
	reg [NUM_WORDS - 1:1] we_a_dec;
	always @(*) begin : we_a_decoder
		begin : sv2v_autoblock_19
			reg signed [31:0] i;
			for (i = 1; i < NUM_WORDS; i = i + 1)
				we_a_dec[i] = (waddr_a_i == i ? we_a_i : 1'b0);
		end
	end
	function automatic [DATA_WIDTH - 1:0] sv2v_cast_2E65F;
		input reg [DATA_WIDTH - 1:0] inp;
		sv2v_cast_2E65F = inp;
	endfunction
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			rf_reg_tmp <= {((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS) {sv2v_cast_2E65F(1'sb0)}};
		else begin : sv2v_autoblock_20
			reg signed [31:0] r;
			for (r = 1; r < NUM_WORDS; r = r + 1)
				if (we_a_dec[r])
					rf_reg_tmp[((NUM_WORDS - 1) >= 1 ? r : 1 - (r - (NUM_WORDS - 1))) * DATA_WIDTH+:DATA_WIDTH] <= wdata_a_i;
		end
	assign rf_reg[0+:DATA_WIDTH] = {DATA_WIDTH {1'sb0}};
	assign rf_reg[DATA_WIDTH * (((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : ((NUM_WORDS - 1) + ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)) - 1) - (((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS) - 1))+:DATA_WIDTH * ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)] = rf_reg_tmp[DATA_WIDTH * ((NUM_WORDS - 1) >= 1 ? ((NUM_WORDS - 1) >= 1 ? ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : ((NUM_WORDS - 1) + ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)) - 1) - (((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS) - 1) : ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : ((NUM_WORDS - 1) + ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)) - 1)) : 1 - (((NUM_WORDS - 1) >= 1 ? ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : ((NUM_WORDS - 1) + ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)) - 1) - (((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS) - 1) : ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : ((NUM_WORDS - 1) + ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)) - 1)) - (NUM_WORDS - 1)))+:DATA_WIDTH * ((NUM_WORDS - 1) >= 1 ? NUM_WORDS - 1 : 3 - NUM_WORDS)];
	assign rdata_a_o = rf_reg[raddr_a_i * DATA_WIDTH+:DATA_WIDTH];
	assign rdata_b_o = rf_reg[raddr_b_i * DATA_WIDTH+:DATA_WIDTH];
endmodule
module prim_clock_gating (
	clk_i,
	en_i,
	test_en_i,
	clk_o
);
	input wire clk_i;
	input wire en_i;
	input wire test_en_i;
	output wire clk_o;
	reg clk_en;
	always @(*)
		if (clk_i == 1'b0)
			clk_en <= en_i | test_en_i;
	assign clk_o = clk_i & clk_en;
endmodule
module ram (
	clk,
	instr_req_i,
	instr_addr_i,
	instr_rdata_o,
	instr_rvalid_o,
	instr_gnt_o,
	ibex_data_req_i,
	ibex_data_addr_i,
	ibex_data_we_i,
	ibex_data_be_i,
	ibex_data_wdata_i,
	ibex_data_rdata_o,
	ibex_data_rvalid_o,
	ibex_data_gnt_o,
	ext_data_req_i,
	ext_data_addr_i,
	ext_data_we_i,
	ext_data_be_i,
	ext_data_wdata_i,
	ext_data_rdata_o,
	ext_data_rvalid_o
);
	parameter ADDR_WIDTH = 10;
	input wire clk;
	input wire instr_req_i;
	input wire [ADDR_WIDTH - 1:0] instr_addr_i;
	output wire [31:0] instr_rdata_o;
	output reg instr_rvalid_o;
	output wire instr_gnt_o;
	input wire ibex_data_req_i;
	input wire [ADDR_WIDTH - 1:0] ibex_data_addr_i;
	input wire ibex_data_we_i;
	input wire [3:0] ibex_data_be_i;
	input wire [31:0] ibex_data_wdata_i;
	output wire [31:0] ibex_data_rdata_o;
	output reg ibex_data_rvalid_o;
	output wire ibex_data_gnt_o;
	input wire ext_data_req_i;
	input wire [ADDR_WIDTH - 1:0] ext_data_addr_i;
	input wire ext_data_we_i;
	input wire [3:0] ext_data_be_i;
	input wire [31:0] ext_data_wdata_i;
	output wire [31:0] ext_data_rdata_o;
	output reg ext_data_rvalid_o;
	wire data_req_i;
	wire [ADDR_WIDTH - 1:0] data_addr_i;
	wire [31:0] data_wdata_i;
	wire [31:0] data_rdata_o;
	wire data_we_i;
	wire [3:0] data_be_i;
	assign data_req_i = (ext_data_req_i ? ext_data_req_i : ibex_data_req_i);
	assign data_addr_i = (ext_data_req_i ? ext_data_addr_i : ibex_data_addr_i);
	assign data_wdata_i = (ext_data_req_i ? ext_data_wdata_i : ibex_data_wdata_i);
	assign ext_data_rdata_o = data_rdata_o;
	assign ibex_data_rdata_o = data_rdata_o;
	assign data_we_i = (ext_data_req_i ? ext_data_we_i : ibex_data_we_i);
	assign data_be_i = (ext_data_req_i ? ext_data_be_i : ibex_data_be_i);
	assign ibex_data_gnt_o = !ext_data_req_i & ibex_data_req_i;
	sky130_sram_1kbyte_1rw1r_32x256_8 sram_i(
		.clk0(clk),
		.csb0(!data_req_i),
		.web0(!data_be_i),
		.wmask0(data_be_i),
		.addr0(data_addr_i),
		.din0(data_wdata_i),
		.dout0(data_rdata_o),
		.clk1(clk),
		.csb1(!instr_addr_i),
		.addr1(instr_addr_i),
		.dout1(instr_rdata_o)
	);
	assign instr_gnt_o = instr_req_i;
	always @(posedge clk) begin
		if (ext_data_req_i)
			ext_data_rvalid_o <= data_req_i;
		else
			ibex_data_rvalid_o <= data_req_i;
		instr_rvalid_o <= instr_req_i;
	end
endmodule
`default_nettype none
module sram_1rw1r_32_256_8_sky130 (
	clk0,
	csb0,
	web0,
	wmask0,
	addr0,
	din0,
	dout0,
	clk1,
	csb1,
	addr1,
	dout1
);
	parameter NUM_WMASKS = 4;
	parameter DATA_WIDTH = 32;
	parameter ADDR_WIDTH = 10;
	parameter RAM_DEPTH = 1 << ADDR_WIDTH;
	parameter DELAY = 3;
	input clk0;
	input csb0;
	input web0;
	input [NUM_WMASKS - 1:0] wmask0;
	input [ADDR_WIDTH - 1:0] addr0;
	input [DATA_WIDTH - 1:0] din0;
	output [DATA_WIDTH - 1:0] dout0;
	input clk1;
	input csb1;
	input [ADDR_WIDTH - 1:0] addr1;
	output [DATA_WIDTH - 1:0] dout1;
	reg csb0_reg;
	reg web0_reg;
	reg [NUM_WMASKS - 1:0] wmask0_reg;
	reg [ADDR_WIDTH - 1:0] addr0_reg;
	reg [DATA_WIDTH - 1:0] din0_reg;
	always @(posedge clk0) begin
		csb0_reg = csb0;
		web0_reg = web0;
		wmask0_reg = wmask0;
		addr0_reg = addr0;
		din0_reg = din0;
	end
	reg csb1_reg;
	reg [ADDR_WIDTH - 1:0] addr1_reg;
	always @(posedge clk1) begin
		csb1_reg = csb1;
		addr1_reg = addr1;
	end
	reg [DATA_WIDTH - 1:0] mem [0:RAM_DEPTH - 1];
	always @(negedge clk0) begin : MEM_WRITE0
		if (!csb0_reg && !web0_reg) begin
			if (wmask0_reg[0])
				mem[addr0_reg][7:0] = din0_reg[7:0];
			if (wmask0_reg[1])
				mem[addr0_reg][15:8] = din0_reg[15:8];
			if (wmask0_reg[2])
				mem[addr0_reg][23:16] = din0_reg[23:16];
			if (wmask0_reg[3])
				mem[addr0_reg][31:24] = din0_reg[31:24];
		end
	end
	always @(negedge clk0) begin : MEM_READ0
		if (!csb0_reg && web0_reg)
			dout0 <= mem[addr0_reg];
	end
	always @(negedge clk1) begin : MEM_READ1
		if (!csb1_reg)
			dout1 <= mem[addr1_reg];
	end
	function [31:0] readWord;
		input integer word_addr;
		readWord = mem[word_addr];
	endfunction
	task writeWord;
		input integer word_addr;
		input [31:0] val;
		mem[word_addr] = val;
	endtask
endmodule
`default_nettype wire
