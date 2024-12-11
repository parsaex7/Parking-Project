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
    typedef enum reg [1:0] {
        STATE_OUT1 = 2'b00,
        STATE_OUT2 = 2'b01
    } state_t;

    state_t state = STATE_OUT1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs and counters
            door_open <= 0;
            full_garage <= 0;
            counter1 <= 0;
            time_counter <= 0;
            blink_counter <= 0;
            state <= STATE_OUT1;
        end else begin
            case (state)
                STATE_OUT1: begin
                    if (time_counter < OUT1_TIME * CLK_FREQ) begin
                        // Generate 2 Hz signal
                        counter1 <= counter1 + 1;
                        if (counter1 >= OUT1_DIV) begin
                            counter1 <= 0;
                            door_open <= ~door_open;
                        end
                        time_counter <= time_counter + 1;
                    end else begin
                        // Transition to STATE_OUT2
                        time_counter <= 0;
                        door_open <= 0;
                        state <= STATE_OUT2;
                    end
                end

                STATE_OUT2: begin
                    if (blink_counter < OUT2_BLINKS) begin
                        time_counter <= time_counter + 1;
                        if (time_counter >= OUT2_GAP) begin
                            time_counter <= 0;
                            full_garage <= ~full_garage;
                            if (~full_garage) blink_counter <= blink_counter + 1;
                        end
                    end else begin
                        // Reset to STATE_OUT1
                        time_counter <= 0;
                        full_garage <= 0;
                        blink_counter <= 0;
                        state <= STATE_OUT1;
                    end
                end

                default: state <= STATE_OUT1;
            endcase
        end
    end

endmodule

