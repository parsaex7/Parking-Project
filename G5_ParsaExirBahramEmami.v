module FSM (
    input car_in, //first bit of 4 bit input
    input car_out_deb,
    input [1:0] car_out, //three last bits of 4 bit input
    input clk,
    input rst,
    output reg [2:0] space_count, // 7 seg
    output reg [1:0] near_slot, // 7 seg
    output reg door_open,
    output reg door_open_exit,
    output reg full_garage,
    output reg [3:0] state
);

    parameter 
        empty = 4'b0000,
        s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100,
        s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000,
        s9 = 4'b1001, s10 = 4'b1010, s11 = 4'b1011, s12 = 4'b1100,
        s13 = 4'b1101, s14 = 4'b1110,
        full = 4'b1111;

    

    always @(posedge clk or posedge rst) 
    begin
        if(rst)
        begin
            state <= empty;
            full_garage <= 1'b0;
            space_count <= 3'b100;
            door_open <= 1'b0;
            door_open_exit <= 1'b0;
            near_slot <= 2'b00;
        end
        
        
        else begin
        case (state)
            empty: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    space_count <= 3'b011;
                    near_slot <= 2'b01;
                    door_open <= 1'b1;
                    state <= s1;
                end
            end
            s1: 
            begin
                door_open <= 1'b0;
                if (car_in) 
                begin
                    space_count <= 3'b010;
                    near_slot <= 2'b10;
                    door_open <= 1'b1;
                    state <= s3;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= empty;
                        space_count <= 3'b100;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s2: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s3;
                    space_count <= 3'b010;
                    near_slot <= 2'b10;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b01) 
                    begin
                        state <= empty;
                        space_count <= 3'b100;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s3: 
            begin
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    space_count <= 3'b001;
                    near_slot <= 2'b11;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s2;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b01) 
                    begin
                        state <= s1;
                        space_count <= 3'b011;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s4: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s6;
                    space_count <= 3'b010;
                    near_slot <= 2'b00;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b10) 
                    begin
                        state <= empty;
                        space_count <= 3'b100;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s5: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    space_count <= 3'b001;
                    near_slot <= 2'b11;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s4;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b10) 
                    begin
                        state <= s1;
                        space_count <= 3'b011;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s6: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    space_count <= 3'b001;
                    near_slot <= 2'b11;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b01) 
                    begin
                        state <= s4;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b10) 
                    begin
                        state <= s2;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s7: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    space_count <= 3'b000;
                    full_garage <= 1'b1;
                    door_open <= 1'b1;  //be carefull
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b10) 
                    begin
                        state <= s3;
                        space_count <= 3'b010;
                        near_slot <= 2'b10;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b01) 
                    begin
                        state <= s5;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b00) 
                    begin
                        state <= s6;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s8: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s9;
                    space_count <= 3'b010;
                    near_slot <= 2'b01;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b11) 
                    begin
                        state <= empty;
                        space_count <= 3'b100;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s9: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s11;
                    space_count <= 3'b001;
                    near_slot <= 2'b10;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s1;
                        space_count <= 3'b011;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s10: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s11;
                    space_count <= 3'b001;
                    near_slot <= 2'b10;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b01) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s2;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s11: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    full_garage <= 1'b1;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s10;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b01) 
                    begin
                        state <= s9;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin  // be carefull
                        state <= s3;
                        space_count <= 3'b010;
                        near_slot <= 2'b10;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s12: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= s13;
                    space_count <= 3'b001;
                    near_slot <= 2'b01;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b10) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s4;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s13: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    space_count <= 3'b000;
                    full_garage <= 1'b1;   // be carefull
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s12;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b10) 
                    begin
                        state <= s9;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s5;
                        space_count <= 3'b010; //be carefull
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            s14: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    space_count <= 3'b000;
                    full_garage <= 1'b1;
                    door_open <= 1'b1;
                end else if (car_out_deb) 
                begin
                    if (car_out == 2'b10) 
                    begin
                        state <= s10;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b01) 
                    begin
                        state <= s12;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s6;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end
                end
            end
            full: 
            begin
                door_open <= 1'b0;
                door_open_exit = 1'b0;
                if (car_in)
                begin
                    full_garage <= 1'b1;
                end else 
                begin
                    full_garage <= 1'b0;
                end
                if (car_out_deb) 
                begin
                    if (car_out == 2'b00) 
                    begin
                        state <= s14;
                        space_count <= 3'b001;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out == 2'b01) 
                    begin
                        state <= s13;
                        space_count <= 3'b001;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out == 2'b10) 
                    begin
                        state <= s11;
                        space_count <= 3'b001;
                        near_slot <= 2'b10;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out == 2'b11) 
                    begin
                        state <= s7;
                        space_count <= 3'b001;
                        near_slot <= 2'b11;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end
                end
            end
        endcase
        end
    end
endmodule


//////////////////////////////////////////////////////////////////////////////////

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


//////////////////////////////////////////////////////////////////////////////////////

module divider (
    input wire clk,
    input wire reset,
    output reg clk_1kHz,
    output reg clk_250Hz
);

parameter clkFerq = 40000000; // 40 MHz

parameter targetFreq_1kHz = 1000; // 1 kHz
parameter cycle_1kHz = clkFerq / targetFreq_1kHz;
parameter toggles_1kHz = cycle_1kHz / 2;

