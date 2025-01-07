module segmentDivider(
    input clk,
    input rst,
    input [3:0] space_count,
    input [1:0] near_slot
    output reg [7:0] seg_data,
    output reg [4:0] seg_select
);

reg [7:0] seg1;
reg [7:0] seg2;
sevenSeg f1(space_count[3:0], seg1); // second digit
sevenSeg f2(near_slot[1:0], seg2); // third digit

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        seg_select <= 5'b00001;
        seg_data <= 8'b00000000;
    end
    else
    begin
        if (seg_select == 5'b00001)
        begin
            seg_select <= 5'b00100;
            seg_data <= seg1;
        end
        else if (seg_select == 5'b00010)
        begin
            seg_select <= 5'b00001;
            seg_data <= seg2;
        end
    end
end
endmodule