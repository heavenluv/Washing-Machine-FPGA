module display(clk,rst,minute,second,second_p,o_index_n,o_seg_n,o_lsb);

input clk,rst;
input [7:0] minute;
input [7:0] second;
input [3:0] second_p;
output [3:0] o_index_n; // 动态扫描用
output [7:0] o_seg_n; // 动态数码管
output [6:0] o_lsb; //静态数码管

reg [2:0] activescan;
reg [3:0] number;
reg [7:0] seg; // a,b,c,d,e,f,g,p 
reg [3:0] index;
reg [6:0] lsb;
reg clkout_50hz;
reg clkout_10hz;
reg [24:0]cnt1;
reg [24:0]cnt2;

assign o_lsb = ~lsb;
assign o_seg_n = ~seg;
assign o_index_n = ~index;

reg reset;

always@(posedge clk)
begin
	reset<=rst;
end

always@(posedge clk or negedge reset)
begin
	if (!reset)
	begin
		cnt1<=0;
		clkout_10hz<=0;
	end
	else if(cnt1==25'd11_999_99)
	begin
		cnt1<=0;
		clkout_10hz<=~clkout_10hz;
	end
	else
	begin
		cnt1<=cnt1+1;
	end
end

always@(posedge clk or negedge reset)
begin
	if (!reset)
	begin
		cnt2<=0;
		clkout_50hz<=0;
	end
	else if(cnt2==25'd47999)
	begin
		cnt2<=0;
		clkout_50hz<=~clkout_50hz;
	end
	else
	begin
		cnt2<=cnt2+1;
	end
end

always @ (second_p) 
begin
	case (second_p)
		4'd0: lsb = 7'b1111110; // 0
		4'd1: lsb = 7'b0110000; // 1
		4'd2: lsb = 7'b1101101; // 2
		4'd3: lsb = 7'b1111001; // 3
		4'd4: lsb = 7'b0110011; // 4
		4'd5: lsb = 7'b1011011; // 5
		4'd6: lsb = 7'b1011111; // 6
		4'd7: lsb = 7'b1110000; // 7
		4'd8: lsb = 7'b1111111; // 8
		4'd9: lsb = 7'b1111011; // 9
		default: lsb = 7'b0000000;
	endcase
end

always @ (posedge clkout_50hz) 
begin
	if (activescan == 3'd3) 
	begin
		activescan <= 0;
	end 
	else 
	begin
		activescan <= activescan + 1;
	end

	case (activescan) 
		3'd0: begin
			index <= 4'b0001;
			number <= second % 8'd10; 
		end
		3'd1: begin
			index <= 4'b0010;
			number <= second / 8'd10;
		end
		3'd2: begin
			index <= 4'b0100;
			number <= minute % 8'd10;
		end
		3'd3: begin
			index <= 4'b1000;
			number <= minute / 8'd10;
		end
	endcase
	
	
end

always @ (index) begin
	case (number)
		4'd0: seg[7:1] = 7'b1111110; // 0
		4'd1: seg[7:1] = 7'b0110000; // 1
		4'd2: seg[7:1] = 7'b1101101; // 2
		4'd3: seg[7:1] = 7'b1111001; // 3
		4'd4: seg[7:1] = 7'b0110011; // 4
		4'd5: seg[7:1] = 7'b1011011; // 5
		4'd6: seg[7:1] = 7'b1011111; // 6
		4'd7: seg[7:1] = 7'b1110000; // 7
		4'd8: seg[7:1] = 7'b1111111; // 8
		4'd9: seg[7:1] = 7'b1111011; // 9
	endcase
end
endmodule
