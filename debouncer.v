module debouncer (input sig , input clk ,input rst, output sig_debounced);
    wire q0 , q1 , q2;
    D_FF d0 (sig , clk , rst , q0);
    D_FF d1 (q0 , clk , rst , q1);
    D_FF d2 (q1 , clk , rst, q2);
    assign sig_debounced = q0 & q1 & ~q2;
endmodule