module blink_led (
	input wire CLK,
	output reg  LED
);
reg [24:0] counter;

always @(posedge CLK) begin
    if (counter == 25'd24_999_999) begin
        counter <= 25'd0;
        LED <= ~LED;
    end
    else begin
        counter <= counter + 1'b1;
    end
end

endmodule 