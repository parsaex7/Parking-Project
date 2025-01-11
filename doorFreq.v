module doorFreq(
    input clk,
    input rst,
    input car_in,
    input car_out,
    output reg door_open
);

    reg flag = 1'b0;
    reg [25:0] cnt = 0;
    reg [25:0] repeatCnt = 0;

    parameter clk_freq = 1000;
    parameter targetFreq = 2;
    parameter cycle = clk_freq / targetFreq;
    parameter toggle = cycle / 2;
    parameter blink = 80;



    always @(posedge rst or posedge clk)
    begin
        if (rst) 
        begin
            cnt <= 0;
            door_open <= 0;
            flag <= 1'b0;
            repeatCnt <= 0;
        end
        else if ((car_in || car_out) && ~flag) 
        begin
            flag <= 1;
            cnt <= 0;
            door_open <= 1;
        end 
        
        if (flag && (repeatCnt == blink))
        begin
            flag <= 0;
            repeatCnt <= 0;
            cnt <= 0;
            door_open <= 0;
        end 
        else if (flag)
        begin
            if (cnt == toggle)
            begin
                door_open <= ~door_open;
                repeatCnt <= repeatCnt + 1;
                cnt <= 0;
            end
            else
            begin
                cnt <= cnt + 1;
            end
        end
        else 
        begin
            flag <= 0;
            repeatCnt <= 0;
            cnt <= 0;
            door_open <= 0;
        end
    end
endmodule