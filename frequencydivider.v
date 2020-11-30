module frequencydivider(clk,rst,clkout_1hz,clkout_100hz);
input clk,rst;
output clkout_1hz;
reg [24:0]cnt1;
reg [19:0]cnt2;
reg data;
reg data1;
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
		data<=0;
	end
	else if(cnt1==25'd11_999_999)
	begin
		cnt1<=0;
		data<=~data;
	end
	else
	begin
		cnt1<=cnt1+1;
	end
end
assign clkout_1hz=data;

always@(posedge clk or negedge reset)
begin
	if (!reset)
	begin
		cnt2<=0;
		data1<=0;
	end
	else if(cnt2==20'd119999)
	begin
		cnt1<=0;
		data1<=~data1;
	end
	else
	begin
		cnt2<=cnt2+1;
	end
end
assign clkout_100hz=data1;
endmodule

