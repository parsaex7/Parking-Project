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

