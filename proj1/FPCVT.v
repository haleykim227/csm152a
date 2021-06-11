`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Haley Kim
// 
// Create Date:    21:16:21 10/20/2020 
// Design Name: 
// Module Name:    FPCVT 
// Project Name: Proj1
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

// main routine
module FPCVT(
    input [12:0] D,
    output S,
    output [2:0] E,
    output [4:0] F
    );
	 
	// first submodule
	wire [12:0] mag_main;
	mag_generator mag(.D(D), .sign(S), .mag(mag_main));

	// second submodule
	wire roundbit;
	wire [2:0] exp_count;
	wire [4:0] sig_count;
	count_leading_zeros zeros(.mag(mag_main), .exp(exp_count), .significand(sig_count), .roundbit(roundbit));

	// third submodule
	rounding round(.roundbit(roundbit), .exp_in(exp_count), .significand_in(sig_count), .exp_out(E), .significand_out(F));

endmodule

// takes in two's complement and produces sign magnitude
module mag_generator(
	input [12:0] D,
	output sign,
	output [12:0] mag
	);
	
	reg [12:0] mag_reg;
	
	// getting the sign bit before complement-increment
	assign sign = D[12];
	
	always @(*) begin
		// if sign bit 0, do nothing
		// if sign bit 1, flip each bit and add 1
		case (sign)
			1'b0: mag_reg = D;
			1'b1: mag_reg = ~D + 13'b1;
		endcase
		// special case of -4096
		case (D)
			13'b1_0000_0000_0000: begin
				mag_reg = 13'b1_1111_1111_1111;;
			end
		endcase
	end
	
	assign mag = mag_reg;
	
endmodule

// count's leading zeroes, calculates exponent, finds mantissa, finds roundbit
module count_leading_zeros(
	input [12:0] mag,
	output [2:0] exp,
	output [4:0] significand,
	output roundbit
	);

	reg [2:0] exp_reg;
	reg [4:0] significand_reg;
	reg roundbit_reg;
	
	always @(*) begin
		casex (mag) 
			13'b0_1xxx_xxxx_xxxx: begin
				exp_reg = 3'b111;
				significand_reg = mag[11:7];
				roundbit_reg = mag[6];
				end
			13'b0_01xx_xxxx_xxxx: begin
				exp_reg = 3'b110;
				significand_reg = mag[10:6];
				roundbit_reg = mag[5];
				end
			13'b0_001x_xxxx_xxxx: begin
				exp_reg = 3'b101;
				significand_reg = mag[9:5];
				roundbit_reg = mag[4];
				end
			13'b0_0001_xxxx_xxxx: begin
				exp_reg = 3'b100;
				significand_reg = mag[8:4];
				roundbit_reg = mag[3];
				end
			13'b0_0000_1xxx_xxxx: begin
				exp_reg = 3'b011;
				significand_reg = mag[7:3];
				roundbit_reg = mag[2];
				end
			13'b0_0000_01xx_xxxx: begin
				exp_reg = 3'b010;
				significand_reg = mag[6:2];
				roundbit_reg = mag[1];
				end
			13'b0_0000_001x_xxxx: begin
				exp_reg = 3'b001;
				significand_reg = mag[5:1];
				roundbit_reg = mag[0];
				end
			13'b0_0000_0001_xxxx: begin
				exp_reg = 3'b000;
				significand_reg = mag[4:0];
				roundbit_reg = 1'b0;
				end
			13'b0_0000_0000_1xxx: begin
				exp_reg = 3'b000;
				significand_reg = {1'b0, mag[3:0]};
				roundbit_reg = 1'b0;
				end
			13'b0_0000_0000_01xx: begin
				exp_reg = 3'b000;
				significand_reg = {2'b00, mag[2:0]};
				roundbit_reg = 1'b0;
				end
			13'b0_0000_0000_001x: begin
				exp_reg = 3'b000;
				significand_reg = {3'b000, mag[1:0]};
				roundbit_reg = 1'b0;
				end
			13'b0_0000_0000_0001: begin
				exp_reg = 3'b000;
				significand_reg = {4'b0000, mag[0]};
				roundbit_reg = 1'b0;
				end
			13'b0_0000_0000_0000: begin
				exp_reg = 3'b000;
				significand_reg = 5'b0_0000;
				roundbit_reg = 1'b0;
				end
			13'b1_1111_1111_1111: begin
				exp_reg = 3'b111;
				significand_reg = 5'b1_1111;
				roundbit_reg = 1'b0;
				end
			default: begin
				exp_reg = 3'bxxx;
				significand_reg = 5'bx_xxxx;
				roundbit_reg = 1'bx;
				end
		endcase
	end
	
	assign exp = exp_reg;
	assign significand = significand_reg;
	assign roundbit = roundbit_reg;
	
endmodule

// either rounds up or down
module rounding(
	input roundbit,
	input [2:0] exp_in,
	input [4:0] significand_in,
	output [2:0] exp_out,
	output [4:0] significand_out
	);
	
	reg [2:0] exp_reg;
	reg [4:0] significand_reg;
	
	always @(*) begin
		case (roundbit)
			1'b1: begin
				if (significand_in == 5'b1_1111) begin
					significand_reg = 5'b1_0000;
					if (exp_in == 3'b111) begin
						exp_reg = 3'b111;
						significand_reg = 5'b1_1111;
					end
					else
						exp_reg = exp_in + 1'b1;
				end
				else
					significand_reg = significand_in + 1'b1;
			end
		default: begin
			exp_reg = exp_in;
			significand_reg = significand_in;
		end
		endcase
	end
	
	assign exp_out = exp_reg;
	assign significand_out = significand_reg;
	
endmodule
	
