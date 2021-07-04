// SPDX-FileCopyrightText: 2020 Nguyen Dao
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



module wb_mem_split (

   input [10:0]wb_data_addr_i,
    input [3:0]wb_data_be_i,
    output [31:0]wb_data_rdata_o,
    input wbs_stb_i,
    input wbs_cyc_i,
    output wb_data_rvalid_o,
    input [31:0]wb_data_wdata_i,
    input  wb_data_we_i,

 //output to core mem a

    output  [9:0]core_a_data_addr_o,
    output  [3:0]core_a_data_be_o,
    input [31:0]core_a_data_rdata_i,
    output  core_a_data_req_o,
    input core_a_data_rvalid_i,
    output  [31:0]core_a_data_wdata_o,
    output  core_a_data_we_o,

 //output to core mem b

    output  [9:0]core_b_data_addr_o,
    output  [3:0]core_b_data_be_o,
    input [31:0]core_b_data_rdata_i,
    output  core_b_data_req_o,
    input core_b_data_rvalid_i,
    output [31:0]core_b_data_wdata_o,
    output core_b_data_we_o
);


wb_to_core_sram wb_to_core_sram_i
  (
    .wb_data_addr_i(wb_data_addr_i),
    .wb_data_be_i(wb_data_be_i),
    .wb_data_rdata_o(wb_data_rdata_o),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wb_data_rvalid_o(wb_data_rvalid_o),
    .wb_data_wdata_i(wb_data_wdata_i),
    .wb_data_we_i(wb_data_we_i),


    .core_a_data_addr_o(core_a_data_addr_o),
    .core_a_data_be_o(core_a_data_be_o),
    .core_a_data_rdata_i(core_a_data_rdata_i),
    .core_a_data_req_o(core_a_data_req_o),
    .core_a_data_rvalid_i(core_a_data_rvalid_i),
    .core_a_data_wdata_o(core_a_data_wdata_o),
    .core_a_data_we_o(core_a_data_we_o),

    .core_b_data_addr_o(core_b_data_addr_o),
    .core_b_data_be_o(core_b_data_be_o),
    .core_b_data_rdata_i(core_b_data_rdata_i),
    .core_b_data_req_o(core_b_data_req_o),
    .core_b_data_rvalid_i(core_b_data_rvalid_i),
    .core_b_data_wdata_o(core_b_data_wdata_o),
    .core_b_data_we_o(core_b_data_we_o)


  );


  endmodule
