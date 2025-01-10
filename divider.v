module divider (
    input wire clk,
    input wire reset,
    output reg clk_out,
    output reg clk_500kHz,
    output reg clk_60Hz
);

parameter clkFerq = 40000000; //40MHz
parameter targetFreq = 4;  // 4Hz
parameter cycle = clkFerq / targetFreq;
parameter toggles = cycle / 2;
parameter targetFreq_500kHz = 500000;  // 500kHz
parameter cycle_500kHz = clkFerq / targetFreq;
parameter toggles_500kHz = cycle / 2;
parameter targetFreq_60Hz = 60;  // 60Hz
parameter cycle_60Hz = clkFerq / targetFreq;
parameter toggles_60Hz = cycle / 2;

reg [25:0] cnt;
reg [25:0] cnt_500kHz;
reg [25:0] cnt_60Hz;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        cnt <= 0;
        clk_out <= 0;
        cnt_500kHz <= 0;
        clk_500kHz <= 0;
        cnt_60Hz <= 0;
        clk_60Hz <= 0;
    end else
    begin
        cnt <= cnt + 1;
        cnt_500kHz <= cnt_500kHz + 1;
        if (cnt == toggles)
        begin
            cnt <= 0;
            clk_out <= ~clk_out;
        end
        if (cnt_500kHz == toggles_500kHz)
        begin
            cnt_500kHz <= 0;
            clk_500kHz <= ~clk_500kHz;
        end
        if (cnt_60Hz == toggles_60Hz)
        begin
            cnt_60Hz <= 0;
            clk_60Hz <= ~clk_60Hz;
        end
    end
end

endmodule