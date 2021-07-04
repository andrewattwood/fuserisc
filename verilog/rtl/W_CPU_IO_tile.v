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


module W_CPU_IO (E1BEG, E2BEG, E2BEGb, EE4BEG, E6BEG, W1END, W2MID, W2END, WW4END, W6END, OPA_I0, OPA_I1, OPA_I2, OPA_I3, UserCLK, OPB_I0, OPB_I1, OPB_I2, OPB_I3, RES0_O0, RES0_O1, RES0_O2, RES0_O3, RES1_O0, RES1_O1, RES1_O2, RES1_O3, RES2_O0, RES2_O1, RES2_O2, RES2_O3, FrameData, FrameData_O, FrameStrobe, FrameStrobe_O);
	parameter MaxFramesPerCol = 20;
	parameter FrameBitsPerRow = 32;
	parameter NoConfigBits = 20;
	//  NORTH
	//  EAST
	output [3:0] E1BEG; //wires:4 X_offset:1 Y_offset:0  source_name:E1BEG destination_name:NULL  
	output [7:0] E2BEG; //wires:8 X_offset:1 Y_offset:0  source_name:E2BEG destination_name:NULL  
	output [7:0] E2BEGb; //wires:8 X_offset:1 Y_offset:0  source_name:E2BEGb destination_name:NULL  
	output [15:0] EE4BEG; //wires:4 X_offset:4 Y_offset:0  source_name:EE4BEG destination_name:NULL  
	output [11:0] E6BEG; //wires:2 X_offset:6 Y_offset:0  source_name:E6BEG destination_name:NULL  
	//  SOUTH
	//  WEST
	input [3:0] W1END; //wires:4 X_offset:-1 Y_offset:0  source_name:NULL destination_name:W1END  
	input [7:0] W2MID; //wires:8 X_offset:-1 Y_offset:0  source_name:NULL destination_name:W2MID  
	input [7:0] W2END; //wires:8 X_offset:-1 Y_offset:0  source_name:NULL destination_name:W2END  
	input [15:0] WW4END; //wires:4 X_offset:-4 Y_offset:0  source_name:NULL destination_name:WW4END  
	input [11:0] W6END; //wires:2 X_offset:-6 Y_offset:0  source_name:NULL destination_name:W6END  
	// Tile IO ports from BELs
	input OPA_I0;
	input OPA_I1;
	input OPA_I2;
	input OPA_I3;
	input UserCLK;
	input OPB_I0;
	input OPB_I1;
	input OPB_I2;
	input OPB_I3;
	output RES0_O0;
	output RES0_O1;
	output RES0_O2;
	output RES0_O3;
	output RES1_O0;
	output RES1_O1;
	output RES1_O2;
	output RES1_O3;
	output RES2_O0;
	output RES2_O1;
	output RES2_O2;
	output RES2_O3;
	input [FrameBitsPerRow-1:0] FrameData; //CONFIG_PORT this is a keyword needed to connect the tile to the bitstream frame register
	output [FrameBitsPerRow-1:0] FrameData_O;
	input [MaxFramesPerCol-1:0] FrameStrobe; //CONFIG_PORT this is a keyword needed to connect the tile to the bitstream frame register
	output [MaxFramesPerCol-1:0] FrameStrobe_O;
	//global


//signal declarations
//BEL ports (e.g., slices)
	wire RES0_I0;
	wire RES0_I1;
	wire RES0_I2;
	wire RES0_I3;
	wire RES1_I0;
	wire RES1_I1;
	wire RES1_I2;
	wire RES1_I3;
	wire RES2_I0;
	wire RES2_I1;
	wire RES2_I2;
	wire RES2_I3;
	wire OPA_O0;
	wire OPA_O1;
	wire OPA_O2;
	wire OPA_O3;
	wire OPB_O0;
	wire OPB_O1;
	wire OPB_O2;
	wire OPB_O3;
//jump wires
//internal configuration data signal to daisy-chain all BELs (if any and in the order they are listed in the fabric.csv)
	wire [NoConfigBits-1:0] ConfigBits;
	wire [NoConfigBits-1:0] ConfigBits_N;

