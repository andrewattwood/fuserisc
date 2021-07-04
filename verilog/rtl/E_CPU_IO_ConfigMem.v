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
module E_CPU_IO_ConfigMem (FrameData, FrameStrobe, ConfigBits, ConfigBits_N);
	parameter MaxFramesPerCol = 20;
	parameter FrameBitsPerRow = 32;
	parameter NoConfigBits = 20;
	input [FrameBitsPerRow-1:0] FrameData;
	input [MaxFramesPerCol-1:0] FrameStrobe;
	output [NoConfigBits-1:0] ConfigBits;
	output [NoConfigBits-1:0] ConfigBits_N;
	wire [20-1:0] frame0;

//instantiate frame latches
	LHQD1 Inst_frame0_bit31(
	.D(FrameData[31]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[19]),
	.QN(ConfigBits_N[19])
	);

	LHQD1 Inst_frame0_bit30(
	.D(FrameData[30]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[18]),
	.QN(ConfigBits_N[18])
	);

	LHQD1 Inst_frame0_bit29(
	.D(FrameData[29]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[17]),
	.QN(ConfigBits_N[17])
	);

	LHQD1 Inst_frame0_bit28(
	.D(FrameData[28]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[16]),
	.QN(ConfigBits_N[16])
	);

	LHQD1 Inst_frame0_bit27(
	.D(FrameData[27]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[15]),
	.QN(ConfigBits_N[15])
	);

	LHQD1 Inst_frame0_bit26(
	.D(FrameData[26]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[14]),
	.QN(ConfigBits_N[14])
	);

	LHQD1 Inst_frame0_bit25(
	.D(FrameData[25]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[13]),
	.QN(ConfigBits_N[13])
	);

	LHQD1 Inst_frame0_bit24(
	.D(FrameData[24]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[12]),
	.QN(ConfigBits_N[12])
	);

	LHQD1 Inst_frame0_bit23(
	.D(FrameData[23]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[11]),
	.QN(ConfigBits_N[11])
	);

	LHQD1 Inst_frame0_bit22(
	.D(FrameData[22]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[10]),
	.QN(ConfigBits_N[10])
	);

	LHQD1 Inst_frame0_bit21(
	.D(FrameData[21]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[9]),
	.QN(ConfigBits_N[9])
	);

	LHQD1 Inst_frame0_bit20(
	.D(FrameData[20]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[8]),
	.QN(ConfigBits_N[8])
	);

	LHQD1 Inst_frame0_bit19(
	.D(FrameData[19]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[7]),
	.QN(ConfigBits_N[7])
	);

	LHQD1 Inst_frame0_bit18(
	.D(FrameData[18]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[6]),
	.QN(ConfigBits_N[6])
	);

	LHQD1 Inst_frame0_bit17(
	.D(FrameData[17]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[5]),
	.QN(ConfigBits_N[5])
	);

	LHQD1 Inst_frame0_bit16(
	.D(FrameData[16]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[4]),
	.QN(ConfigBits_N[4])
	);

	LHQD1 Inst_frame0_bit15(
	.D(FrameData[15]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[3]),
	.QN(ConfigBits_N[3])
	);

	LHQD1 Inst_frame0_bit14(
	.D(FrameData[14]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[2]),
	.QN(ConfigBits_N[2])
	);

	LHQD1 Inst_frame0_bit13(
	.D(FrameData[13]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[1]),
	.QN(ConfigBits_N[1])
	);

	LHQD1 Inst_frame0_bit12(
	.D(FrameData[12]),
	.E(FrameStrobe[0]),
	.Q(ConfigBits[0]),
	.QN(ConfigBits_N[0])
	);

endmodule
