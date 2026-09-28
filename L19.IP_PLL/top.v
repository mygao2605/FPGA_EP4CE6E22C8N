module top (
    input  wire clk_100m,
    output wire LED0,
    output wire LED1,
    output wire LED2,
    output wire LED3
);

wire clk_50m;
wire clk_25m;
wire clk_10m;
wire clk_5m;
wire pll_locked;

clk u_pll (
    .inclk0 (clk_100m),
    .c0     (clk_50m),
    .c1     (clk_25m),
    .c2     (clk_10m),
    .c3     (clk_5m),
    .locked (pll_locked)
);

reg [25:0] counter0;
reg [24:0] counter1;
reg [23:0] counter2;
reg [22:0] counter3;

always @(posedge clk_50m) begin
    if (!pll_locked)
        counter0 <= 0;
    else
        counter0 <= counter0 + 1'b1;
end

always @(posedge clk_25m) begin
    if (!pll_locked)
        counter1 <= 0;
    else
        counter1 <= counter1 + 1'b1;
end

always @(posedge clk_10m) begin
    if (!pll_locked)
        counter2 <= 0;
    else
        counter2 <= counter2 + 1'b1;
end

always @(posedge clk_5m) begin
    if (!pll_locked)
        counter3 <= 0;
    else
        counter3 <= counter3 + 1'b1;
end

assign LED0 = counter0[25];
assign LED1 = counter1[24];
assign LED2 = counter2[23];
assign LED3 = counter3[22];

endmodule