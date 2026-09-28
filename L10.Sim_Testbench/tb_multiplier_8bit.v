`timescale 1ns / 1ps // Đơn vị thời gian 1ns, độ chính xác 1ps

module tb_multiplier_8bit;

    // 1. Khai báo tín hiệu trung gian (reg cho input, wire cho output)
    reg clk;
    reg rst_n;
    reg start;
    reg [7:0] data_in;
    
    wire [7:0] data_out;
    wire done;

    // 2. Kết nối DUT (Device Under Test) - Nối chân module với biến testbench
    multiplier_8bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    // 3. Tạo xung Clock tự động (chu kỳ 10ns -> tần số 100MHz)
    initial clk = 0;
    always #5 clk = ~clk; // Cứ mỗi 5ns thì đảo trạng thái 1 lần

    // 4. Kịch bản kiểm thử (Stimulus)
    initial begin
        // --- Bước A: Khởi tạo giá trị ban đầu ---
        rst_n   = 0;
        start   = 0;
        data_in = 8'h00;
        
        // --- Bước B: Chờ 20ns rồi thả reset ---
        #20;
        rst_n = 1;
        #10;

        // --- Bước C: Testcase 1 (Truyền giá trị 0x05 -> kỳ vọng ra 0x0A) ---
        data_in = 8'h05;
        start   = 1;        // Bật tín hiệu kích hoạt
        #10;                // Giữ start trong 1 chu kỳ clock (10ns)
        start   = 0;        // Tắt start
        
        #20;                // Chờ một chút để xem kết quả xuất ra

        // --- Bước D: Testcase 2 (Truyền giá trị 0x3C -> kỳ vọng ra 0x78) ---
        data_in = 8'h3C;
        start   = 1;
        #10;
        start   = 0;
        
        #20;

        // --- Bước E: Testcase 3 (Truyền dữ liệu biên 0x80 -> kỳ vọng ra 0x00, tràn bit) ---
        data_in = 8'h80;
        start   = 1;
        #10;
        start   = 0;
        
        #30;

        // --- Bước F: Kết thúc mô phỏng ---
        $finish;
    end

    // 5. Theo dõi kết quả trực tiếp trên cửa sổ Transcript của ModelSim
    initial begin
        $monitor("Time=%0t ns | rst_n=%b | start=%b | data_in=0x%h | data_out=0x%h | done=%b", 
                 $time, rst_n, start, data_in, data_out, done);
    end

endmodule