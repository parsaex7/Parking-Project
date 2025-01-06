module divider (
    input wire clk,
    input wire reset,
    output reg clk_out
);

parameter clkFerq = 40000000; //40MHz
parameter targetFreq = 4;  // 4Hz
parameter cycle = clkFerq / targetFreq;
parameter toggles = cycle / 2;

reg [25:0] cnt;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        cnt <= 0;
        clk_out <= 0;
    end else
    begin
        cnt <= cnt + 1;
        if (cnt == toggles)
        begin
            cnt <= 0;
            clk_out <= ~clk_out;
        end
    end
end

endmodule