// Cascading of routing for wires spanning more than one tile
	wire [FrameBitsPerRow-1:0] FrameData_i;
	wire [FrameBitsPerRow-1:0] FrameData_O_i;
	assign FrameData_O_i = FrameData_i;

	my_buf data_inbuf_0 (
	.A(FrameData[0]),
	.X(FrameData_i[0])
	);

	my_buf data_inbuf_1 (
	.A(FrameData[1]),
	.X(FrameData_i[1])
	);

	my_buf data_inbuf_2 (
	.A(FrameData[2]),
	.X(FrameData_i[2])
	);

	my_buf data_inbuf_3 (
	.A(FrameData[3]),
	.X(FrameData_i[3])
	);

	my_buf data_inbuf_4 (
	.A(FrameData[4]),
	.X(FrameData_i[4])
	);

	my_buf data_inbuf_5 (
	.A(FrameData[5]),
	.X(FrameData_i[5])
	);

	my_buf data_inbuf_6 (
	.A(FrameData[6]),
	.X(FrameData_i[6])
	);

	my_buf data_inbuf_7 (
	.A(FrameData[7]),
	.X(FrameData_i[7])
	);

	my_buf data_inbuf_8 (
	.A(FrameData[8]),
	.X(FrameData_i[8])
	);

	my_buf data_inbuf_9 (
	.A(FrameData[9]),
	.X(FrameData_i[9])
	);

	my_buf data_inbuf_10 (
	.A(FrameData[10]),
	.X(FrameData_i[10])
	);

	my_buf data_inbuf_11 (
	.A(FrameData[11]),
	.X(FrameData_i[11])
	);

	my_buf data_inbuf_12 (
	.A(FrameData[12]),
	.X(FrameData_i[12])
	);

	my_buf data_inbuf_13 (
	.A(FrameData[13]),
	.X(FrameData_i[13])
	);

	my_buf data_inbuf_14 (
	.A(FrameData[14]),
	.X(FrameData_i[14])
	);

	my_buf data_inbuf_15 (
	.A(FrameData[15]),
	.X(FrameData_i[15])
	);

	my_buf data_inbuf_16 (
	.A(FrameData[16]),
	.X(FrameData_i[16])
	);

	my_buf data_inbuf_17 (
	.A(FrameData[17]),
	.X(FrameData_i[17])
	);

	my_buf data_inbuf_18 (
	.A(FrameData[18]),
	.X(FrameData_i[18])
	);

	my_buf data_inbuf_19 (
	.A(FrameData[19]),
	.X(FrameData_i[19])
	);

	my_buf data_inbuf_20 (
	.A(FrameData[20]),
	.X(FrameData_i[20])
	);

	my_buf data_inbuf_21 (
	.A(FrameData[21]),
	.X(FrameData_i[21])
	);

	my_buf data_inbuf_22 (
	.A(FrameData[22]),
	.X(FrameData_i[22])
	);

	my_buf data_inbuf_23 (
	.A(FrameData[23]),
	.X(FrameData_i[23])
	);

	my_buf data_inbuf_24 (
	.A(FrameData[24]),
	.X(FrameData_i[24])
	);

	my_buf data_inbuf_25 (
	.A(FrameData[25]),
	.X(FrameData_i[25])
	);

	my_buf data_inbuf_26 (
	.A(FrameData[26]),
	.X(FrameData_i[26])
	);

	my_buf data_inbuf_27 (
	.A(FrameData[27]),
	.X(FrameData_i[27])
	);

	my_buf data_inbuf_28 (
	.A(FrameData[28]),
	.X(FrameData_i[28])
	);

	my_buf data_inbuf_29 (
	.A(FrameData[29]),
	.X(FrameData_i[29])
	);

	my_buf data_inbuf_30 (
	.A(FrameData[30]),
	.X(FrameData_i[30])
	);

	my_buf data_inbuf_31 (
	.A(FrameData[31]),
	.X(FrameData_i[31])
	);

	my_buf data_outbuf_0 (
	.A(FrameData_O_i[0]),
	.X(FrameData_O[0])
	);

	my_buf data_outbuf_1 (
	.A(FrameData_O_i[1]),
	.X(FrameData_O[1])
	);

	my_buf data_outbuf_2 (
	.A(FrameData_O_i[2]),
	.X(FrameData_O[2])
	);

	my_buf data_outbuf_3 (
	.A(FrameData_O_i[3]),
	.X(FrameData_O[3])
	);

	my_buf data_outbuf_4 (
	.A(FrameData_O_i[4]),
	.X(FrameData_O[4])
	);

	my_buf data_outbuf_5 (
	.A(FrameData_O_i[5]),
	.X(FrameData_O[5])
	);

	my_buf data_outbuf_6 (
	.A(FrameData_O_i[6]),
	.X(FrameData_O[6])
	);

	my_buf data_outbuf_7 (
	.A(FrameData_O_i[7]),
	.X(FrameData_O[7])
	);

	my_buf data_outbuf_8 (
	.A(FrameData_O_i[8]),
	.X(FrameData_O[8])
	);

	my_buf data_outbuf_9 (
	.A(FrameData_O_i[9]),
	.X(FrameData_O[9])
	);

	my_buf data_outbuf_10 (
	.A(FrameData_O_i[10]),
	.X(FrameData_O[10])
	);

	my_buf data_outbuf_11 (
	.A(FrameData_O_i[11]),
	.X(FrameData_O[11])
	);

	my_buf data_outbuf_12 (
	.A(FrameData_O_i[12]),
	.X(FrameData_O[12])
	);

	my_buf data_outbuf_13 (
	.A(FrameData_O_i[13]),
	.X(FrameData_O[13])
	);

	my_buf data_outbuf_14 (
	.A(FrameData_O_i[14]),
	.X(FrameData_O[14])
	);

	my_buf data_outbuf_15 (
	.A(FrameData_O_i[15]),
	.X(FrameData_O[15])
	);

	my_buf data_outbuf_16 (
	.A(FrameData_O_i[16]),
	.X(FrameData_O[16])
	);

	my_buf data_outbuf_17 (
	.A(FrameData_O_i[17]),
	.X(FrameData_O[17])
	);

	my_buf data_outbuf_18 (
	.A(FrameData_O_i[18]),
	.X(FrameData_O[18])
	);

	my_buf data_outbuf_19 (
	.A(FrameData_O_i[19]),
	.X(FrameData_O[19])
	);

	my_buf data_outbuf_20 (
	.A(FrameData_O_i[20]),
	.X(FrameData_O[20])
	);

	my_buf data_outbuf_21 (
	.A(FrameData_O_i[21]),
	.X(FrameData_O[21])
	);

	my_buf data_outbuf_22 (
	.A(FrameData_O_i[22]),
	.X(FrameData_O[22])
	);

	my_buf data_outbuf_23 (
	.A(FrameData_O_i[23]),
	.X(FrameData_O[23])
	);

	my_buf data_outbuf_24 (
	.A(FrameData_O_i[24]),
	.X(FrameData_O[24])
	);

	my_buf data_outbuf_25 (
	.A(FrameData_O_i[25]),
	.X(FrameData_O[25])
	);

	my_buf data_outbuf_26 (
	.A(FrameData_O_i[26]),
	.X(FrameData_O[26])
	);

	my_buf data_outbuf_27 (
	.A(FrameData_O_i[27]),
	.X(FrameData_O[27])
	);

	my_buf data_outbuf_28 (
	.A(FrameData_O_i[28]),
	.X(FrameData_O[28])
	);

	my_buf data_outbuf_29 (
	.A(FrameData_O_i[29]),
	.X(FrameData_O[29])
	);

	my_buf data_outbuf_30 (
	.A(FrameData_O_i[30]),
	.X(FrameData_O[30])
	);

	my_buf data_outbuf_31 (
	.A(FrameData_O_i[31]),
	.X(FrameData_O[31])
	);

	wire [MaxFramesPerCol-1:0] FrameStrobe_i;
	wire [MaxFramesPerCol-1:0] FrameStrobe_O_i;
	assign FrameStrobe_O_i = FrameStrobe_i;

	my_buf strobe_inbuf_0 (
	.A(FrameStrobe[0]),
	.X(FrameStrobe_i[0])
	)