parameter targetFreq_250Hz = 250; // 250 Hz
parameter cycle_250Hz = clkFerq / targetFreq_250Hz;
parameter toggles_250Hz = cycle_250Hz / 2;

reg [25:0] cnt_1kHz;
reg [25:0] cnt_250Hz;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        cnt_1kHz <= 0;
        clk_1kHz <= 0;
        cnt_250Hz <= 0;
        clk_250Hz <= 0;
    end else begin
        // 1 kHz clock
        if (cnt_1kHz < cycle_1kHz - 1) begin
            cnt_1kHz <= cnt_1kHz + 1;
        end else begin
            cnt_1kHz <= 0;
            clk_1kHz <= ~clk_1kHz;
        end

        // 250 Hz clock
        if (cnt_250Hz < cycle_250Hz - 1) begin
            cnt_250Hz <= cnt_250Hz + 1;
        end else begin
            cnt_250Hz <= 0;
            clk_250Hz <= ~clk_250Hz;
        end
    end
end

endmodule

/////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////

module fullFreq(
    input clk,   
    input rst,  
    input full_signal,
    output reg out_signal
);

    parameter TOGGLE_COUNT = 250;
    parameter TOTAL_TOGGLES = 5;

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


/////////////////////////////////////////////////////////////////////////////////////////

module sevenSeg(
    input [2:0] data,
    output reg [7:0] seg
);

always @(data)
begin
    case(data)
    3'b000 : seg <= 8'b00111111;
    3'b001 : seg <= 8'b00000110;
    3'b010 : seg <= 8'b01011011;
    3'b011 : seg <= 8'b01001111;
    3'b100 : seg <= 8'b01100110; 
    3'b101 : seg <= 8'b01101101;
    3'b110 : seg <= 8'b01111101;
    3'b111 : seg <= 8'b00000111;
    endcase
end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////

module segmentDivider(
    input clk,
    input rst,
    input [2:0] space_count,
    input [1:0] near_slot,
    output reg [7:0] seg_data,
    output reg [4:0] seg_select
);

wire [7:0] seg1;
wire [7:0] seg2;

sevenSeg f1(.data(space_count[2:0]), .seg(seg1)); // second digit
sevenSeg f2(.data({1'b0, near_slot[1:0]}), .seg(seg2)); // third digit

always @(posedge clk or posedge rst) begin
    if (rst) begin
        seg_select <= 5'b00001;
        seg_data <= 8'b00000000;
    end
    else
    begin
        if (space_count == 0) begin
            if (seg_select == 5'b00001) begin
                seg_select <= 5'b00100;
                seg_data <= seg1;
            end else if (seg_select == 5'b00100) begin
                seg_select <= 5'b00001;
                seg_data <= 8'b01000000;
            end
        end
        else begin
            if (seg_select == 5'b00001) begin
                seg_select <= 5'b00100;
                seg_data <= seg1;
            end else if (seg_select == 5'b00100) begin
                seg_select <= 5'b00001;
                seg_data <= seg2;
            end
        end
    end
end

endmodule

/////////////////////////////////////////////////////////////////////////////////////////

module main(
    input car_in, //first bit of 4 bit input
    input [2:0] car_out, //three last bits of 4 bit input
    input clk_in,
    input rst,
    output wire door_open,
    output wire full_signal,
    output wire [3:0] state,
    output wire [4:0] seg_select,
    output wire [7:0] seg_data,
	 output tmp
);

    wire full_garage;
    wire car_in_deb;
    wire car_out_deb;
    wire door_open_first;
    wire door_open_exit;
    wire clk_1kHz;
    wire clk_250hz;
    wire [2:0] space_count; // 7 seg
    wire [1:0] near_slot; // 7 seg
	 assign tmp = rst;

    //4 Hz clock
    divider f1(
        .clk(clk_in),
        .reset(rst),
        .clk_1kHz(clk_1kHz),  // for debouncer and fsm
        .clk_250Hz(clk_250hz)   // for 7seg
    );

    debouncer f2(
        .clk(clk_1kHz),
        .reset(rst),
        .sig(~car_in),
        .sig_debounced(car_in_deb)
    );

    debouncer f3(
        .clk(clk_1kHz),
        .reset(rst),
        .sig(~car_out[2]),
        .sig_debounced(car_out_deb)
    );

    // change car_in LED to BLINKING mode
    // TODO: i should change it frequency because some issue
    doorFreq f4(
        .clk(clk_1kHz),
        .rst(rst),
        .car_in(door_open_first),
        .car_out(door_open_exit),
        .door_open(door_open)
    );

    // segmentDivider module to generate the 7-segment display data
    segmentDivider f5(
        .clk(clk_250hz),
        .rst(rst),
        .space_count(space_count),
        .near_slot(near_slot),
        .seg_data(seg_data),
        .seg_select(seg_select)
    );

    fullFreq f6(
        .clk(clk_1kHz),
        .rst(rst),
        .full_signal(full_garage),
        .out_signal(full_signal)
    );

    FSM f7(
        .car_in(car_in_deb),
        .car_out_deb(car_out_deb),
        .car_out(car_out[1:0]),
        .clk(clk_1kHz),
        .rst(rst),
        .space_count(space_count),
        .near_slot(near_slot),
        .door_open(door_open_first),
        .door_open_exit(door_open_exit),
        .full_garage(full_garage),
        .state(state)
    );

endmodule