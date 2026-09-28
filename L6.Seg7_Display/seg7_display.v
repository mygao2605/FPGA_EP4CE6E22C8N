module seg7_display(
    input wire clk,          // Clock gốc (ví dụ: 50MHz)
    output reg [7:0] seg,    // Các thanh a, b, c, d, e, f, g, dp
    output reg [3:0] dig     // Chọn digit (quét 4 chữ số)
);

    // 1. Bộ chia tần tạo tần số quét LED (vài trăm Hz để không bị nhấp nháy)
    reg [17:0] refresh_cnt = 0;
    always @(posedge clk) begin
        refresh_cnt <= refresh_cnt + 1;
    end
    wire scan_clk = refresh_cnt[17]; 

    // 2. Bộ chia tần tạo nhịp đếm 0.1 giây cho số đếm (với clk 50MHz)
    reg [25:0] sec_cnt = 0;
    reg [13:0] counter_val = 0; // Đủ chứa giá trị đến 9999 (14-bit)
    
    always @(posedge clk) begin
        if (sec_cnt == 23'd5000000-1) begin
            sec_cnt <= 0;
            if (counter_val == 14'd9999)
                counter_val <= 0;
            else
                counter_val <= counter_val + 1;
        end else begin
            sec_cnt <= sec_cnt + 1;
        end
    end

    // 3. Tách giá trị counter_val thành 4 chữ số (Ngàn, Trăm, Chục, Đơn vị)
    wire [3:0] val3 = (counter_val / 1000) % 10; // Hàng nghìn
    wire [3:0] val2 = (counter_val / 100) % 10;  // Hàng trăm
    wire [3:0] val1 = (counter_val / 10) % 10;   // Hàng chục
    wire [3:0] val0 = counter_val % 10;          // Hàng đơn vị

    // 4. Bộ đếm chọn digit hiện tại (quét qua 4 digit)
    reg [1:0] digit_sel = 0;
    always @(posedge scan_clk) begin
        digit_sel <= digit_sel + 1;
    end

    reg [3:0] current_val;

    // 5. Hàm giải mã 7 đoạn (Common Anode: mức 0 sáng, mức 1 tắt)
    function [7:0] decode_seg(input [3:0] num);
        begin
            case(num)
                4'h0: decode_seg = 8'b11000000; // Số 0
                4'h1: decode_seg = 8'b11111001; // Số 1
                4'h2: decode_seg = 8'b10100100; // Số 2
                4'h3: decode_seg = 8'b10110000; // Số 3
                4'h4: decode_seg = 8'b10011001; // Số 4
                4'h5: decode_seg = 8'b10010010; // Số 5
                4'h6: decode_seg = 8'b10000010; // Số 6
                4'h7: decode_seg = 8'b11111000; // Số 7
                4'h8: decode_seg = 8'b10000000; // Số 8
                4'h9: decode_seg = 8'b10010000; // Số 9
                default: decode_seg = 8'b11111111; // Tắt hết
            endcase
        end
    endfunction

    // 6. Khối điều khiển quét qua từng Digit
    always @(*) begin
        case(digit_sel)
            2'd0: begin
                dig = 4'b1110;           // Bật Digit 1 (Hàng đơn vị - phải cùng)
                current_val = val0;
            end
            2'd1: begin
                dig = 4'b1101;           // Bật Digit 2 (Hàng chục)
                current_val = val1;
            end
            2'd2: begin
                dig = 4'b1011;           // Bật Digit 3 (Hàng trăm)
                current_val = val2;
            end
            2'd3: begin
                dig = 4'b0111;           // Bật Digit 4 (Hàng nghìn - trái cùng)
                current_val = val3;
            end
            default: begin
                dig = 4'b1111;
                current_val = 4'd0;
            end
        endcase
        seg = decode_seg(current_val);
    end

endmodule