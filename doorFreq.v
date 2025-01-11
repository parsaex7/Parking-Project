module doorFreq(
    input clk,
    input rst,
    input car_in,
    input car_out,
    output reg door_open
);

    reg tmp = 1'b0;
    reg [6:0] cnt = 7'b0000000;
    always @(posedge rst or posedge clk or posedge car_in or posedge car_out)
    begin
        if (rst) 
        begin
            cnt <= 7'b0000000;
            door_open <= 0;
            tmp <= 1'b0;
        end
        else if ((car_in || car_out) && ~tmp) 
        begin
            tmp <= 1;
            cnt <= 0;
            door_open <= 1;
        end 
        if (tmp && cnt < 7'b1010000) // 80 toggle  because the clock frequency is 4Hz
        begin
            door_open <= ~door_open;
            cnt <= cnt + 1;
        end
        else if (cnt == 7'b1010000)
        begin
            cnt <= 7'b0000000;
            door_open <= 0;
            tmp <= 0;
        end
    end
endmodule