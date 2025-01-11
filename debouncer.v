module debouncer (
    input clk,
    input reset,
    input sig,
    output reg sig_debounced
);
// if there is 011 for sig then the output will be 1 for 2 * CLOCK PERIOD
    reg q0 , q1, q2;
    always @(posedge clk or posedge reset) 
    begin
        if (reset)
        begin
            q2 <= 0;
            q1 <= 0;
            q0 <= 0;
            sig_debounced <= 0;
        end
        else
        begin
            q2 <= q1;
            q1 <= q0;
            q0 <= sig;
            sig_debounced <= q0 && q1 && ~q2;
        end
    end
endmodule