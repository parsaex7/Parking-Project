module segmentDivider(
    input clk,
    input rst,
    input [2:0] space_count,
    input [1:0] near_slot,
    output reg [7:0] seg_data,
    output reg [4:0] seg_select
);

reg [7:0] seg1;
reg [7:0] seg2;

sevenSeg f1(.data(space_count[2:0]), .seg(seg1)); // second digit
sevenSeg f2(.data({1'b0, near_slot[1:0]}), .seg(seg2)); // third digit

always @(posedge clk or posedge rst) begin
    if (rst) begin
        seg_select <= 5'b00001;
        seg_data <= 8'b00000000;
    end
    else if (space_count == 3'b000) begin
        if (seg_select == 5'b00001) begin
            seg_select <= 5'b00100;
            seg_data <= 8'b00000001;
        end else if (seg_select == 5'b00100) begin
            seg_select <= 5'b00001;
            seg_data <= 8'b00000001;
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

endmodule