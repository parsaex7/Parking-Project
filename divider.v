module divider (
    input wire clk,
    input wire reset,
    output reg clk_1hz,
    output reg clk_4hz,
    output reg clk_1kHz,
    output reg clk_60Hz
);

parameter clkFerq = 40000000; //40MHz
parameter targetFreq_4hz = 4;  // 4Hz
parameter cycle_4hz = clkFerq / targetFreq_4hz;
parameter toggles_4hz = cycle_4hz / 2;
parameter targetFreq_1kHz = 1000;  // 1kHz
parameter cycle_1kHz = clkFerq / targetFreq_1kHz;
parameter toggles_1kHz = cycle_1kHz / 2;
parameter targetFreq_60Hz = 60;  // 60Hz
parameter cycle_60Hz = clkFerq / targetFreq_60Hz;
parameter toggles_60Hz = cycle_60Hz / 2;
parameter targetFreq_1hz = 1;
parameter cycle_1hz = clkFerq / targetFreq_1hz;
parameter toggle_1hz = cycle_1hz / 2;

reg [25:0] cnt_4hz;
reg [25:0] cnt_1kHz;
reg [25:0] cnt_60Hz;
reg [25:0] cnt_1hz;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        cnt_4hz <= 0;
        clk_4hz <= 0;
        cnt_1kHz <= 0;
        clk_1kHz <= 0;
        cnt_60Hz <= 0;
        clk_60Hz <= 0;
        cnt_1hz <= 0;
        clk_1hz <= 0;
    end else
    begin
        if (cnt_4hz < cycle_4hz - 1) 
        begin
            cnt_4hz <= cnt_4hz + 1;
        end 
        else 
        begin
            cnt_4hz <= 0;
            clk_4hz <= ~clk_4hz;
        end

        if (cnt_1kHz < cycle_1kHz - 1) 
        begin
            cnt_1kHz <= cnt_1kHz + 1;
        end 
        else 
        begin
            cnt_1kHz <= 0;
            clk_1kHz <= ~clk_1kHz;
        end

        if (cnt_60Hz < cycle_60Hz - 1) 
        begin
            cnt_60Hz <= cnt_60Hz + 1;
        end 
        else
        begin
            cnt_60Hz <= 0;
            clk_60Hz <= ~clk_60Hz;
        end

        if (cnt_1hz < cycle_1hz - 1) 
        begin
            cnt_1hz <= cnt_1hz + 1;
        end 
        else 
        begin
            cnt_1hz <= 0;
            clk_1hz <= ~clk_1hz;
        end
    end
end

endmodule