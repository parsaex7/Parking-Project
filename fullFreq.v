module fullFreq(
    input clk,
    input rst,
    input full_garage,
    output reg full_signal
);

parameter clk_freq = 1000;
parameter targetFreq = 0.5;
parameter cycle = clk_freq / targetFreq;
parameter toggle = cycle / 2;
parameter blink = 3;

reg flag;
reg [25:0] repeatCnt;
reg [25:0] cnt;

always @(posedge rst or posedge clk)
begin
    if (rst)
    begin
        flag <= 1'b0;
        cnt <= 0;
        repeatCnt <= 0;
    end
    else 
    begin
        if (full_garage && ~flag)
        begin
            flag <= 1'b1;
            cnt <= 0;
            full_signal <= 1'b1;
            repeatCnt <= 0;
        end
        if (flag && (repeatCnt == blink))
        begin
            cnt <= 0;
            full_signal <= 1'b0;
            flag <= 0;
            repeatCnt <= 0;
        end
        else if (flag)
        begin
            if (cnt == toggle)
            begin
                full_signal <= ~full_signal;
                repeatCnt <= repeatCnt + 1;
                cnt <= 0;
            end
        end
        else 
        begin
            cnt <= 0;
            full_signal <= 1'b0;
            flag <= 0;
            repeatCnt <= 0;
        end
    end
end

endmodule