;
	my_buf strobe_inbuf_1 (
	.A(FrameStrobe[1]),
	.X(FrameStrobe_i[1])
	)
;
	my_buf strobe_inbuf_2 (
	.A(FrameStrobe[2]),
	.X(FrameStrobe_i[2])
	)
;
	my_buf strobe_inbuf_3 (
	.A(FrameStrobe[3]),
	.X(FrameStrobe_i[3])
	)
;
	my_buf strobe_inbuf_4 (
	.A(FrameStrobe[4]),
	.X(FrameStrobe_i[4])
	)
;
	my_buf strobe_inbuf_5 (
	.A(FrameStrobe[5]),
	.X(FrameStrobe_i[5])
	)
;
	my_buf strobe_inbuf_6 (
	.A(FrameStrobe[6]),
	.X(FrameStrobe_i[6])
	)
;
	my_buf strobe_inbuf_7 (
	.A(FrameStrobe[7]),
	.X(FrameStrobe_i[7])
	)
;
	my_buf strobe_inbuf_8 (
	.A(FrameStrobe[8]),
	.X(FrameStrobe_i[8])
	)
;
	my_buf strobe_inbuf_9 (
	.A(FrameStrobe[9]),
	.X(FrameStrobe_i[9])
	)
;
	my_buf strobe_inbuf_10 (
	.A(FrameStrobe[10]),
	.X(FrameStrobe_i[10])
	)
