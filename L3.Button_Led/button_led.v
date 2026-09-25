module button_led(
	input wire [3:0] btn,   // Mảng 4 nút nhấn
	output wire [3:0] led   // Mảng 4 bóng LED
);
	assign led = btn;       // Nút nào sáng LED đó tương ứng
endmodule