module uart_tx #(
	parameter CLK_FREQ  = 50000000,
   parameter BAUD_RATE = 115200  
)(
	input wire clk,
	input wire rst_n,
	input wire tx_start,
	input wire [7:0] tx_data,
	output reg tx,
	output reg tx_busy
);

endmodule