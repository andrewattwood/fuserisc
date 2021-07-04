// SPDX-FileCopyrightText: 2020 Andrew Attwood
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


module wb_to_core_sram
  (


   //input from the wishbone
    input [10:0]wb_data_addr_i,
    input [3:0]wb_data_be_i,
    output logic [31:0]wb_data_rdata_o,
    input wbs_stb_i,
    input wbs_cyc_i,
    output logic wb_data_rvalid_o,
    input [31:0]wb_data_wdata_i,
    input  wb_data_we_i,

 //output to core mem a

    output logic [9:0]core_a_data_addr_o,
    output logic [3:0]core_a_data_be_o,
    input [31:0]core_a_data_rdata_i,
    output logic core_a_data_req_o,
    input core_a_data_rvalid_i,
    output logic [31:0]core_a_data_wdata_o,
    output logic core_a_data_we_o,

 //output to core mem b

    output logic [9:0]core_b_data_addr_o,
    output logic [3:0]core_b_data_be_o,
    input [31:0]core_b_data_rdata_i,
    output logic core_b_data_req_o,
    input core_b_data_rvalid_i,
    output logic [31:0]core_b_data_wdata_o,
    output logic core_b_data_we_o


  );

wire wb_data_req_i;

assign wb_data_req_i = (wbs_stb_i & wbs_cyc_i) ? 1 :0;




    always @*
   begin
        if(wb_data_addr_i[10] == 1'b1)
        begin
                core_b_data_addr_o = wb_data_addr_i[9:0];
                core_b_data_be_o = wb_data_be_i;
                wb_data_rdata_o = core_b_data_rdata_i;
                core_b_data_req_o = wb_data_req_i;
                wb_data_rvalid_o = core_b_data_rvalid_i;
                core_b_data_wdata_o = wb_data_wdata_i;
                core_b_data_we_o = wb_data_we_i;
                core_a_data_addr_o = 10'd0;
                core_a_data_be_o = 4'd0;
                core_a_data_req_o = 1'b0;
                core_a_data_wdata_o = 32'd0;
                core_a_data_we_o = 1'b0;
        end else
        begin
                core_a_data_addr_o = wb_data_addr_i[9:0];
                core_a_data_be_o = wb_data_be_i;
                wb_data_rdata_o = core_a_data_rdata_i;
                core_a_data_req_o = wb_data_req_i;
                wb_data_rvalid_o = core_a_data_rvalid_i;
                core_a_data_wdata_o = wb_data_wdata_i;
                core_a_data_we_o = wb_data_we_i;

                core_b_data_addr_o = 10'd0;
                core_b_data_be_o = 4'd0;
                core_b_data_req_o = 1'b0;
                core_b_data_wdata_o = 32'd0;
                core_b_data_we_o = 1'b0;

        end
   end


endmodule
