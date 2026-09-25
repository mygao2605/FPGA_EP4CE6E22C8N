module button_debounce(
    input  wire clk,
    input  wire key,
    output reg  led
);

    // 50 MHz × 20 ms = 1,000,000 clock
    localparam integer DEBOUNCE_COUNT = 1_000_000;

    reg [19:0] counter;
    reg key_sync;
    reg key_prev;

    initial begin
        led = 1'b0;
        counter = 20'd0;
        key_sync = 1'b1;
        key_prev = 1'b1;
    end

    always @(posedge clk) begin

        // Đồng bộ tín hiệu nút nhấn
        key_sync <= key;

        // Phát hiện trạng thái key thay đổi
        if (key_sync != key_prev) begin
            counter <= counter + 1'b1;

            // Đã ổn định 20 ms
            if (counter == DEBOUNCE_COUNT - 1) begin
                key_prev <= key_sync;
                counter <= 20'd0;

                // Nhấn nút: key = 0
                if (key_sync == 1'b0)
                    led <= ~led;
            end
        end
        else begin
            counter <= 20'd0;
        end
    end

endmodule