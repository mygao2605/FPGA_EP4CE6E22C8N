# Lộ Trình Học Thiết Kế Vi Mạch FPGA Từ Cơ Bản Đến Nâng Cao
> **Nền tảng thực hành:** Kit Altera Cyclone IV (`EP4CE6E22C8N`) & Phần mềm **Intel Quartus Prime + ModelSim**.

---

## 🎯 Tư Duy Cốt Lõi Khi Học FPGA

> **QUAN TRỌNG NHẤT:** 
> **Verilog/VHDL không phải là ngôn ngữ lập trình phần mềm (như C, Python, Java).**
> * Đây là **Ngôn ngữ Mô tả Phần cứng (Hardware Description Language - HDL)**.
> * Bạn không viết các dòng lệnh để CPU chạy tuần tự từng dòng, mà bạn đang **vẽ nên sơ đồ mạch điện vật lý** (cổng logic, dây dẫn, Flip-Flop, thanh ghi) hoạt động **song song (parallel)** trong không gian chip.

---

## 🗺️ Bản Đồ Lộ Trình (Roadmap Overview)

```
[Giai đoạn 1: Nền tảng số & Cú pháp Verilog]
                    │
                    ▼
[Giai đoạn 2: FSM & Kỹ năng Viết Testbench Mô phỏng]
                    │
                    ▼
[Giai đoạn 3: Các chuẩn Giao tiếp Nối tiếp (UART, SPI, I2C)]
                    │
                    ▼
[Giai đoạn 4: Hiển thị Đồ họa & Xung nhịp Video (VGA)]
                    │
                    ▼
[Giai đoạn 5: Quản lý Xung nhịp & Bộ nhớ (PLL, BRAM, SDRAM)]
                    │
                    ▼
[Giai đoạn 6: Phân tích Thời gian (STA) & Thiết kế Nâng cao (CDC, Pipeline)]
                    │
                    ▼
[Giai đoạn 7: Hệ thống trên Chip (SoPC - Nios II / RISC-V)]
```

---

## 📚 Chi Tiết Từng Giai Đoạn

### Giai Đoạn 1: Nền Tảng Số & Verilog Cơ Bản (2 - 3 tuần)

**Mục tiêu:** Hiểu rõ cách mô tả mạch tổ hợp và mạch tuần tự cơ bản; làm chủ luồng biên dịch và nạp chip trên Quartus Prime.

* **Kiến thức cần học:**
  * Đại số Boole, bảng chân lý, các cổng logic cơ bản (AND, OR, NOT, XOR).
  * Khái niệm mức tích cực (Active-High, Active-Low) trên phần cứng.
  * Phân biệt rõ kiểu `wire` (dây nối) và `reg` (thanh ghi lưu trữ).
  * Mạch tổ hợp (`assign`, `always @(*)`) và phép gán **Blocking (`=`)**.
  * Mạch tuần tự (`always @(posedge clk)`) và phép gán **Non-blocking (`<=`)**.
  * Thiết kế bộ đếm thời gian (Counter / Clock Divider) từ xung 50 MHz.
  * Kỹ thuật **Chống rung phím (Button Debouncing)** bằng phần cứng.
* **Bài tập / Project thực hành:**
  - [x] **L1.LED**: Bật tắt LED tĩnh, hiểu mức logic Active-Low.
  - [x] **L2.BlinkLed**: Nhấp nháy LED chu kỳ 1s bằng bộ đếm chia xung 50 MHz.
  - [ ] **L3.Button_Led**: Đọc trạng thái nút bấm (Key) để đảo trạng thái LED.
  - [ ] **L4.Button_Debounce**: Viết module lọc nhiễu rung phím vật lý (dùng bộ đếm trễ 20ms).
  - [ ] **L5.Water_Led**: Hiệu ứng LED sáng dồn, LED chạy qua lại (Shift Register / Chạy LED 4 kênh).
  - [ ] **L6.Seg7_Display**: Giải mã và quét động LED 7 đoạn (Multiplexing display 4 số).

---

### Giai Đoạn 2: Máy Trạng Thái Hữu Hạn & Mô Phỏng Testbench (2 - 3 tuần)

**Mục tiêu:** Nắm vững FSM – "linh hồn" của kiến trúc điều khiển trong FPGA; thành thạo mô phỏng trên ModelSim/QuestaSim trước khi nạp xuống mạch thật.

