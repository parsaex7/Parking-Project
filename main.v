module main(
    input car_in, //first bit of 4 bit input
    input [2:0] car_out, //three last bits of 4 bit input
    input clk_in,
    input rst,
    output wire door_open,
    output wire full_garage,
    output wire [3:0] state,
    output wire [4:0] seg_select,
    output wire [7:0] seg_data
);


    wire car_in_deb;
    wire car_out_deb;
    wire door_open_first;
    wire door_open_exit;
    wire clk_100hz;
    wire clk_500kHz;
    wire clk_60hz;
    wire [2:0] space_count; // 7 seg
    wire [1:0] near_slot; // 7 seg

    //4 Hz clock
    divider f1(
        .clk(clk_in),
        .reset(rst),
        .clk_out(clk_100hz),
        .clk_500kHz(clk_500kHz),
        .clk_60hz(clk_60hz)
    );

    debouncer f2(
        .clk(clk_500kHz),
        .reset(rst),
        .sig(car_in),
        .sig_debounced(car_in_deb)
    );

    debouncer f3(
        .clk(clk_500kHz),
        .reset(rst),
        .sig(car_out[2]),
        .sig_debounced(car_out_deb)
    );

    // change car_in LED to BLINKING mode
    doorFreq f4(
        .clk(clk_100hz),
        .rst(rst),
        .car_in(door_open_first),
        .car_out(door_open_exit),
        .door_open(door_open)
    );

    // segmentDivider module to generate the 7-segment display data
    segmentDivider f5(
        .clk(clk_60Hz),
        .rst(rst),
        .space_count(space_count),
        .near_slot(near_slot),
        .seg_data(seg_data),
        .seg_select(seg_select)
    );

    FSM f6(
        .car_in(~car_in_deb),
        .car_out(~car_out_deb),
        .car_out_bits(car_out[1:0]),
        .clk(clk_100hz),
        .rst(rst),
        .space_count(space_count),
        .near_slot(near_slot),
        .door_open_first(door_open_first),
        .door_open_exit(door_open_exit),
        .full_garage(full_garage),
        .state(state)
    );

endmodule