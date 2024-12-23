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
    begin // posedge car_out[2] is for the push button on fpga. if user press it then the choosen car should exit
        if(rst)
        begin
            state <= empty;
            full_garage <= 1'b0;
            space_count <= 3'b100;
            door_open <= 1'b0;
            door_open_exit <= 1'b0;
            near_slot <= 2'b00;
        end
        
        
        
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
                door_open <= 1'b1;
                if (car_in) 
                begin
                    space_count <= 3'b010;
                    near_slot <= 2'b10;
                    door_open <= 1'b1;
                    state <= s3;
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b01) 
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
                door_open <= 1'b1;
                if (car_in) 
                begin
                    state <= s7;
                    space_count <= 3'b001;
                    near_slot <= 2'b11;
                    door_open <= 1'b1;
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s2;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b01) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b10) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s4;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b10) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s4;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b10) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s3;
                        space_count <= 3'b010;
                        near_slot <= 2'b10;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s5;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b00) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s10;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s9;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s8;
                        space_count <= 3'b011;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s12;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s9;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                end else if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s10;
                        space_count <= 3'b010;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s12;
                        space_count <= 3'b010;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                    end else if (car_out[1:0] == 2'b11) 
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
                if (car_out[2]) 
                begin
                    if (car_out[1:0] == 2'b00) 
                    begin
                        state <= s14;
                        space_count <= 3'b001;
                        near_slot <= 2'b00;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out[1:0] == 2'b01) 
                    begin
                        state <= s13;
                        space_count <= 3'b001;
                        near_slot <= 2'b01;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out[1:0] == 2'b10) 
                    begin
                        state <= s11;
                        space_count <= 3'b001;
                        near_slot <= 2'b10;
                        door_open_exit <= 1'b1;
                        full_garage <= 1'b0;
                    end else if (car_out[1:0] == 2'b11) 
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
endmodule


`timescale 1ns/1ps

module FSM_tb;

    // Inputs
    reg car_in;
    reg [2:0] car_out;
    reg clk;
    reg rst;

    // Outputs
    wire [2:0] space_count;
    wire [1:0] near_slot;
    wire door_open;
    wire door_open_exit;
    wire full_garage;
    wire [3:0] state;

    // Instantiate the FSM module
    FSM uut (
        .car_in(car_in),
        .car_out(car_out),
        .clk(clk),
        .rst(rst),
        .space_count(space_count),
        .near_slot(near_slot),
        .door_open(door_open),
        .door_open_exit(door_open_exit),
        .full_garage(full_garage),
        .state(state)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #12.5 clk = ~clk;
    end
    
    integer input_file, output_file, scan_file;
    reg [3:0] input_data;

    initial begin
        $dumpfile("FSM_tb.vcd");
        $dumpvars(0, FSM_tb);

        car_in = 0;
        car_out = 3'b000;
        rst = 1;
        #25;
        rst = 0;


        input_file = $fopen("input.txt", "r");
        output_file = $fopen("output.txt", "w");

        if (input_file == 0 || output_file == 0) begin
            $display("Failed to open file.");
            $finish;
        end

        while (!$feof(input_file)) begin
            scan_file = $fscanf(input_file, "%4b\n", input_data);
            car_in = input_data[3];
            car_out = input_data[2:0];
            $display("Read input: car_in=%b, car_out=%b", car_in, car_out); 
            #25;
            $fwrite(output_file, "%4b [%d,%d]\t", state, space_count, near_slot);
            if (door_open | door_open_exit) begin
                $fwrite(output_file, "Door");
            end
            if (full_garage) begin
                $fwrite(output_file, "Full");
            end
            $fwrite(output_file, "\n");
        end

        $fclose(input_file);
        $fclose(output_file);
        $finish;



    end

endmodule



        //         // Initialize Inputs
        // rst = 1'b1; #25
        // rst = 1'b0;

        // car_in = 0;
        // car_out = 3'b000; #30

        // // Test case 1: Add a car
        // car_in = 1; #25
        // car_in = 0; #30

        // // Test case 2: Add another car
        // car_in = 1; #25
        // car_in = 0; #30

        // // Test case 3: Remove a car from slot 0
        // car_out = 3'b100; #25 
        // car_out = 3'b000; #30

        // // Test case 4: Add another car
        // car_in = 1; #25
        // car_in = 0; #30

        // // Test case 5: Remove a car from slot 1
        // car_out = 3'b101; #25
        // car_out = 3'b000; #30

        // // Test case 6: Fill the garage
        // car_in = 1; #200
        // car_in = 0; #30

        // // Test case 7: Remove a car from slot 3
        // car_out = 3'b111; #25
        // car_out = 3'b000; #30
        // // Finish simulation
        // #50
        // $finish;