;
	my_buf strobe_inbuf_11 (
	.A(FrameStrobe[11]),
	.X(FrameStrobe_i[11])
	)
;
	my_buf strobe_inbuf_12 (
	.A(FrameStrobe[12]),
	.X(FrameStrobe_i[12])
	)
;
	my_buf strobe_inbuf_13 (
	.A(FrameStrobe[13]),
	.X(FrameStrobe_i[13])
	)
;
	my_buf strobe_inbuf_14 (
	.A(FrameStrobe[14]),
	.X(FrameStrobe_i[14])
	)
;
	my_buf strobe_inbuf_15 (
	.A(FrameStrobe[15]),
	.X(FrameStrobe_i[15])
	)
;
	my_buf strobe_inbuf_16 (
	.A(FrameStrobe[16]),
	.X(FrameStrobe_i[16])
	)
;
	my_buf strobe_inbuf_17 (
	.A(FrameStrobe[17]),
	.X(FrameStrobe_i[17])
	)
;
	my_buf strobe_inbuf_18 (
	.A(FrameStrobe[18]),
	.X(FrameStrobe_i[18])
	)
;
	my_buf strobe_inbuf_19 (
	.A(FrameStrobe[19]),
	.X(FrameStrobe_i[19])
	)
;
	my_buf strobe_outbuf_0 (
	.A(FrameStrobe_O_i[0]),
	.X(FrameStrobe_O[0])
	)
;
	my_buf strobe_outbuf_1 (
	.A(FrameStrobe_O_i[1]),
	.X(FrameStrobe_O[1])
	)
;
	my_buf strobe_outbuf_2 (
	.A(FrameStrobe_O_i[2]),
	.X(FrameStrobe_O[2])
	)
;
	my_buf strobe_outbuf_3 (
	.A(FrameStrobe_O_i[3]),
	.X(FrameStrobe_O[3])
	)
;
	my_buf strobe_outbuf_4 (
	.A(FrameStrobe_O_i[4]),
	.X(FrameStrobe_O[4])
	)
;
	my_buf strobe_outbuf_5 (
	.A(FrameStrobe_O_i[5]),
	.X(FrameStrobe_O[5])
	)
;
	my_buf strobe_outbuf_6 (
	.A(FrameStrobe_O_i[6]),
	.X(FrameStrobe_O[6])
	)
;
	my_buf strobe_outbuf_7 (
	.A(FrameStrobe_O_i[7]),
	.X(FrameStrobe_O[7])
	)
;
	my_buf strobe_outbuf_8 (
	.A(FrameStrobe_O_i[8]),
	.X(FrameStrobe_O[8])
	)
;
	my_buf strobe_outbuf_9 (
	.A(FrameStrobe_O_i[9]),
	.X(FrameStrobe_O[9])
	)
;
	my_buf strobe_outbuf_10 (
	.A(FrameStrobe_O_i[10]),
	.X(FrameStrobe_O[10])
	)
;
	my_buf strobe_outbuf_11 (
	.A(FrameStrobe_O_i[11]),
	.X(FrameStrobe_O[11])
	)
;
	my_buf strobe_outbuf_12 (
	.A(FrameStrobe_O_i[12]),
	.X(FrameStrobe_O[12])
	)
;
	my_buf strobe_outbuf_13 (
	.A(FrameStrobe_O_i[13]),
	.X(FrameStrobe_O[13])
	)
;
	my_buf strobe_outbuf_14 (
	.A(FrameStrobe_O_i[14]),
	.X(FrameStrobe_O[14])
	)
;
	my_buf strobe_outbuf_15 (
	.A(FrameStrobe_O_i[15]),
	.X(FrameStrobe_O[15])
	)