* **Kiến thức cần học:**
  * Khái niệm **Finite State Machine (FSM)**: Máy Moore (ngõ ra chỉ phụ thuộc trạng thái hiện tại) vs Máy Mealy (ngõ ra phụ thuộc cả trạng thái hiện tại và ngõ vào).
  * Quy chuẩn viết FSM chuyên nghiệp: Phong cách **3 khối `always`** (1: chuyển trạng thái theo clock, 2: tổ hợp tính trạng thái kế tiếp, 3: tính ngõ ra).
  * Kỹ thuật viết **Testbench (TB)** Verilog:
    * Khối `initial`, hàm tạo xung clock `#10 clk = ~clk;`, kích xung reset.
    * Các system tasks: `$display`, `$monitor`, `$time`, `$finish`.
  * Cách liên kết Quartus Prime với ModelSim để chạy mô phỏng dạng sóng (Waveform).
* **Bài tập / Project thực hành:**
  - [ ] **L7.Traffic_Light**: Mạch điều khiển đèn giao thông ngã tư (Đỏ - Vàng - Xanh) bằng FSM 3-always.
  - [ ] **L8.Buzzer_PWM**: Điều khiển còi buzzer phát âm thanh các nốt nhạc (Do, Re, Mi...) bằng điều chế độ rộng xung PWM.
  - [ ] **L9.Stopwatch**: Đồng hồ bấm giờ hiển thị LED 7 đoạn có nút Start/Stop/Reset (sử dụng FSM).
  - [ ] **L10.Sim_Testbench**: Viết file testbench mô phỏng kiểm thử toàn bộ chức năng của module đếm và FSM trên ModelSim.

---

### Giai Đoạn 3: Giao Tiếp Nối Tiếp Ngoại Vi (3 - 4 tuần)

**Mục tiêu:** Tự tay thiết kế các bộ điều khiển giao thức truyền thông chuẩn công nghiệp mà không dùng thư viện có sẵn.

* **Kiến thức cần học:**
  * **UART (Universal Asynchronous Receiver-Transmitter)**:
    * Khung truyền: Start bit, 8 data bits, Parity bit, Stop bit.
    * Bộ tạo Baud rate (9600, 115200 bps) từ clock 50 MHz.
    * Kỹ thuật Oversampling (lấy mẫu 16 lần) để chống nhiễu đầu nhận RX.
  * **SPI (Serial Peripheral Interface)**:
    * 4 đường tín hiệu: SCLK, MOSI, MISO, CS.
    * 4 chế độ hoạt động (CPOL, CPHA).
  * **I2C (Inter-Integrated Circuit)**:
    * 2 đường tín hiệu Open-drain: SCL, SDA (yêu cầu điện trở kéo lên Pull-up).
    * Điều kiện START, STOP, ACK, NACK, cơ chế kiểm soát hai chiều (inout).
* **Bài tập / Project thực hành:**
  - [ ] **L11.UART_TX**: Gửi ký tự hoặc chuỗi chuỗi "HELLO FPGA" lên máy tính qua cổng COM (UART-USB).
  - [ ] **L12.UART_RX**: Nhận ký tự từ bàn phím máy tính gửi xuống để điều khiển bật/tắt 4 LED.
  - [ ] **L13.UART_Loopback**: Nhận dữ liệu gì từ máy tính thì gửi trả lại nguyên vẹn (Echo test).
  - [ ] **L14.I2C_EEPROM**: Đọc và ghi dữ liệu vào IC nhớ EEPROM `AT24C02` trên kit.
  - [ ] **L15.SPI_Flash**: Đọc thông tin Device ID của chip Flash SPI trên kit.

---

### Giai Đoạn 4: Hiển Thị Đồ Họa & Video Timing (VGA) (2 - 3 tuần)

**Mục tiêu:** Làm chủ xung nhịp video độ chính xác cao và hiểu cách điều khiển luồng dữ liệu pixel thời gian thực.

* **Kiến thức cần học:**
  * Chuẩn tín hiệu VGA: Phân giải 640x480 @ 60Hz.
  * Các khoảng thời gian quét: Active Video, Front Porch, Sync Pulse, Back Porch của cả chiều ngang (HSYNC) và chiều dọc (VSYNC).
  * Bộ chia tần số tạo Pixel Clock chuẩn ($25.175\text{ MHz}$ hoặc lấy xấp xỉ $25\text{ MHz}$).
  * Thiết kế Bộ sinh màu và hiển thị ký tự (Character ROM / Font matrix).
* **Bài tập / Project thực hành:**
  - [ ] **L16.VGA_ColorBar**: Xuất 8 dải màu chuẩn (Color Bars) lên màn hình máy tính qua cổng VGA.
  - [ ] **L17.VGA_Moving_Box**: Tạo một hình vuông tự di chuyển và va đập nảy lại khi chạm các cạnh màn hình.
  - [ ] **L18.Game_Pong**: Thiết kế trò chơi bóng bàn Pong cổ điển: Dùng nút bấm điều khiển thanh gạt đỡ bóng, xuất hình ảnh ra màn hình VGA.

