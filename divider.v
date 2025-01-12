module divider (
    input wire clk,
    input wire reset,
    output reg clk_1kHz,
    output reg clk_250Hz
);

parameter clkFerq = 40000000; // 40 MHz

parameter targetFreq_1kHz = 1000; // 1 kHz
parameter cycle_1kHz = clkFerq / targetFreq_1kHz;
parameter toggles_1kHz = cycle_1kHz / 2;

parameter targetFreq_250Hz = 250; // 250 Hz
parameter cycle_250Hz = clkFerq / targetFreq_250Hz;
parameter toggles_250Hz = cycle_250Hz / 2;

reg [25:0] cnt_1kHz;
reg [25:0] cnt_250Hz;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        cnt_1kHz <= 0;
        clk_1kHz <= 0;
        cnt_250Hz <= 0;
        clk_250Hz <= 0;
    end else begin
        // 1 kHz clock
        if (cnt_1kHz < cycle_1kHz - 1) begin
            cnt_1kHz <= cnt_1kHz + 1;
        end else begin
            cnt_1kHz <= 0;
            clk_1kHz <= ~clk_1kHz;
        end

        // 250 Hz clock
        if (cnt_250Hz < cycle_250Hz - 1) begin
            cnt_250Hz <= cnt_250Hz + 1;
        end else begin
            cnt_250Hz <= 0;
            clk_250Hz <= ~clk_250Hz;
        end
    end
end

endmodule