;
	my_buf strobe_outbuf_16 (
	.A(FrameStrobe_O_i[16]),
	.X(FrameStrobe_O[16])
	)
;
	my_buf strobe_outbuf_17 (
	.A(FrameStrobe_O_i[17]),
	.X(FrameStrobe_O[17])
	)
;
	my_buf strobe_outbuf_18 (
	.A(FrameStrobe_O_i[18]),
	.X(FrameStrobe_O[18])
	)
;
	my_buf strobe_outbuf_19 (
	.A(FrameStrobe_O_i[19]),
	.X(FrameStrobe_O[19])
	)
;

// configuration storage latches
	W_CPU_IO_ConfigMem Inst_W_CPU_IO_ConfigMem (
	.FrameData(FrameData),
	.FrameStrobe(FrameStrobe),
	.ConfigBits(ConfigBits),
	.ConfigBits_N(ConfigBits_N)
	);

//BEL component instantiations
	InPass4_frame_config Inst_OPA_InPass4_frame_config (
	.O0(OPA_O0),
	.O1(OPA_O1),
	.O2(OPA_O2),
	.O3(OPA_O3),
	//I/O primitive pins go to tile top level module (not further parsed)  
	.I0(OPA_I0),
	.I1(OPA_I1),
	.I2(OPA_I2),
	.I3(OPA_I3),
	.UserCLK(UserCLK),
	.ConfigBits(ConfigBits[4-1:0])
	);

	InPass4_frame_config Inst_OPB_InPass4_frame_config (
	.O0(OPB_O0),
	.O1(OPB_O1),
	.O2(OPB_O2),
	.O3(OPB_O3),
	//I/O primitive pins go to tile top level module (not further parsed)  
	.I0(OPB_I0),
	.I1(OPB_I1),
	.I2(OPB_I2),
	.I3(OPB_I3),
	.UserCLK(UserCLK),
	.ConfigBits(ConfigBits[8-1:4])
	);

	OutPass4_frame_config Inst_RES0_OutPass4_frame_config (
	.I0(RES0_I0),
	.I1(RES0_I1),
	.I2(RES0_I2),
	.I3(RES0_I3),
	//I/O primitive pins go to tile top level module (not further parsed)  
	.O0(RES0_O0),
	.O1(RES0_O1),
	.O2(RES0_O2),
	.O3(RES0_O3),
	.UserCLK(UserCLK),
	.ConfigBits(ConfigBits[12-1:8])
	);

	OutPass4_frame_config Inst_RES1_OutPass4_frame_config (
	.I0(RES1_I0),
	.I1(RES1_I1),
	.I2(RES1_I2),
	.I3(RES1_I3),
	//I/O primitive pins go to tile top level module (not further parsed)  
	.O0(RES1_O0),
	.O1(RES1_O1),
	.O2(RES1_O2),
	.O3(RES1_O3),
	.UserCLK(UserCLK),
	.ConfigBits(ConfigBits[16-1:12])
	);

	OutPass4_frame_config Inst_RES2_OutPass4_frame_config (
	.I0(RES2_I0),
	.I1(RES2_I1),
	.I2(RES2_I2),
	.I3(RES2_I3),
	//I/O primitive pins go to tile top level module (not further parsed)  
	.O0(RES2_O0),
	.O1(RES2_O1),
	.O2(RES2_O2),
	.O3(RES2_O3),
	.UserCLK(UserCLK),
	.ConfigBits(ConfigBits[20-1:16])
	);


