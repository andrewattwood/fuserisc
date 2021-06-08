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
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

    // Assuming LA probes [65:64] are for controlling the count clk & reset  
   // assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
   // assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

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




design_2_top mprdesign_2_top_i(
        .reset(wb_rst_i),
        .clk(user_clock2),
        .we_i(1'b1),
        .irq_id_o(irq_id_o),
        .irq_id_i(1'd0),
        .irq_i(1'd0),
        .irq_ack_o(la_data_out[1]),
        .debug_req_i(1'd1),
        .start(1'd1),
        .cont_2_uart_w_0_read_data_o(cont_2_uart_w_0_read_data_o),
        .data(32'd0),
        .address(address),
        .cont_2_uart_w_0_complete(la_data_out[3]),
        .start_ibex(1'd1),
        .eFPGA_operand_a_o(eFPGA_operand_a_o),
        .eFPGA_operand_b_o(eFPGA_operand_b_o),
        .eFPGA_result_a_i(32'd0),
        .eFPGA_result_b_i(32'd0),
        .eFPGA_result_c_i(32'd0),
        .uart_recv_error(la_data_out[6]),
        .eFPGA_write_strobe_o(la_data_out[7]),
        .eFPGA_fpga_done_i(1'd1),
        .eFPGA_en_o(la_data_out[8]),
        .eFPGA_operator_o(eFPGA_operator_o),
        .eFPGA_delay_o(eFPGA_delay_o) 
);      


endmodule


`default_nettype wire
