`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:18:15 11/29/2020
// Design Name:   parking_meter
// Module Name:   /home/ise/Proj3/testbench_405111152.v
// Project Name:  Proj3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_405111152;

	// Inputs
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst),
		.led_seg(led_seg), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4)
	);

	integer i;
	integer j;
	initial begin
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		rst = 1;

		// check flashing on 0000
		#25000000;
		rst = 0;
		#5000000;
		for (i = 0; i < 300; i = i + 1) begin
			#5000000;
		end
		// check add3
		#5000000;
		add3 = 1;
		#5000000;
		add3 = 0;
		// check counting down & flashing
		for (j = 0; j < 900; j = j + 1) begin
			#5000000;
		end
		// check add4
		#5000000;
		add4 = 1;
		#5000000;
		add4 = 0;
		// check add1
		#5000000;
		add1 = 1;
		#5000000;
		add1 = 0;
		// check add2
		#5000000;
		add2 = 1;
		#5000000;
		add2 = 0;
		// check rst2
		#5000000;
		rst2 = 1;
		#5000000;
		rst2 = 0;
		// check rst1
		#5000000;
		rst1 = 1;
		#5000000;
		rst1 = 0;
		// check rst
		#5000000;
		rst = 1;
		#5000000;
		rst = 0;
		// checking what happens when you go over 9999
		for (i = 0; i < 34; i = i + 1) begin
			#5000000;
			add4 = 1;
			#5000000;
			add4 = 0;
		end
		// testing all 4 adds at 9999 max limit
		#5000000;
		add1 = 1;
		#5000000;
		add1 = 0;
		#5000000;
		add2 = 1;
		#5000000;
		add2 = 0;
		#5000000;
		add3 = 1;
		#5000000;
		add3 = 0;
		// no flashing at this point because over 180
        
		// Add stimulus here

	end
	
	always begin
		#5000000; // this is 0.005 second
		clk = ~clk;
	end
      
endmodule

