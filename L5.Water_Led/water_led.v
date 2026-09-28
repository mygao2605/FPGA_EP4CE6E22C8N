module water_led(
    input  wire       clk,       // Clock gốc của kit (ví dụ: 50MHz)
    output reg  [3:0] led = 4'b1000 // Khởi tạo ban đầu
);

    // Khai báo biến đếm chia tần
    reg [25:0] div_cnt = 0;

    always @(posedge clk) begin
        div_cnt <= div_cnt + 1;
        
        // Tạo một nhịp (tick) chậm khoảng 0.5 giây (với clk 50MHz thì 25,000,000 chu kỳ)
        if (div_cnt == 26'd25_000_000) begin
            div_cnt <= 0; // Reset lại bộ đếm
            
            // Thực hiện dịch LED khi đến nhịp
            if (led == 4'b0000 || led > 4'b1111) begin
                led <= 4'b1000;          
            end else begin
                led <= {led[2:0], led[3]}; 
            end
        end
    end

endmodule