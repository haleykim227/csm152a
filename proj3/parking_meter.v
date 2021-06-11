`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:40:22 11/29/2020 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
	input add1,
	input add2,
	input add3,
	input add4,
	input rst1,
	input rst2,
	input clk,
	input rst,
	output [6:0] led_seg,
	output a1,
	output a2,
	output a3,
	output a4,
	output [3:0] val1,
	output [3:0] val2,
	output [3:0] val3,
	output [3:0] val4
   );
	
	// Temporary Reg Values
	reg clk_div_100_reg;
	reg [13:0] bin_time;
	reg [1:0] flash;
	wire clk_div_100;
	
	// divide by 100 clock for period of 1
	reg [6:0] counter;
	always @(posedge clk) begin
		if (rst) begin
			counter <= 7'b000_0000;
			clk_div_100_reg <= 0;
		end
		else begin
			if (counter == 7'b110_0010) begin
				clk_div_100_reg <= ~clk_div_100_reg;
				counter <= counter + 1'b1;
			end
			else if (counter == 7'b110_0011) begin
				counter <= 7'b000_0000;
				clk_div_100_reg <= ~clk_div_100_reg;
			end
			else
				counter <= counter + 1'b1;
		end
	end
	
	assign clk_div_100 = clk_div_100_reg;
	
	// determine state
	always @(posedge clk) begin
		if (rst)
			bin_time <= 0;
		else if (rst1)
			bin_time <= 16;
		else if (rst2)
			bin_time <= 150;
		else if (add1) begin
			if (9999-bin_time >= 60)
				bin_time <= bin_time + 60;
			else
				bin_time <= 9999;
		end
		else if (add2) begin
			if (9999-bin_time >= 120)
				bin_time <= bin_time + 120;
			else
				bin_time <= 9999;
		end
		else if (add3) begin
			if (9999-bin_time >= 180)
				bin_time <= bin_time + 180;
			else
				bin_time <= 9999;
		end
		else if (add4) begin
			if (9999-bin_time >= 300)
				bin_time <= bin_time + 300;
			else
				bin_time <= 9999;
		end
		else if (clk_div_100) begin
			if (bin_time != 0)
				bin_time <= bin_time - 1;
		end
	end
	
	// determine output based on state
	//reg [1:0] flash;
	always @(*) begin
		if (bin_time == 0)
			flash <= 2'b01;
		else if (bin_time <= 180)
			flash <= 2'b10;
		else
			flash <= 2'b00;
	end
	
	// determine off signal based on state
	reg [6:0] count;
	reg off;
	always @(posedge clk) begin
		if (flash == 2'b00)
			off <= 0;
		else if (flash == 2'b01) begin
			if (rst) begin
				count <= 7'b000_0000;
				off <= 0;
			end
			else if (count == 7'b011_0001) begin
				off <= ~off;
				count <= 7'b000_0000;
			end
			else
				count <= count + 1;
		end
		else if (flash == 2'b10)
			off <= 0;
	end
	
	BCDencoder bcd_test(.bin_time(bin_time), .val1(val1), .val2(val2), .val3(val3), .val4(val4));
	sevenseg led_test(.bin_time(bin_time), .clk(clk), .rst(rst), .off(off), .flash(flash), .clk_div_100(clk_div_100),
							.dig1(val1), .dig2(val2), .dig3(val3), .dig4(val4), .a1(a1), .a2(a2), .a3(a3), .a4(a4), 
							.led_seg(led_seg));
	
endmodule

module BCDencoder(
	input [13:0] bin_time,
	output [3:0] val1,
	output [3:0] val2,
	output [3:0] val3,
	output [3:0] val4
	);
	
	assign val1 = bin_time % 10;
	assign val2 = (bin_time/10) % 10;
	assign val3 = (bin_time/100) % 10;
	assign val4 = (bin_time/1000) % 10;
	
endmodule

module sevenseg(
	input [13:0] bin_time,
	input clk,
	input rst,
	input off,
	input [1:0] flash,
	input clk_div_100,
	input [3:0] dig1,
	input [3:0] dig2,
	input [3:0] dig3,
	input [3:0] dig4,
	output a1,
	output a2,
	output a3,
	output a4,
	output [6:0] led_seg
	);
	
	// Temporary Reg Values
	reg a1_reg;
	reg a2_reg;
	reg a3_reg;
	reg a4_reg;
	reg [6:0] led_seg_reg;
	
	function [6:0] ledsegdisplay;
		input [4:0] digit;
		begin
			case (digit)
			0: ledsegdisplay = 7'b000_0001;
			1: ledsegdisplay = 7'b100_1111;
			2: ledsegdisplay = 7'b001_0010;
			3: ledsegdisplay = 7'b000_0110;
			4: ledsegdisplay = 7'b100_1100;
			5: ledsegdisplay = 7'b010_0100;
			6: ledsegdisplay = 7'b010_0000;
			7: ledsegdisplay = 7'b000_1111;
			8: ledsegdisplay = 7'b000_0000;
			9: ledsegdisplay = 7'b000_0100;
			endcase
		end
	endfunction
	
	reg [1:0] counter;
	always @(posedge clk) begin
		if (rst) begin
			counter <= 0;
		end
		else
			counter <= counter + 1;
	end
	
	always @(*) begin
		if (off)
			led_seg_reg <= 7'b111_1111;
		else if (flash == 2'b10) begin
			if ((bin_time % 2) == 1)
				led_seg_reg <= 7'b111_1111;
			else begin
				case (counter)
			0: begin
				a1_reg <= 0;
				a2_reg <= 1;
				a3_reg <= 1;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig1);
				end
			1: begin
				a1_reg <= 1;
				a2_reg <= 0;
				a3_reg <= 1;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig2);
				end
			2: begin
				a1_reg <= 1;
				a2_reg <= 1;
				a3_reg <= 0;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig3);
				end
			3: begin
				a1_reg <= 1;
				a2_reg <= 1;
				a3_reg <= 1;
				a4_reg <= 0;
				led_seg_reg <= ledsegdisplay(dig4);
				end
			endcase
			end
		end
		else begin
			case (counter)
			0: begin
				a1_reg <= 0;
				a2_reg <= 1;
				a3_reg <= 1;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig1);
				end
			1: begin
				a1_reg <= 1;
				a2_reg <= 0;
				a3_reg <= 1;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig2);
				end
			2: begin
				a1_reg <= 1;
				a2_reg <= 1;
				a3_reg <= 0;
				a4_reg <= 1;
				led_seg_reg <= ledsegdisplay(dig3);
				end
			3: begin
				a1_reg <= 1;
				a2_reg <= 1;
				a3_reg <= 1;
				a4_reg <= 0;
				led_seg_reg <= ledsegdisplay(dig4);
				end
			endcase
		end
	end
	
	assign a1 = a1_reg;
	assign a2 = a2_reg;
	assign a3 = a3_reg;
	assign a4 = a4_reg;
	assign led_seg = led_seg_reg;
	
endmodule