---

### Giai Đoạn 5: Quản Lý Clock & Khai Thác Bộ Nhớ (PLL, BRAM, SDRAM) (3 - 4 tuần)

**Mục tiêu:** Sử dụng tài nguyên chuyên dụng của FPGA (IP Cores, Block RAM) và giao tiếp bộ nhớ tốc độ cao.

* **Kiến thức cần học:**
  * **IP Cores của Altera**: Sử dụng IP Catalog trong Quartus để gọi module phần cứng tối ưu:
    * **ALTPLL**: Nhân xung/chia xung chính xác cao (ví dụ: tạo clock 25MHz cho VGA, 100MHz cho SDRAM, 133MHz...).
    * **RAM: 1-PORT / 2-PORT (Block RAM - M9K)**: Lưu trữ dữ liệu nội bộ tốc độ cao.
    * **ROM: 1-PORT**: Lưu dữ liệu tĩnh (bảng sin sóng, font chữ, mã hình ảnh).
  * **FIFO (First-In, First-Out)**:
    * FIFO đồng bộ (Synchronous FIFO).
    * FIFO bất đồng bộ (Asynchronous FIFO) dùng mã Gray để chuyển dữ liệu an toàn giữa 2 xung clock khác nhau.
  * **Bộ nhớ ngoài SDRAM**:
    * Kiến trúc bộ nhớ SDRAM (Banks, Rows, Columns).
    * Chu kỳ nạp lệnh, kích hoạt hàng (ACT), đọc/ghi (READ/WRITE), Auto-Refresh.
* **Bài tập / Project thực hành:**
  - [ ] **L19.IP_PLL**: Dùng ALTPLL biến đổi xung 50 MHz thành nhiều tần số đồng thời: 25 MHz, 100 MHz, 10 MHz.
  - [ ] **L20.IP_RAM_FIFO**: Thiết kế hàng đợi dữ liệu UART RX dùng FIFO đệm tránh mất gói tin khi truyền tốc độ cao.
  - [ ] **L21.SDRAM_Controller**: Viết hoặc cấu hình controller đọc/ghi dữ liệu vào chip SDRAM trên kit.
  - [ ] **L22.VGA_FrameBuffer**: Lưu dữ liệu ảnh từ PC gửi qua UART vào SDRAM, sau đó đọc SDRAM xuất ra màn hình VGA.

---

### Giai Đoạn 6: Phân Tích Thời Gian (STA) & Thiết Kế Nâng Cao (3 - 4 tuần)

**Mục tiêu:** Chuyển từ người "viết code cho mạch chạy được" sang "kỹ sư thiết kế vi mạch chuyên nghiệp" với khả năng tối ưu tần số và timing.

* **Kiến thức cần học:**
  * **Static Timing Analysis (STA)**:
    * Định nghĩa: Setup Time ($T_{su}$), Hold Time ($T_h$), Clock Skew, Clock Jitter.
    * Khái niệm Slack: Setup Slack (ảnh hưởng tần số tối đa $F_{max}$), Hold Slack (ảnh hưởng tính đúng đắn dữ liệu).
    * File ràng buộc thời gian **`.sdc`** (Synopsys Design Constraints) trong công cụ **TimeQuest Timing Analyzer**:
      * `create_clock -period 20.000 [get_ports CLK]`
      * `derive_pll_clocks`
  * **Metastability (Hiện tượng giả ổn định)** và giải pháp:
    * Thiết kế mạch đồng bộ 2 tầng Flip-Flop (Two-flop synchronizer) cho tín hiệu 1-bit.
  * **Clock Domain Crossing (CDC)**:
    * Quy tắc chuyển tín hiệu an toàn giữa các miền clock không đồng bộ.
  * **Kỹ thuật Đường ống (Pipelining)**:
    * Chèn các thanh ghi trung gian để bẻ nhỏ đường truyền trễ logic dài (critical path), giúp tăng vọt tần số hoạt động ($F_{max}$).
* **Bài tập / Project thực hành:**
  - [ ] **L23.SDC_Constraint**: Thêm ràng buộc thời gian SDC cho project và sửa các lỗi Timing Violation (Slack âm).
  - [ ] **L24.Pipelined_Multiplier**: So sánh bộ nhân tính toán 32-bit không pipelined vs có 4 tầng pipeline về diện tích LEs và $F_{max}$.

