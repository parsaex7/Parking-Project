module main(
    input car_in, //first bit of 4 bit input
    input [2:0] car_out, //three last bits of 4 bit input
    input clk_in,
    input rst,
    output reg door_open,
    output reg door_open_exit,
    output reg full_garage,
    output reg [3:0] state,
    output reg [4:0] seg_select,
    output reg [7:0] seg_data
);

    wire car_in_deb;
    wire car_out_deb;
    wire door_open_first;
    wire clk;
    wire [2:0] space_count, // 7 seg
    wire [1:0] near_slot, // 7 seg

    divider f1(clk_in, rst, clk);  //return 4Hz clk
    // return debounced input
    debouncer f2(clk, rst, car_in, car_in_deb);  
    debouncer f3(clk, rst, car_out[2], car_out_deb);

    doorFreq f4(clk, rst, door_open_first, door_open); //return door_open blinking

    segmentDivider f5(clk_in, rst, space_count, near_slot, seg_data, seg_select); //return 7 seg data and select
    // car_in and car_out debounced should be used as not in fsm
    FSM f6(~car_in_deb, ~car_out_deb, car_out[1:0], clk, rst, space_count, near_slot, door_open_first, door_open_exit, full_garage, state);
    

endmodule