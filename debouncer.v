module debouncer (
    input clk,
    input reset,
    input sig,
    output reg sig_debounced
);
    reg q0 , q1;
    always @(posedge clk or posedge reset) 
    begin
        if (reset)
        begin
            q1 <= 0;
            q0 <= 0;
            sig_debounced <= 0;
        end
        q1 <= q0;
        q0 <= sig;
        sig_debounced <= q0 & ~q1;
    end
endmodule