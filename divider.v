module divider (
    input wire clk,
    input wire reset,
    input wire open_door,
    output reg open_door_output,
);

reg [3:0] full_counter;
reg [23:0] door_counter;
reg [25:0] clk_divider_1Hz;
reg [24:0] clk_divider_2Hz;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_divider_1Hz <= 0;
        clk_divider_2Hz <= 0;
        full_counter <= 0;
        door_counter <= 0;
        full_output <= 0;
        open_door_output <= 0;
    end 
    else begin
        if(open_door) begin
            full_output <= 0;
            full_counter <= 0;
            if (door_counter < 10) begin // Adjusted for shorter simulation
                if (clk_divider_2Hz == 3'b100) begin
                    door_counter <= door_counter + 1;
                    open_door_output <= ~open_door_output;
                    clk_divider_2Hz <= 0;
                end
                else begin
                    clk_divider_2Hz <= clk_divider_2Hz + 1;
                end
            end 
            else begin
                open_door_output <= 0;
            end
        end else begin
            open_door_output <= 0;
        end
    
    end
end

endmodule
