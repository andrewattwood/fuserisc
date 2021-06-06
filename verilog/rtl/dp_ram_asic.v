module dp_ram_asic (
	clk,
	en_a_i,
	o_be_a_i,
	addr_a_i,
	wdata_a_i,
	rdata_a_o,
	we_a_i,
	en_b_i,
	o_be_b_i,
	addr_b_i,
	wdata_b_i,
	rdata_b_o,
	we_b_i
);
	parameter NUM_COL = 4;
	parameter COL_WIDTH = 8;
	parameter ADDR_WIDTH = 10;
	parameter DATA_WIDTH = NUM_COL * COL_WIDTH;
	input clk;
	input en_a_i;
	input [NUM_COL - 1:0] o_be_a_i;
	input [ADDR_WIDTH - 1:0] addr_a_i;
	input [DATA_WIDTH - 1:0] wdata_a_i;
	output [DATA_WIDTH - 1:0] rdata_a_o;
	input wire we_a_i;
	input en_b_i;
	input [NUM_COL - 1:0] o_be_b_i;
	input [ADDR_WIDTH - 1:0] addr_b_i;
	input [DATA_WIDTH - 1:0] wdata_b_i;
	output [DATA_WIDTH - 1:0] rdata_b_o;
	input wire we_b_i;
	wire [NUM_COL - 1:0] be_b_i;
	wire [NUM_COL - 1:0] be_a_i;
	assign be_b_i = (we_b_i ? o_be_b_i : 4'b0000);
	assign be_a_i = (we_a_i ? o_be_a_i : 4'b0000);
	reg [DATA_WIDTH - 1:0] ram_block [(2 ** ADDR_WIDTH) - 1:0];
	generate
		genvar i;
		for (i = 0; i < NUM_COL; i = i + 1) always @(posedge clk)
			if (en_a_i)
				if (be_a_i[i]) begin
					ram_block[addr_a_i][i * COL_WIDTH+:COL_WIDTH] <= wdata_a_i[i * COL_WIDTH+:COL_WIDTH];
					rdata_a_o[i * COL_WIDTH+:COL_WIDTH] <= wdata_a_i[i * COL_WIDTH+:COL_WIDTH];
				end
				else
					rdata_a_o[i * COL_WIDTH+:COL_WIDTH] <= ram_block[addr_a_i][i * COL_WIDTH+:COL_WIDTH];
	endgenerate
	generate
		for (i = 0; i < NUM_COL; i = i + 1) always @(posedge clk)
			if (en_b_i)
				if (be_b_i[i]) begin
					ram_block[addr_b_i][i * COL_WIDTH+:COL_WIDTH] <= wdata_b_i[i * COL_WIDTH+:COL_WIDTH];
					rdata_b_o[i * COL_WIDTH+:COL_WIDTH] <= wdata_b_i[i * COL_WIDTH+:COL_WIDTH];
				end
				else
					rdata_b_o[i * COL_WIDTH+:COL_WIDTH] <= ram_block[addr_b_i][i * COL_WIDTH+:COL_WIDTH];
	endgenerate
	function [31:0] readWord;
		input integer word_addr;
		readWord = ram_block[word_addr];
	endfunction
	function [7:0] readByte;
		input integer byte_addr;
		readByte = ram_block[byte_addr];
	endfunction
	task writeWord;
		input integer addr;
		input reg [31:0] val;
		ram_block[addr] = val;
	endtask
	task writeByte;
		input integer byte_addr;
		input reg [7:0] val;
		ram_block[byte_addr] = val;
	endtask
endmodule
