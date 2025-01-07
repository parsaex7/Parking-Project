module sevenSeg(
    input [3:0] data,
    output [7:0] seg
);

always @(data)
begin
    case(data)
    4'b0000 : seg <= 8'b01111111;
    4'b0001 : seg <= 8'b00000110;
    4'b0010 : seg <= 8'b01011011;
    4'b0011 : seg <= 8'b01001111;
    4'b0100 : seg <= 8'b01100110; 
    4'b0101 : seg <= 8'b01101101;
    4'b0110 : seg <= 8'b01111101;
    4'b0111 : seg <= 8'b00000111;
    4'b1000 : seg <= 8'b01111111;
    4'b1001 : seg <= 8'b01111011;
    endcase
end
endmodule