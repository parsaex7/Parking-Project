module fullFreq(
    input clk,
    input rst,
    input full_garage,
    output reg full_signal
);

reg tmp;
reg cnt[3:0];

always @(posedge rst or posedge clk or posedge full_garage) 
begin
    if (rst)
    begin
        tmp <= 1'b0;
        cnt <= 4'b0000;
    end
    if (full_garage)
    begin
        tmp <= 1'b1;
    end
    if (tmp && cnt < 4'b0011)
    begin
        cnt <= cnt + 1;
        full_signal <= ~full;
    end 
    else
    begin
        cnt <= 0;
        tmp <= 0;
        full_signal <= 1'b0;
    end
end

endmodule