//switch matrix component instantiation
	W_CPU_IO_switch_matrix Inst_W_CPU_IO_switch_matrix (
	.W1END0(W1END[0]),
	.W1END1(W1END[1]),
	.W1END2(W1END[2]),
	.W1END3(W1END[3]),
	.W2MID0(W2MID[0]),
	.W2MID1(W2MID[1]),
	.W2MID2(W2MID[2]),
	.W2MID3(W2MID[3]),
	.W2MID4(W2MID[4]),
	.W2MID5(W2MID[5]),
	.W2MID6(W2MID[6]),
	.W2MID7(W2MID[7]),
	.W2END0(W2END[0]),
	.W2END1(W2END[1]),
	.W2END2(W2END[2]),
	.W2END3(W2END[3]),
	.W2END4(W2END[4]),
	.W2END5(W2END[5]),
	.W2END6(W2END[6]),
	.W2END7(W2END[7]),
	.WW4END0(WW4END[0]),
	.WW4END1(WW4END[1]),
	.WW4END2(WW4END[2]),
	.WW4END3(WW4END[3]),
	.WW4END4(WW4END[4]),
	.WW4END5(WW4END[5]),
	.WW4END6(WW4END[6]),
	.WW4END7(WW4END[7]),
	.WW4END8(WW4END[8]),
	.WW4END9(WW4END[9]),
	.WW4END10(WW4END[10]),
	.WW4END11(WW4END[11]),
	.WW4END12(WW4END[12]),
	.WW4END13(WW4END[13]),
	.WW4END14(WW4END[14]),
	.WW4END15(WW4END[15]),
	.W6END0(W6END[0]),
	.W6END1(W6END[1]),
	.W6END2(W6END[2]),
	.W6END3(W6END[3]),
	.W6END4(W6END[4]),
	.W6END5(W6END[5]),
	.W6END6(W6END[6]),
	.W6END7(W6END[7]),
	.W6END8(W6END[8]),
	.W6END9(W6END[9]),
	.W6END10(W6END[10]),
	.W6END11(W6END[11]),
	.OPA_O0(OPA_O0),
	.OPA_O1(OPA_O1),
	.OPA_O2(OPA_O2),
	.OPA_O3(OPA_O3),
	.OPB_O0(OPB_O0),
	.OPB_O1(OPB_O1),
	.OPB_O2(OPB_O2),
	.OPB_O3(OPB_O3),
	.E1BEG0(E1BEG[0]),
	.E1BEG1(E1BEG[1]),
	.E1BEG2(E1BEG[2]),
	.E1BEG3(E1BEG[3]),
	.E2BEG0(E2BEG[0]),
	.E2BEG1(E2BEG[1]),
	.E2BEG2(E2BEG[2]),
	.E2BEG3(E2BEG[3]),
	.E2BEG4(E2BEG[4]),
	.E2BEG5(E2BEG[5]),
	.E2BEG6(E2BEG[6]),
	.E2BEG7(E2BEG[7]),
	.E2BEGb0(E2BEGb[0]),
	.E2BEGb1(E2BEGb[1]),
	.E2BEGb2(E2BEGb[2]),
	.E2BEGb3(E2BEGb[3]),
	.E2BEGb4(E2BEGb[4]),
	.E2BEGb5(E2BEGb[5]),
	.E2BEGb6(E2BEGb[6]),
	.E2BEGb7(E2BEGb[7]),
	.EE4BEG0(EE4BEG[0]),
	.EE4BEG1(EE4BEG[1]),
	.EE4BEG2(EE4BEG[2]),
	.EE4BEG3(EE4BEG[3]),
	.EE4BEG4(EE4BEG[4]),
	.EE4BEG5(EE4BEG[5]),
	.EE4BEG6(EE4BEG[6]),
	.EE4BEG7(EE4BEG[7]),
	.EE4BEG8(EE4BEG[8]),
	.EE4BEG9(EE4BEG[9]),
	.EE4BEG10(EE4BEG[10]),
	.EE4BEG11(EE4BEG[11]),
	.EE4BEG12(EE4BEG[12]),
	.EE4BEG13(EE4BEG[13]),
	.EE4BEG14(EE4BEG[14]),
	.EE4BEG15(EE4BEG[15]),
	.E6BEG0(E6BEG[0]),
	.E6BEG1(E6BEG[1]),
	.E6BEG2(E6BEG[2]),
	.E6BEG3(E6BEG[3]),
	.E6BEG4(E6BEG[4]),
	.E6BEG5(E6BEG[5]),
	.E6BEG6(E6BEG[6]),
	.E6BEG7(E6BEG[7]),
	.E6BEG8(E6BEG[8]),
	.E6BEG9(E6BEG[9]),
	.E6BEG10(E6BEG[10]),
	.E6BEG11(E6BEG[11]),
	.RES0_I0(RES0_I0),
	.RES0_I1(RES0_I1),
	.RES0_I2(RES0_I2),
	.RES0_I3(RES0_I3),
	.RES1_I0(RES1_I0),
	.RES1_I1(RES1_I1),
	.RES1_I2(RES1_I2),
	.RES1_I3(RES1_I3),
	.RES2_I0(RES2_I0),
	.RES2_I1(RES2_I1),
	.RES2_I2(RES2_I2),
	.RES2_I3(RES2_I3)
	);

endmodule
