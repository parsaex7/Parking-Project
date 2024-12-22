module frequency_converter (
    input clk,      // 40 MHz clock input
    input reset,    // Reset signal
    output reg door_open, // 2 Hz output for 10 seconds
    output reg full_garage  // Light turned on/off 3 times with 1-second gap
);

    // Parameters for time calculations
    parameter CLK_FREQ = 40000000; // 40 MHz clock
    parameter OUT1_FREQ = 2;       // 2 Hz
    parameter OUT1_TIME = 10;      // 10 seconds
    parameter OUT2_BLINKS = 3;     // 3 blinks

    // Counters for division and timing
    reg [31:0] counter1 = 0;
    reg [31:0] time_counter = 0;
    reg [31:0] blink_counter = 0;

    // Clock division values
    parameter OUT1_DIV = CLK_FREQ / (2 * OUT1_FREQ);
    parameter OUT2_GAP = CLK_FREQ; // 1 second gap

    // State machine states
    localparam STATE_OUT1 = 2'b00;
    localparam STATE_OUT2 = 2'b01;

    reg [1:0] state = STATE_OUT1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_OUT1;
            counter1 <= 0;
            time_counter <= 0;
            blink_counter <= 0;
            door_open <= 0;
            full_garage <= 0;
        end else begin
            case (state)
                STATE_OUT1: begin
                    if (counter1 >= OUT1_DIV) begin
                        counter1 <= 0;
                        door_open <= ~door_open;
                        time_counter <= time_counter + 1;
                        if (time_counter >= (OUT1_TIME * OUT1_FREQ)) begin
                            state <= STATE_OUT2;
                            time_counter <= 0;
                        end
                    end else begin
                        counter1 <= counter1 + 1;
                    end
                end
                STATE_OUT2: begin
                    if (counter1 >= OUT2_GAP) begin
                        counter1 <= 0;
                        full_garage <= ~full_garage;
                        if (full_garage) begin
                            blink_counter <= blink_counter + 1;
                            if (blink_counter >= OUT2_BLINKS) begin
                                state <= STATE_OUT1;
                                blink_counter <= 0;
                            end
                        end
                    end else begin
                        counter1 <= counter1 + 1;
                    end
                end
            endcase
        end
    end

endmodule