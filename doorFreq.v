module doorFreq(
    input clk,
    input rst,  
    input car_in,
    input car_out,
    output reg door_open
);

    parameter CLK_FREQ = 1000;
    parameter TOGGLE_FREQ = 4; 
    parameter TOGGLE_COUNT = CLK_FREQ / (2 * TOGGLE_FREQ);
    parameter TOTAL_TOGGLES = 40;

    reg [25:0] cnt;
    reg [6:0] toggle_counter;
    reg toggling;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            toggle_counter <= 0;
            door_open <= 0;
            toggling <= 0;
        end else begin
            if ((car_in || car_out) && !toggling) begin
                toggling <= 1;
                cnt <= 0;
                toggle_counter <= 0;
                door_open <= 1;
            end

            if (toggling) begin
                if (cnt < TOGGLE_COUNT - 1) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    if (toggle_counter < TOTAL_TOGGLES - 1) begin
                        door_open <= ~door_open;
                        toggle_counter <= toggle_counter + 1;
                    end else begin
                        door_open <= 0;
                        toggling <= 0;
								toggle_counter <= 0;
                    end
                end
            end
        end
    end

endmodule	