---

### Giai Đoạn 7: Hệ Thống Trên Chip (SoPC) & Bộ Xử Lý Nhúng (4+ tuần)

**Mục tiêu:** Xây dựng một máy tính hoàn chỉnh bên trong chip FPGA kết hợp sức mạnh linh hoạt của phần mềm (C) với tốc độ của phần cứng tùy biến.

* **Kiến thức cần học:**
  * Kiến trúc bus trên chip **Avalon-MM (Memory Mapped)** và **Avalon-ST (Streaming)**.
  * Sử dụng công cụ **Platform Designer (Qsys)** của Intel:
    * Tích hợp vi xử lý mềm **Nios II** 32-bit.
    * Kết nối ngoại vi: On-chip RAM, SDRAM Controller, UART JTAG, PIO (GPIO), Timer.
  * Lập trình firmware C trên **Nios II Software Build Tools (Eclipse/VSCode)**.
  * Tự tạo **Custom IP Core**: Đóng gói khối logic Verilog của mình thành một ngoại vi kết nối vào bus Avalon để CPU Nios II điều khiển qua địa chỉ ghi nhớ.
  * *(Nâng cao tùy chọn)*: Tìm hiểu tích hợp vi xử lý mã nguồn mở **RISC-V** (như PicoRV32, FemtoRV) lên kit Cyclone IV.
* **Bài tập / Project thực hành:**
  - [ ] **L25.Hello_NiosII**: Tạo hệ thống SoPC tối thiểu với Nios II, On-chip Memory, JTAG UART và chạy chương trình "Hello World" in ra console.
  - [ ] **L26.NiosII_Peripheral**: Dùng code C trên Nios II điều khiển đọc phím bấm và chớp tắt LED.
  - [ ] **L27.Custom_IP_Hardware_Accelerator**: Viết module tăng tốc thuật toán (như mã hóa AES hoặc tính toán bộ lọc ảnh) bằng Verilog, ghép vào Nios II để tăng tốc xử lý so với chạy bằng phần mềm thuần.

---

## 🛠️ Bộ Công Cụ & Mẹo Học Hiệu Quả

### 1. Phần mềm cần cài đặt
* **Intel Quartus Prime Lite Edition** (Bản 18.1 hoặc 20.1 - miễn phí, hỗ trợ đầy đủ dòng Cyclone IV).
* **ModelSim-Intel FPGA Edition** hoặc **QuestaSim** (dùng để mô phỏng waveforms).
* **Driver USB-Blaster** (cần cài đặt driver trong thư mục `quartus/drivers`).

### 2. Các thói quen tốt cần rèn luyện
1. **Luôn mô phỏng trước:** Đừng vội nạp code xuống chip khi chưa chạy Testbench. Tìm lỗi trên dạng sóng ModelSim nhanh hơn gấp 10 lần việc ngồi nhìn LED trên kit để đoán lỗi.
2. **Không bao giờ tạo Latch ngoài ý muốn:** Trong mạch tổ hợp `always @(*)`, nếu dùng `if` thì phải có đầy đủ `else`, nếu dùng `case` thì luôn có `default`.
3. **Chỉ dùng một Clock chính:** Hạn chế tối đa việc dùng ngõ ra của logic tổ hợp để làm clock cho khối khác (Gated Clock). Hãy dùng cờ cho phép (Clock Enable) hoặc PLL.
4. **Nhất quán quy tắc gán:**
   * Mạch tổ hợp: Luôn dùng `=`.
   * Mạch tuần tự: Luôn dùng `<=`.
   * **Tuyệt đối không** trộn lẫn cả hai trong cùng một khối `always`.

---

## 📖 Tài Liệu Tham Khảo Khuyên Đọc

1. **Sách:**
   * *Verilog HDL: A Guide to Digital Design and Synthesis* - Samir Palnitkar (Sách gối đầu giường về cú pháp Verilog).
   * *FPGA Prototyping by Verilog Examples* - Pong P. Chu (Cực kỳ thực tế, có các bài về UART, VGA, PS2).
   * *Design Through Verilog HDL* - T. R. Padmanabhan.
2. **Trang web học tập & Thực hành:**
   * [HDLBits](https://hdlbits.01xz.net/) - Trang web luyện tập viết Verilog online có chấm bài tự động hay nhất hiện nay.
   * [Nandland](https://nandland.com/) - Các bài hướng dẫn cơ bản cực kỳ dễ hiểu về FPGA và Verilog.
   * [ASIC World](https://www.asic-world.com/) - Tra cứu toàn diện cú pháp và ví dụ Verilog.
