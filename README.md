# FPGA Altera Cyclone IV - EP4CE6E22C8N

Tài liệu ghi chú kiến thức cơ bản về lập trình FPGA với Verilog HDL và hướng dẫn thực hành trên kit **Altera Cyclone IV (EP4CE6E22C8N)**.

---

## 1. Thông tin phần cứng Kit EP4CE6E22C8N

* **Chip FPGA**: Cyclone IV `EP4CE6E22C8N` (gói QFP 144 chân).
* **Xung nhịp Clock hệ thống**: Thạch anh **50 MHz** (chu kỳ $T = 20\text{ ns}$) nối vào chân **`PIN_23`**.
* **Đèn LED đơn (Active-Low)**:
  * `LED1` -> **`PIN_84`**
  * `LED2` -> **`PIN_85`**
  * `LED3` -> **`PIN_86`**
  * `LED4` -> **`PIN_87`**
  > **Lưu ý mức logic (Active-Low):**
  > * Xuất mức `0` (`1'b0`): LED **Sáng**.
  > * Xuất mức `1` (`1'b1`): LED **Tắt**.

---

## 2. Kiến thức Verilog cơ bản

### 2.1. Cấu trúc một Module Verilog

```verilog
module ten_module (
    input  wire       clk,        // Đầu vào xung clock
    input  wire       rst_n,      // Đầu vào reset (thường là tích cực mức thấp - active low)
    input  wire [3:0] sw,         // Đầu vào bus 4-bit switch
    output reg  [3:0] led         // Đầu ra bus 4-bit điều khiển LED
);

    // 1. Khai báo dây (wire) và thanh ghi (reg) nội bộ
    wire tin_hieu_to_hop;
    reg  [24:0] counter;

    // 2. Mạch tổ hợp (Combinational Logic)
    assign tin_hieu_to_hop = sw[0] & sw[1];

    // 3. Mạch tuần tự (Sequential Logic)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 25'd0;
            led     <= 4'b1111;   // Tắt hết LED khi reset
        end else begin
            // Thao tác logic theo xung clock
        end
    end

endmodule
```

---

### 2.2. Phân biệt `wire` và `reg`

| Đặc điểm | `wire` (Dây dẫn) | `reg` (Thanh ghi logic) |
| :--- | :--- | :--- |
| **Bản chất** | Kết nối vật lý thuần túy, không có khả năng lưu trữ. | Biểu diễn phần tử có khả năng lưu giữ trạng thái trong mô phỏng (tổng hợp ra Flip-Flop hoặc Latch). |
| **Nơi gán giá trị** | Dùng với lệnh gán liên tục `assign` hoặc nối ngõ ra của module con. | **Chỉ được gán** bên trong khối `always` hoặc `initial`. |
| **Ví dụ khai báo** | `wire clk_out;` <br> `assign clk_out = a & b;` | `reg [7:0] data;` <br> `always @(...) data <= ...;` |

---

### 2.3. Hai loại mạch logic cốt lõi

#### a) Mạch tổ hợp (Combinational Logic)
* Ngõ ra phụ thuộc ngay lập tức vào ngõ vào hiện tại, **không phụ thuộc xung Clock**.
* Cách viết 1: Dùng lệnh `assign`:
  ```verilog
  assign led_out = ~btn_in;
  ```
* Cách viết 2: Dùng `always @(*)` với phép gán Blocking (`=`):
  ```verilog
  always @(*) begin
      if (sel == 1'b1)
          out = in_a;
      else
          out = in_b;
  end
  ```

#### b) Mạch tuần tự (Sequential Logic)
* Hoạt động đồng bộ theo sườn xung Clock (`posedge clk` hoặc `negedge clk`).
* Dùng để lưu trữ trạng thái, thanh ghi, bộ đếm, FSM.
* **Bắt buộc** dùng phép gán Non-blocking (`<=`):
  ```verilog
  always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          q <= 1'b0;
      end else begin
          q <= d;
      end
  end
  ```

