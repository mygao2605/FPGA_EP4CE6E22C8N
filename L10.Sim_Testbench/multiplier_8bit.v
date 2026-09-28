module multiplier_8bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'h00;
            done     <= 1'b0;
        end else if (start) begin
            data_out <= data_in << 1; // Dịch trái 1 bit (nhân đôi)
            done     <= 1'b1;         // Báo hiệu đã xử lý xong
        end else begin
            done     <= 1'b0;         // Tự động tắt done sau 1 chu kỳ
        end
    end

endmodule