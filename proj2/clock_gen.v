`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:06 10/27/2020 
// Design Name: 
// Module Name:    clock_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock_gen(
	input clk_in,
	input rst,
	output clk_div_2,
	output clk_div_4,
	output clk_div_8,
	output clk_div_16,
	output clk_div_28,
	output clk_div_5,
	output [7:0] toggle_counter
	);
	
	clock_div_two task_one(.clk_in(clk_in), .rst(rst), .clk_div_2_sub(clk_div_2), .clk_div_4_sub(clk_div_4), 
						  .clk_div_8_sub(clk_div_8), .clk_div_16_sub(clk_div_16));
	clock_div_twenty_eight task_two(.clk_in(clk_in), .rst(rst), .clk_div_28_sub(clk_div_28));
	clock_div_five task_three(.clk_in(clk_in), .rst(rst), .clk_div_five_sub(clk_div_5));
	clock_strobe task_four(.clk_in(clk_in), .rst(rst), .toggle_counter_sub(toggle_counter));
	
endmodule

module clock_div_two(
	input clk_in,
	input rst,
	output clk_div_2_sub,
	output clk_div_4_sub,
	output clk_div_8_sub,
	output clk_div_16_sub
	);
	
	// Temporary Reg Values
	reg clk_div_2_reg;
	reg clk_div_4_reg;
	reg clk_div_8_reg;
	reg clk_div_16_reg;
	
	// 4-bit Counter Implementation
	reg [3:0] a;
	always @(posedge clk_in) begin
		if (rst)
			a <= 4'b0000;
		else begin
			a <= a + 1'b1;
			clk_div_2_reg <= a[0];
			clk_div_4_reg <= a[1];
			clk_div_8_reg <= a[2];
			clk_div_16_reg <= a[3];
		end
	end
	 
	assign clk_div_2_sub = clk_div_2_reg;
	assign clk_div_4_sub = clk_div_4_reg;
	assign clk_div_8_sub = clk_div_8_reg;
	assign clk_div_16_sub = clk_div_16_reg;
	
endmodule

module clock_div_twenty_eight (
	input clk_in,
	input rst,
	output clk_div_28_sub
	);
	
	// Temporary Reg Value
	reg clk_div_28_reg;
	
	// 4-bit Counter Implementation
	reg [3:0] a;
	always @(posedge clk_in) begin
		if (rst) begin
			a <= 4'b0000;
			clk_div_28_reg <= 0;
		end
		else begin
			if (a == 4'b1101) begin
				clk_div_28_reg <= ~clk_div_28_reg;
				a <= 4'b0000;
			end
			else
				a <= a + 1'b1;
		end
	end
	
	assign clk_div_28_sub = clk_div_28_reg;
	
endmodule

module clock_div_five(
	input clk_in,
	input rst,
	output clk_div_five_sub
	);
	
	// Temporary Reg Values
	reg clk_div_five_pos_reg;
	reg clk_div_five_neg_reg;
	
	// 4-bit Counter Posedge Implementation
	reg [3:0] a;
	always @(posedge clk_in) begin
		if (rst) begin
			a <= 4'b0000;
			clk_div_five_pos_reg <= 1;
		end
		else begin
			if (a == 4'b0001) begin
				clk_div_five_pos_reg <= ~clk_div_five_pos_reg;
				a <= a + 1'b1;
			end
			else if (a == 4'b0100) begin
				a <= 4'b0000;
				clk_div_five_pos_reg <= ~clk_div_five_pos_reg;
			end
			else
				a <= a + 1'b1;
		end
	end
	
	// 4-bit Counter Negedge Implementation
	reg [3:0] b;
	always @(negedge clk_in) begin
		if (rst) begin
			b <= 4'b0000;
			clk_div_five_neg_reg <= 1;
		end
		else begin
			if (b == 4'b0001) begin
				clk_div_five_neg_reg <= ~clk_div_five_neg_reg;
				b <= b + 1'b1;
			end
			else if (b == 4'b0100) begin
				b <= 4'b0000;
				clk_div_five_neg_reg <= ~clk_div_five_neg_reg;
			end
			else
				b <= b + 1'b1;
		end
	end
	
	assign clk_div_five_pos_sub = clk_div_five_pos_reg;
	assign clk_div_five_neg_sub = clk_div_five_neg_reg;
	
	assign clk_div_five_sub = ((clk_div_five_pos_sub) || (clk_div_five_neg_sub));
	
endmodule

module clock_strobe(
	input clk_in,
	input rst,
	output [7:0] toggle_counter_sub
	);
	
	// Temporary Reg Value
	reg strobe_reg;
	reg [7:0] toggle_counter_reg;
	
	// 4-bit Counter Implementation, Strobe
	reg [3:0] a;
	always @(posedge clk_in) begin
		if (rst) begin
			a <= 4'b0000;
			strobe_reg <= 0;
		end
		else begin
			if (a == 4'b0010) begin
				strobe_reg <= ~strobe_reg;
				a <= a + 1'b1;
			end
			else if (a == 4'b0011) begin
				a <= 4'b0000;
				strobe_reg <= ~strobe_reg;
			end
			else
				a <= a + 1'b1;
		end
	end
	
	// toggle_counter Implementation
	always @(posedge clk_in) begin
		if (rst) begin
			toggle_counter_reg <= 0;
		end
		else begin
			if (strobe_reg)
				toggle_counter_reg <= (toggle_counter_reg - 5);
			else
				toggle_counter_reg <= (toggle_counter_reg + 2);
		end
	end
	
	assign toggle_counter_sub = toggle_counter_reg;
	
endmodule