---

### 2.4. Phép gán Blocking (`=`) vs Non-blocking (`<=`)

* **Blocking (`=`)**:
  * Thực thi tuần tự từ trên xuống dưới (dòng sau đợi dòng trước hoàn tất).
  * **Quy tắc:** Chỉ dùng cho **Mạch tổ hợp** (trong khối `always @(*)`).
* **Non-blocking (`<=`)**:
  * Tất cả các phép gán trong cùng một chu kỳ clock được chốt giá trị và cập nhật đồng thời (song song), mô phỏng đúng hành vi của Flip-Flop phần cứng.
  * **Quy tắc:** Luôn dùng cho **Mạch tuần tự** (trong khối `always @(posedge clk)`).

---

### 2.5. Mẫu bộ chia tần số / Bộ đếm xung (Clock Divider / Counter)

Với tần số đầu vào **50 MHz** ($50.000.000\text{ Hz}$):
* Số xung trong $0.5\text{ giây}$: $\frac{50.000.000}{2} = 25.000.000\text{ chu kỳ}$.
* Cần thanh ghi có độ rộng tối thiểu để chứa được $25.000.000$: $2^{25} = 33.554.432 > 25.000.000 \implies$ chọn `reg [24:0] counter;`.

```verilog
reg [24:0] counter;

// Đếm từ 0 đến 24_999_999 (đủ 25 triệu chu kỳ = 0.5s đảo LED 1 lần => chu kỳ nháy 1s)
always @(posedge clk) begin
    if (counter == 25'd24_999_999) begin
        counter <= 25'd0;
        led     <= ~led; // Đảo trạng thái LED
    end else begin
        counter <= counter + 1'b1;
    end
end
```

Công thức tính nhanh số clock N = fclock . t
Muốn 1 s vs fclk =50Mhz -> N = 50000000.1 = 50000000 

---

## 3. Quy trình thực hiện dự án trên Quartus Prime

1. **Tạo Project**: 
   * Đặt tên project và top-level module trùng nhau.
   * Chọn đúng dòng chip: **Cyclone IV E** -> Thiết bị: **`EP4CE6E22C8`**.
2. **Viết mã nguồn**: Tạo file `.v` (Verilog HDL) và viết logic phần cứng.
3. **Phân tích cú pháp**: Chạy **Start Analysis & Elaboration** hoặc **Start Analysis & Synthesis** để kiểm tra lỗi code.
4. **Gán chân (Pin Planner)**:
   * Vào menu `Assignments` -> `Pin Planner`.
   * Gán tên cổng vào đúng các chân phần cứng (ví dụ: `CLK` -> `PIN_23`, `LED` -> `PIN_84`).
   * Chọn chuẩn điện áp I/O: **`3.3-V LVTTL`** hoặc **`3.3-V LVCMOS`**.
5. **Biên dịch toàn bộ**: Nhấn **Start Compilation** (Ctrl + L) để tổng hợp, định tuyến và sinh file nạp `.sof`.
6. **Nạp chương trình (Programmer)**:
   * Mở công cụ **Programmer**.
   * Nhấn **Hardware Setup** -> Chọn mạch nạp **USB-Blaster**.
   * **Nạp tạm thời (SRAM)**: Nạp file `.sof` (mất code khi tắt nguồn).
   * **Nạp vĩnh viễn (Flash EPCS)**: Convert file `.sof` sang file `.jic` thông qua `File -> Convert Programming Files`, sau đó nạp vào chip Flash để giữ chương trình sau khi mất điện.

---

## 4. Các bài thực hành trong Repository

* **`L1.LED`**: Điều khiển bật/tắt LED tĩnh, làm quen với lệnh gán `assign` và mức logic Active-Low.
* **`L2.BlinkLed`**: Sử dụng xung Clock 50 MHz và khối `always @(posedge CLK)` để tạo bộ đếm nhấp nháy LED theo chu kỳ thời gian thực.


