// SPDX-FileCopyrightText: 2020 Efabless Corporation
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
// SPDX-License-Identifier: Apache-2.0
`define MEM_WORDS 256
`define COLS 1

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
 /*
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
*/

/*
    // Logic Analyzer Signals
    input  [127:0] la_data_in,
*/
//output [10:0] la_data_out,

/*    
	input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,

	    output [`MPRJ_IO_PADS-1:0] io_out,
		    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq,
*/
//	    input clk

    input clk_i, //main clock 20mhz
    input debug_req_i,
    input fetch_enable_i, //enable cpu
    output irq_ack_o,
    input irq_i,
    input [4:0]irq_id_i,
    output [4:0]irq_id_o,
    input reset,
    output [31:0] eFPGA_operand_a_o,
    output [31:0] eFPGA_operand_b_o,
    input [31:0] eFPGA_result_a_i,
    input [31:0] eFPGA_result_b_i,
    input [31:0] eFPGA_result_c_i, //total 160 pins to fpga
    output eFPGA_write_strobe_o,
    input eFPGA_fpga_done_i,
    output eFPGA_en_o,
    output [1:0] eFPGA_operator_o,
    output [3:0] eFPGA_delay_o,

    output [31:0]flexbex_data_addr_o,
    output [3:0]flexbex_data_be_o,
    input flexbex_data_gnt_i,
    input [31:0]flexbex_data_rdata_i,
    output flexbex_data_req_o,
    input flexbex_data_rvalid_i,
    output [31:0]flexbex_data_wdata_o,
    output flexbex_data_we_o,
    output [31:0]flexbex_instr_addr_o,
    input flexbex_instr_gnt_i,
    input [31:0]flexbex_instr_rdata_i,
    output flexbex_instr_req_o,
    input flexbex_instr_rvalid_i

);



/*
mem_wb mprj (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    .wb_adr_i(wbs_adr_i),
    .wb_dat_i(wbs_dat_i),
    .wb_sel_i(wbs_sel_i),
    .wb_we_i(wbs_we_i),
    .wb_cyc_i(wbs_cyc_i),
    .wb_stb_i(wbs_stb_i),
    .wb_ack_o(wbs_ack_o),
    .wb_dat_o(wbs_dat_o)

);

*/

    ibex_core ibex_core_i
         (.boot_addr_i(32'd0),
          .clk_i(clk_i),
          .cluster_id_i(6'd0),
          .core_id_i(4'd0),
          .data_addr_o(flexbex_data_addr_o),
          .data_be_o(flexbex_data_be_o),
          .data_err_i(1'b0),
          .data_gnt_i(flexbex_data_gnt_i),
          .data_rdata_i(flexbex_data_rdata_i),
          .data_req_o(flexbex_data_req_o),
          .data_rvalid_i(flexbex_data_rvalid_i),
          .data_wdata_o(flexbex_data_wdata_o),
          .data_we_o(flexbex_data_we_o),
          .debug_req_i(debug_req_i),
          .ext_perf_counters_i(1'b0),
          .fetch_enable_i(fetch_enable_i),
          .instr_addr_o(flexbex_instr_addr_o),
          .instr_gnt_i(flexbex_instr_gnt_i),
          .instr_rdata_i(flexbex_instr_rdata_i),
          .instr_req_o(flexbex_instr_req_o),
          .instr_rvalid_i(flexbex_instr_rvalid_i),
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
          .eFPGA_delay_o(eFPGA_delay_o));




    // Assuming LA probes [65:64] are for controlling the count clk & reset  
   // assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
   // assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;
/*
wire [11:0] address;
assign address = 12'd0;

wire [4:0]irq_id_o;
assign la_data_out[0] = ~irq_id_o;

wire [31:0]cont_2_uart_w_0_read_data_o;
assign la_data_out[2] = ~cont_2_uart_w_0_read_data_o;

wire [31:0] eFPGA_operand_a_o;
assign la_data_out[4] = ~eFPGA_operand_a_o;

wire [31:0] eFPGA_operand_b_o;
assign la_data_out[5] = ~eFPGA_operand_b_o;

wire [1:0] eFPGA_operator_o;
assign la_data_out[9] = ~eFPGA_operator_o;

wire [3:0] eFPGA_delay_o;
assign la_data_out[10] = ~eFPGA_delay_o;



forte_soc_top mprj(
        .reset(wb_rst_i),
        .clk_i(clk),
        .irq_id_o(irq_id_o),
        .irq_id_i(1'd0),
        .irq_i(1'd0),
        .irq_ack_o(la_data_out[1]),
        .debug_req_i(1'd1),
        .fetch_enable_i(1'd1),
        .eFPGA_operand_a_o(eFPGA_operand_a_o),
        .eFPGA_operand_b_o(eFPGA_operand_b_o),
        .eFPGA_result_a_i(32'd0),
        .eFPGA_result_b_i(32'd0),
        .eFPGA_result_c_i(32'd0),
        .eFPGA_write_strobe_o(la_data_out[7]),
        .eFPGA_fpga_done_i(1'd1),
        .eFPGA_en_o(la_data_out[8]),
        .eFPGA_operator_o(eFPGA_operator_o),
        .eFPGA_delay_o(eFPGA_delay_o),
         .ext_data_addr_i(wbs_adr_i[10-1:0]),
         .ext_data_be_i(wbs_sel_i),
         .ext_data_gnt_o(wbs_ack_o),
         .ext_data_rdata_o(wbs_dat_o),
         .ext_data_req_i(wbs_stb_i & wbs_cyc_i),
         .ext_data_rvalid_o(wbs_ack_o),
         .ext_data_wdata_i(wbs_dat_i),
         .ext_data_we_i(wbs_we_i)
	
);      
*/

endmodule


`default_nettype wire
