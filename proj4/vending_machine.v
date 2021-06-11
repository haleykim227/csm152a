`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:59:13 12/11/2020 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
	input CARD_IN,
	input VALID_TRAN,
	input [3:0] ITEM_CODE,
	input KEY_PRESS,
	input DOOR_OPEN,
	input RELOAD,
	input CLK,
	input RESET,
	output VEND,
	output INVALID_SEL,
	output FAILED_TRAN,
	output [2:0] COST
	);
	
	// 10 State Parameters
	parameter IDLE_STATE = 4'b0000;
	parameter RESET_STATE = 4'b0001;
	parameter RELOAD_STATE = 4'b0010;
	parameter TRANSACT_STATE_1 = 4'b0011;
	parameter TRANSACT_STATE_2 = 4'b0100;
	parameter INVALID_SEL_STATE = 4'b0101;
	parameter WAIT_VALID_SIGNAL_STATE = 4'b0110;
	parameter VEND_STATE = 4'b0111;
	parameter INVALID_TRAN_STATE = 4'b1000;
	parameter DOOR_HIGH_STATE = 4'b1001;
	
	// Reg Variables
	reg [3:0] current_state, next_state;
	reg [2:0] counter; // count up to 5
	reg [3:0] MSD, LSD; // most and least significant digit of ITEM_CODE
	reg VEND_REG;
	reg INVALID_SEL_REG;
	reg FAILED_TRAN_REG;
	reg [2:0] COST_REG;
	reg [3:0] ITEM_COUNT_00, ITEM_COUNT_01, ITEM_COUNT_02, ITEM_COUNT_03, ITEM_COUNT_04;
	reg [3:0] ITEM_COUNT_05, ITEM_COUNT_06, ITEM_COUNT_07, ITEM_COUNT_08, ITEM_COUNT_09;
	reg [3:0] ITEM_COUNT_10, ITEM_COUNT_11, ITEM_COUNT_12, ITEM_COUNT_13, ITEM_COUNT_14;
	reg [3:0] ITEM_COUNT_15, ITEM_COUNT_16, ITEM_COUNT_17, ITEM_COUNT_18, ITEM_COUNT_19;
	
	// Always Block to Update State
	always @(posedge CLK) begin
		if (RESET)
			current_state <= RESET_STATE;
		else begin
			current_state <= next_state;
			//if (current_state != next_state)
				//counter <= 0; // at state change, reset counter
		end
	end
	
	// Always Block to Update Counter based on Current State
	always @(negedge CLK) begin
		case (current_state)
		TRANSACT_STATE_1: counter <= counter + 1;
		TRANSACT_STATE_2: counter <= counter + 1;
		WAIT_VALID_SIGNAL_STATE: counter <= counter + 1;
		VEND_STATE: counter <= counter + 1;
		default: counter <= 0;
		endcase
		if (current_state != next_state)
			counter <= 0;
	end
	
	// Always Block to Decide Next State based on Counter and Inputs
	always @(*) begin
		case (current_state)
			IDLE_STATE: begin
				if (CARD_IN == 1)
					next_state = TRANSACT_STATE_1;
				else if (RELOAD == 1)
					next_state = RELOAD_STATE;
				else
					next_state = IDLE_STATE;
			end
			RESET_STATE: begin
				if (RESET == 0)
					next_state = IDLE_STATE;
				else
					next_state = RESET_STATE;
			end
			RELOAD_STATE: begin
				if (RELOAD == 0)
					next_state = IDLE_STATE;
				else
					next_state = RELOAD_STATE;
			end
			TRANSACT_STATE_1: begin
				if (counter == 5)
					next_state = IDLE_STATE;
				else begin
					if (KEY_PRESS == 1) begin
						next_state = TRANSACT_STATE_2;
						MSD = ITEM_CODE; // store ITEM_CODE for later
					end
					else
						next_state = TRANSACT_STATE_1;
				end
			end
			TRANSACT_STATE_2: begin
				if (counter == 5)
					next_state = IDLE_STATE;
				else begin
					if (KEY_PRESS == 1) begin
						LSD = ITEM_CODE;
						if ((MSD > 1) || (MSD < 0))
							next_state = INVALID_SEL_STATE;
						else if (LSD > 9)
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 0) && (ITEM_COUNT_00 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 1) && (ITEM_COUNT_01 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 2) && (ITEM_COUNT_02 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 3) && (ITEM_COUNT_03 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 4) && (ITEM_COUNT_04 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 5) && (ITEM_COUNT_05 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 6) && (ITEM_COUNT_06 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 7) && (ITEM_COUNT_07 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 8) && (ITEM_COUNT_00 == 8)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 0) && (LSD == 9) && (ITEM_COUNT_00 == 9)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 0) && (ITEM_COUNT_10 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 1) && (ITEM_COUNT_11 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 2) && (ITEM_COUNT_12 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 3) && (ITEM_COUNT_13 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 4) && (ITEM_COUNT_14 == 0))
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 5) && (ITEM_COUNT_15 == 0)) 
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 6) && (ITEM_COUNT_16 == 0))
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 7) && (ITEM_COUNT_17 == 0))
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 8) && (ITEM_COUNT_18 == 0))
							next_state = INVALID_SEL_STATE;
						else if ((MSD == 1) && (LSD == 9) && (ITEM_COUNT_19 == 0))
							next_state = INVALID_SEL_STATE;
						else
							next_state = WAIT_VALID_SIGNAL_STATE;
					end
					else
						next_state = TRANSACT_STATE_2;
				end
			end
			INVALID_SEL_STATE: begin
				next_state = IDLE_STATE;
			end
			WAIT_VALID_SIGNAL_STATE: begin
				if (counter == 5)
					next_state = INVALID_TRAN_STATE;
				else begin
					if (VALID_TRAN == 1)
						next_state = VEND_STATE;
					else
						next_state = WAIT_VALID_SIGNAL_STATE;
				end
			end
			VEND_STATE: begin
				if (counter == 5)
					next_state = IDLE_STATE;
				else begin
					if (DOOR_OPEN == 1)
						next_state = DOOR_HIGH_STATE;
					else
						next_state = VEND_STATE;
				end
			end
			INVALID_TRAN_STATE: begin
				next_state = IDLE_STATE;
			end
			DOOR_HIGH_STATE: begin
				if (DOOR_OPEN == 0)
					next_state = IDLE_STATE;
				else
					next_state = DOOR_HIGH_STATE;
			end
		endcase
	end
	
	// Always Block to Set Outputs
	always @(*) begin
		case (current_state)
			IDLE_STATE: begin
				VEND_REG = 0;
				INVALID_SEL_REG = 0;
				FAILED_TRAN_REG = 0;
				COST_REG = 0;
			end
			RESET_STATE: begin
				VEND_REG = 0;
				INVALID_SEL_REG = 0;
				FAILED_TRAN_REG = 0;
				COST_REG = 0;
				ITEM_COUNT_00 = 0;
				ITEM_COUNT_01 = 0;
				ITEM_COUNT_02 = 0;
				ITEM_COUNT_03 = 0;
				ITEM_COUNT_04 = 0;
				ITEM_COUNT_05 = 0;
				ITEM_COUNT_06 = 0;
				ITEM_COUNT_07 = 0;
				ITEM_COUNT_08 = 0;
				ITEM_COUNT_09 = 0;
				ITEM_COUNT_10 = 0;
				ITEM_COUNT_11 = 0;
				ITEM_COUNT_12 = 0;
				ITEM_COUNT_13 = 0;
				ITEM_COUNT_14 = 0;
				ITEM_COUNT_15 = 0;
				ITEM_COUNT_16 = 0;
				ITEM_COUNT_17 = 0;
				ITEM_COUNT_18 = 0;
				ITEM_COUNT_19 = 0;
			end
			RELOAD_STATE: begin
				ITEM_COUNT_00 = 10;
				ITEM_COUNT_01 = 10;
				ITEM_COUNT_02 = 10;
				ITEM_COUNT_03 = 10;
				ITEM_COUNT_04 = 10;
				ITEM_COUNT_05 = 10;
				ITEM_COUNT_06 = 10;
				ITEM_COUNT_07 = 10;
				ITEM_COUNT_08 = 10;
				ITEM_COUNT_09 = 10;
				ITEM_COUNT_10 = 10;
				ITEM_COUNT_11 = 10;
				ITEM_COUNT_12 = 10;
				ITEM_COUNT_13 = 10;
				ITEM_COUNT_14 = 10;
				ITEM_COUNT_15 = 10;
				ITEM_COUNT_16 = 10;
				ITEM_COUNT_17 = 10;
				ITEM_COUNT_18 = 10;
				ITEM_COUNT_19 = 10;
			end
			TRANSACT_STATE_1: begin
			end
			TRANSACT_STATE_2: begin
			end
			INVALID_SEL_STATE: begin
				INVALID_SEL_REG = 1;
			end
			WAIT_VALID_SIGNAL_STATE: begin
				if ((MSD == 0) && (LSD == 0))
					COST_REG = 1;
				else if ((MSD == 0) && (LSD == 1))
					COST_REG = 1;
				else if ((MSD == 0) && (LSD == 2))
					COST_REG = 1;
				else if ((MSD == 0) && (LSD == 3))
					COST_REG = 1;
				else if ((MSD == 0) && (LSD == 4))
					COST_REG = 2;
				else if ((MSD == 0) && (LSD == 5))
					COST_REG = 2;
				else if ((MSD == 0) && (LSD == 6))
					COST_REG = 2;
				else if ((MSD == 0) && (LSD == 7))
					COST_REG = 2;
				else if ((MSD == 0) && (LSD == 8))
					COST_REG = 3;
				else if ((MSD == 0) && (LSD == 9))
					COST_REG = 3;
				else if ((MSD == 1) && (LSD == 0))
					COST_REG = 3;
				else if ((MSD == 1) && (LSD == 1))
					COST_REG = 3;
				else if ((MSD == 1) && (LSD == 2))
					COST_REG = 4;
				else if ((MSD == 1) && (LSD == 3))
					COST_REG = 4;
				else if ((MSD == 1) && (LSD == 4))
					COST_REG = 4;
				else if ((MSD == 1) && (LSD == 5))
					COST_REG = 4;
				else if ((MSD == 1) && (LSD == 6))
					COST_REG = 5;
				else if ((MSD == 1) && (LSD == 7))
					COST_REG = 5;
				else if ((MSD == 1) && (LSD == 8))
					COST_REG = 6;
				else if ((MSD == 1) && (LSD == 9))
					COST_REG = 6;
			end
			VEND_STATE: begin
				VEND_REG = 1;
				if ((MSD == 0) && (LSD == 0))
					ITEM_COUNT_00 = ITEM_COUNT_00 - 1;
				else if ((MSD == 0) && (LSD == 1))
					ITEM_COUNT_01 = ITEM_COUNT_01 - 1;
				else if ((MSD == 0) && (LSD == 2))
					ITEM_COUNT_02 = ITEM_COUNT_02 - 1;
				else if ((MSD == 0) && (LSD == 3))
					ITEM_COUNT_03 = ITEM_COUNT_03 - 1;
				else if ((MSD == 0) && (LSD == 4))
					ITEM_COUNT_04 = ITEM_COUNT_04 - 1;
				else if ((MSD == 0) && (LSD == 5))
					ITEM_COUNT_05 = ITEM_COUNT_05 - 1;
				else if ((MSD == 0) && (LSD == 6))
					ITEM_COUNT_06 = ITEM_COUNT_06 - 1;
				else if ((MSD == 0) && (LSD == 7))
					ITEM_COUNT_07 = ITEM_COUNT_07 - 1;
				else if ((MSD == 0) && (LSD == 8))
					ITEM_COUNT_08 = ITEM_COUNT_08 - 1;
				else if ((MSD == 0) && (LSD == 9))
					ITEM_COUNT_09 = ITEM_COUNT_09 - 1;
				else if ((MSD == 1) && (LSD == 0))
					ITEM_COUNT_10 = ITEM_COUNT_10 - 1;
				else if ((MSD == 1) && (LSD == 1))
					ITEM_COUNT_11 = ITEM_COUNT_11 - 1;
				else if ((MSD == 1) && (LSD == 2))
					ITEM_COUNT_12 = ITEM_COUNT_12 - 1;
				else if ((MSD == 1) && (LSD == 3))
					ITEM_COUNT_13 = ITEM_COUNT_13 - 1;
				else if ((MSD == 1) && (LSD == 4))
					ITEM_COUNT_14 = ITEM_COUNT_14 - 1;
				else if ((MSD == 1) && (LSD == 5))
					ITEM_COUNT_15 = ITEM_COUNT_15 - 1;
				else if ((MSD == 1) && (LSD == 6))
					ITEM_COUNT_16 = ITEM_COUNT_16 - 1;
				else if ((MSD == 1) && (LSD == 7))
					ITEM_COUNT_17 = ITEM_COUNT_17 - 1;
				else if ((MSD == 1) && (LSD == 8))
					ITEM_COUNT_18 = ITEM_COUNT_18 - 1;
				else if ((MSD == 1) && (LSD == 9))
					ITEM_COUNT_19 = ITEM_COUNT_19 - 1;
			end
			INVALID_TRAN_STATE: begin
				FAILED_TRAN_REG = 1;
			end
			DOOR_HIGH_STATE: begin
			end
		endcase
	end
	
	// Assign to Wire Outputs
	assign VEND = VEND_REG;
	assign INVALID_SEL = INVALID_SEL_REG;
	assign FAILED_TRAN = FAILED_TRAN_REG;
	assign COST = COST_REG;

endmodule
