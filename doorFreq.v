module doorFreq(
    input clk,
    input rst,
    input car_in,
    output reg door_open
);
    reg tmp = 1'b0;
    reg cnt[6:0] = 7'b0000000;
    always @(posedge rst or posedge car_in or clk)
    begin
        if (rst) 
        begin
            cnt <= 7'b0000000;
            door_open <= 0;
            tmp = 1'b0;
        end
        else if (car_in)
        begin
            tmp = 1;
        end
        if (tmp && cnt < 7'b1010000)
        begin
            door_open <= ~door_open;
            cnt <= cnt + 1;
        end
        else if (cnt >= 7'b1010000)
        begin
            cnt <= 7'b0000000;
            door_open <= 0;
            tmp <= 0;
        end
    end
endmodule