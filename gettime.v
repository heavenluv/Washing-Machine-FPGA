module gettime(i_time,minute,second,second_p);

input [15:0] i_time;
output [7:0] minute;
output [7:0] second;
output [3:0] second_p;

reg [7:0] minute;
reg [7:0] second;
reg [3:0] second_p;

always @ (i_time) 
begin
	second_p <= i_time % 6'd10;
	minute <= i_time / 16'd600; 
	second <= (i_time - second_p - 10'd600 * minute) / 4'd10;
end

endmodule