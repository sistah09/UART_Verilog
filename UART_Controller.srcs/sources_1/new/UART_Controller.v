`timescale 1ns / 1ps

module UART_Controller(
    input wire clk_UART,
    input wire reset,
    input wire rx,
    output wire tx
);

    wire tx_complete, rx_complete;
    wire [7:0] tx_data, rx_data;    
    
    uart_tx tx0(clk_UART, reset, tx_data, tx, tx_complete);
    uart_rx rx0(clk_UART, reset, rx, rx_data, rx_complete);
endmodule
