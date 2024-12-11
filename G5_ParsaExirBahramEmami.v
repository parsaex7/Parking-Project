module FSM (
    input car_in, //first bit of 4 bit input
    input [2:0] car_out, //three last bits of 4 bit input
    input clk,
    input rst,
    output reg [2:0] space_count, // 7 seg
    output reg [1:0] near_slot, // 7 seg
    output reg door_open,
    output reg door_open_exit,
    output reg full_garage,
    output reg [3:0] parking_light
);
    // States
    parameter 
        empty = 4'b0000,
        s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100,
        s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000,
        s9 = 4'b1001, s10 = 4'b1010, s11 = 4'b1011, s12 = 4'b1100,
        s13 = 4'b1101, s14 = 4'b1110,
        full = 4'b1111;

    
    reg flag_car_out; // it is used because this inout is press button so once it is pressed we should keep its data until we use it
    assign parking_light = state; // because state is showing which slot is free and which is not

    always @(posedge clk or posedge rst or posedge car_out[2]) 
    begin // posedge car_out[2] is for the push button on fpga. if user press it then the choosen car should exit
        if(rst)
        begin
            state <= empty;
            full_garage <= 1'b0;
            space_count <= 3'b100;
            door_open <= 1'b0;
            door_open_exit <= 1'b0;
            near_slot <= 2'b00;
            parking_light <= 4'b0000;
        end

        if(car_out[2])
        begin
            flag_car_out <= 1'b1;
        end
        
        
        
        case (state)
            empty: 
            begin
                space_count <= 3'b100;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s1;
                    door_open <= 1'b1;
                end
            end
            s1: 
            begin
                space_count <= 3'b011;
                near_slot <= 2'b01;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s3;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= empty;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s2: 
            begin
                space_count <= 3'b011;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s3;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b01) 
                    begin
                        state <= empty;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s3: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b10;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s2;
                        door_open <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s1;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s4: 
            begin
                space_count <= 3'b011;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s6;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= empty;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s5: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b01;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s4;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s1;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s6: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s7;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s4;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s2;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s7: 
            begin
                space_count <= 3'b001;
                near_slot <= 2'b11;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s3;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s5;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s6;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s8: 
            begin
                space_count <= 3'b011;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s9;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b11) 
                    begin
                        state <= empty;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s9: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b01;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s11;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s8;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s1;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s10: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s11;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s8;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s2;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s11: 
            begin
                space_count <= 3'b001;
                near_slot <= 2'b10;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s10;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s9;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s3;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s12: 
            begin
                space_count <= 3'b010;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= s13;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s8;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s4;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s13: 
            begin
                space_count <= 3'b001;
                near_slot <= 2'b01;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s12;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s9;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s5;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            s14: 
            begin
                space_count <= 3'b001;
                near_slot <= 2'b00;
                door_open <= 1'b0;
                if (car_in) 
                begin
                    state <= full;
                    door_open <= 1'b1;
                end else if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s10;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s12;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s6;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
            full: 
            begin
                space_count <= 3'b000;
                full_garage <= 1'b1; 
                door_open <= 1'b0;
                if (flag_car_out) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s14;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s13;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s11;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
                    begin
                        state <= s7;
                        door_open_exit <= 1'b1;
                        flag_car_out <= 1'b0;
                    end
                end
            end
        endcase
    end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////

module D_FF ( input D , input clk , input rst , output reg Q );
    always @ (posedge clk or posedge rst)
    begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module debouncer (input sig , input clk ,input rst, output sig_debounced);
    wire q0 , q1 , q2;
    D_FF d0 (sig , clk , rst , q0);
    D_FF d1 (q0 , clk , rst , q1);
    D_FF d2 (q1 , clk , rst, q2);
    assign sig_debounced = q0 & q1 & ~q2;
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module main(
    input car_in_bounced,
    input [2:0] car_out_bounced,
    input clk,
    input rst,
    output [2:0] space_count,
    output [1:0] near_slot,
    output door_open,
    output door_open_exit,
    output full_garage,
    output [3:0] parking_light
);

    wire car_in ;
    wire [2:0] car_out;
    reg fsm_car_in ; 
    reg [2:0] fsm_car_out;
    //debouncer d0 (rst_bounced , clk , 1'b0 , rst);
    debouncer d1 (car_in_bounced , clk , rst , car_in);
    debouncer d2 (car_out_bounced[0] , clk , rst , car_out[0]);
    debouncer d3 (car_out_bounced[1] , clk , rst , car_out[1]);
    debouncer d4 (car_out_bounced[2] , clk , rst , car_out[2]);

    FSM fsm (car_in , car_out , clk , rst , space_count , near_slot , door_open , door_open_exit , full_garage , parking_light);
endmodule

