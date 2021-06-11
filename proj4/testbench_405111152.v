`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:13:44 12/11/2020
// Design Name:   vending_machine
// Module Name:   /home/ise/Proj4/testbench_405111152.v
// Project Name:  Proj4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

	initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;
		RESET = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		RESET = 1; // check IDLE_STATE -> RESET_STATE
		#10;
		RESET = 0;
		#40;
		RESET = 1; // check staying at RESET_STATE
		#100;
		RESET = 0;
		#40;
		
		RELOAD = 1; // check IDLE_STATE -> RELOAD_STATE
		#10;
		RELOAD = 0;
		#40;
		RELOAD = 1; // check staying at RELOAD_STATE
		#100;
		RELOAD = 0;
		#40;
		
		// 1 CARD_IN
		CARD_IN = 1; // check IDLE_STATE -> TRANSACT_STATE_1
		#10; // check TRANSACT_STATE_1 timeout
		CARD_IN = 0;
		#100;
		
		// 2 CARD_IN
		CARD_IN = 1; // check valid MSD entry
		#10; // check TRANSACT_STATE_1 -> TRANSACT_STATE_2
		CARD_IN = 0; // check TRANSACT_STATE_2 timeout
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#100;
		
		// 3 CARD_IN
		CARD_IN = 1; // check valid LSD entry
		#10; // check TRANSACT_STATE_2 -> WAIT_VALID_SIGNAL_STATE
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		RESET = 1; 
		#10;
		RESET = 0;
		#10;
		RELOAD = 1; // return to IDLE_STATE
		#10;
		RELOAD = 0;
		#10;
		
		// 4 CARD_IN
		CARD_IN = 1; // check TRANSACT_STATE_2 -> INVALID_SEL_STATE -> IDLE_STATE
		#10; // check invalid MSD entry
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 2;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 0;
		#10;
		KEY_PRESS = 0;
		#40;
		
		// 5 CARD_IN
		CARD_IN = 1; // check TRANSACT_STATE_2 -> INVALID_SEL_STATE -> IDLE_STATE
		#10; // check invalid LSD entry
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 10;
		#10;
		KEY_PRESS = 0;
		#40;
		
		// 6 CARD_IN
		CARD_IN = 1; // check TRANSACT_STATE_2 -> WAIT_VALID_SIGNAL_STATE -> INVALID_TRAN_STATE -> IDLE_STATE
		#10; // check WAIT_VALID_SIGNAL_STATE timeout
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4;
		#10;
		KEY_PRESS = 0;
		#80;
		
		// 7 CARD_IN
		CARD_IN = 1; // 1st vending of item 14, INVALID_TRAN_STATE
		#10; // check VEND_STATE timeout
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#80;
		
		// 8 CARD_IN
		CARD_IN = 1; // 2nd vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1; 
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 9 CARD_IN
		CARD_IN = 1; // 3rd vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 10 CARD_IN
		CARD_IN = 1; // 4th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 11 CARD_IN
		CARD_IN = 1; // 5th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 12 CARD_IN
		CARD_IN = 1; // 6th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 13 CARD_IN
		CARD_IN = 1; // 7th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 14 CARD_IN
		CARD_IN = 1; // 8th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 15 CARD_IN
		CARD_IN = 1; // 9th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 16 CARD_IN
		CARD_IN = 1; // 10th vending of item 14, INVALID_TRAN_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1; 
		#100;
		DOOR_OPEN = 0;
		#40;
		
		// 17 CARD_IN
		CARD_IN = 1; // 11th vending of item 14, INVALID_SEL_STATE
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 1;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 4; 
		#10; 
		KEY_PRESS = 0;
		#10;
		VALID_TRAN = 1;
		#10;
		VALID_TRAN = 0;
		#10;
		DOOR_OPEN = 1;
		#100;
		DOOR_OPEN = 0;
		#300;
		
		// 18 CARD_IN
		CARD_IN = 1; // going to RESET_STATE from a random state
		#10;
		CARD_IN = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 0;
		#10;
		KEY_PRESS = 0;
		#10;
		KEY_PRESS = 1; ITEM_CODE = 0; 
		#10; 
		KEY_PRESS = 0;
		#10;
		RESET = 1;
		#10;
		RESET = 0;
		#10;
		
	end
	
	always begin
		#5;
		CLK = ~CLK;
	end
      
endmodule

