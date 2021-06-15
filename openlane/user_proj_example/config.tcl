# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]




set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
        $script_dir/../../verilog/rtl/user_proj_example.v \
        $script_dir/../../verilog/rtl/design_2_top.v \ "
#        $script_dir/../../verilog/rtl/ibex_defines.sv "

#$script_dir/../../verilog/rtl/user_proj_example.v \
# $script_dir/../../verilog/rtl/mem_wb.v \
# $script_dir/../../verilog/rtl/DFFRAM.v \
#$script_dir/../../verilog/rtl/DFFRAMBB.v"
# /disk2/openlane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/*"
#        $script_dir/../../caravel/verilog/rtl/defines.v \
#        $script_dir/../../verilog/rtl/user_proj_example.v \
#        $script_dir/../../verilog/rtl/design_2_top.v \
#        $script_dir/../../verilog/rtl/ibex_defines.sv "


#set ::env(VERILOG_FILES_BLACKBOX) "\
  $script_dir/../../verilog/rtl/DFFRAM.v"

#set ::env(EXTRA_LEFS) "\
#  $script_dir/../../lef/DFFRAM.lef"

#set ::env(EXTRA_GDS_FILES) "\
#  $script_dir/../../gds/DFFRAM.gds"

set ::env(CLOCK_PORT) "clk_i"
set ::env(CLOCK_PERIOD) "20"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1400 1400"
set ::env(DESIGN_IS_CORE) 0

set ::env(VDD_NETS) [list {vccd1} {vccd2} {vdda1} {vdda2}]
set ::env(GND_NETS) [list {vssd1} {vssd2} {vssa1} {vssa2}]

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.52
set ::env(PL_TARGET_DENSITY_CELLS) 0.38

# If you're going to use multiple power domains, then keep this disabled.
set ::env(RUN_CVC) 0
#set ::env(CLOCK_PORT) "clk_i"
#set ::env(CLOCK_NET) "mprj.wb_clk_in"
#set ::env(CLOCK_PERIOD) "50"

#set ::env(SYNTH_TOP_LEVEL) 1

#set ::env(CLOCK_TREE_SYNTH) 0

#set ::env(PDN_CFG) $script_dir/pdn.tcl

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
## set ::env(FP_CORE_UTIL) 40
#set ::env(FP_SIZING) absolute
#set ::env(DIE_AREA) "0 0 450 950"
#
#set ::env(FP_HORIZONTAL_HALO) 5
#set ::env(FP_VERTICAL_HALO) 14
#set ::env(FP_PDN_VOFFSET) 5
#set ::env(FP_PDN_VPITCH) 20
#set ::env(FP_PDN_HPITCH) 50

#
#set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
#set ::env(PL_TARGET_DENSITY) 0.99
#set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
#set ::env(PL_RANDOM_GLB_PLACEMENT) 1
#set ::env(PL_BASIC_PLACEMENT) 1
#
#set ::env(GLB_RT_ADJUSTMENT) 0
#set ::env(GLB_RT_TILES) 14
#set ::env(GLB_RT_ALLOW_CONGESTION) 1

#set ::env(DIODE_INSERTION_STRATEGY) 1

# magic drc checking on the sram block shows millions of false errors
#set ::env(MAGIC_DRC_USE_GDS) 0
#set ::env(SYNTH_READ_BLACKBOX_LIB) 1
#set ::env(LIB_SYNTH) [glob /disk2/openlane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_100C_1v80.lib]
