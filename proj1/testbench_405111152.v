`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:09:20 10/23/2020
// Design Name:   FPCVT
// Module Name:   /home/ise/Proj1/testbench_405111152.v
// Project Name:  Proj1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	localparam period = 40;
	
	initial begin
		// Initialize Inputs
		D = 13'b0;
		#period;
		
		D = 13'b0_0000_0000_0001; // +1
		#period;
		
		D = 13'b1_1111_1111_1111; // -1
		#period;
		
		D = 13'b1_0000_0000_0000; // -4096
		#period;
		
		D = 13'b0_0001_1111_1010; // +506
		#period;
		
		D = 13'b0_0000_1111_1101; // should be 0_100_10000
		#period;
		
		
		D = 13'b0_1111_1111_1111; // should be 0_111_11111
		#period;
		
		D = 13'b0_0000_0000_1000; // should be 0_000_01000
		#period;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule