`timescale 1ns / 1ps

module uart_rx(
	input clk_UART,
	input reset,
	input rx,
	output reg [7:0] rx_msg,
	output reg rx_complete
);
	
	parameter START = 2'b00;
	parameter DATA = 2'b01;
	parameter STOP = 2'b10;
	
	reg[2:0] bitIndex;
	reg[7:0] data;
	reg[1:0] state;
	reg incoming_bit;
	
	// For sampling the data
	always @ (negedge clk_UART)
		incoming_bit <= rx;
	
	always @ (posedge clk_UART or negedge reset) begin
		if(~reset) begin
			rx_msg <= 8'd0;
			rx_complete <= 1'b0;
			data <= 8'd0;
			state <= START;
		end else begin
			case(state)
				START: begin
					rx_complete <= 1'b0;
					if(~incoming_bit) begin
						state <= DATA;
						bitIndex <= 3'd0;
						data <= 8'd0;
					end
				end
				
				DATA: begin
					data[bitIndex] <= incoming_bit;
					if(bitIndex == 7) begin
						state <= STOP;
						rx_msg <= data;
					end else
						bitIndex <= bitIndex + 1'b1;
				end
				
				STOP: begin
					rx_complete <= 1'b1;
					state <= START;
				end
					
				default: begin
					state <= START;
					rx_complete <= 1'b0;
				end
			endcase
		end
	end
endmodule