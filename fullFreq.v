module fullFreq(
    input clk,   
    input rst,  
    input full_signal,
    output reg out_signal
);

    parameter CLK_FREQ = 1000;
    parameter TOGGLE_FREQ = 0.5;
    parameter TOGGLE_COUNT = CLK_FREQ / (2 * TOGGLE_FREQ);
    parameter TOTAL_TOGGLES = 3;

    reg [25:0] cnt;
    reg [2:0] toggle_counter;
    reg toggling;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            toggle_counter <= 0;
            out_signal <= 0;
            toggling <= 0;
        end else begin
            if (full_signal && !toggling) begin
                toggling <= 1;
                cnt <= 0;
                toggle_counter <= 0;
                out_signal <= 1;
            end

            if (toggling) begin
                if (cnt < TOGGLE_COUNT - 1) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    if (toggle_counter < TOTAL_TOGGLES - 1) begin
                        out_signal <= ~out_signal;
                        toggle_counter <= toggle_counter + 1;
                    end else begin
                        out_signal <= 0;
                        toggling <= 0;
                    end
                end
            end
        end
    end

endmodule