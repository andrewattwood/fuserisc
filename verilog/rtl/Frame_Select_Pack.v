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
module Frame_Select_0 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 0;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_1 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 1;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_2 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 2;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_3 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 3;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_4 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 4;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_5 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 5;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_6 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 6;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

module Frame_Select_7 (FrameStrobe_I, FrameStrobe_O, FrameSelect, FrameStrobe);
	parameter MaxFramesPerCol = 20;
	parameter FrameSelectWidth = 5;
	parameter Col = 7;
	input [MaxFramesPerCol-1:0] FrameStrobe_I;
	output reg [MaxFramesPerCol-1:0] FrameStrobe_O;
	input [FrameSelectWidth-1:0] FrameSelect;
	input FrameStrobe;

//FrameStrobe_O = 0;
	always @ (*) begin
		if (FrameStrobe && (FrameSelect==Col)) 
			FrameStrobe_O =  FrameStrobe_I;
		else
			FrameStrobe_O = 'd0;
	end
endmodule

