`timescale 1ns / 1ps

module uart_tx(
   input  clk_UART,
	input reset,
   input  [7:0] data,
   output reg tx,
	output reg tx_complete
);

	parameter IDLE = 2'b00;
	parameter START = 2'b01;
	parameter DATA = 2'b10;
	parameter STOP = 2'b11;

	parameter NULL_CHAR = 8'd0;

	reg [7:0] tx_data;
	reg [2:0] bitIndex;
	reg [1:0] state;

	// FSM
	always @(posedge clk_UART or negedge reset) begin
		if(~reset) begin
			tx <= 1'b1;
			tx_complete <= 1'b0;
			bitIndex <= 3'd0;
			state <= IDLE;
		end else begin
			case(state)
				// IDLE state, tx will be constantly HIGH.
				IDLE: begin
					tx <= 1'b1;
					tx_complete <= 1'b0;
					if (data != NULL_CHAR) begin
						state <= START;
						tx_data <= data;
					end
				end
				
				// START state, pull the tx to LOW.
				START: begin
					tx <= 1'b0;
					state <= DATA;
				end
				
				// DATA state, send the 8-bit data from MSB to LSB
				DATA: begin
					tx <= tx_data[bitIndex];
					if(bitIndex == 3'd7) begin
						bitIndex <= 3'd0;
						tx_complete <= 1'b1;
						state <= STOP;
					end else
						bitIndex <= bitIndex + 1'b1;
				end
				
				// STOP state, pull the tx back to HIGH
				STOP: begin
					tx <= 1'b1;
					state <= IDLE;
				end
				
				// Default case
				default : begin
					tx <= 1'b0;
					tx_complete <= 1'b0;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule
