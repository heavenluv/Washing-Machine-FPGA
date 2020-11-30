module dtimer(clk,clk_1hz,rst,start,upkey,downkey,settimer);
input clk,clk_1hz,rst,start,upkey,downkey;
output [6:0]settimer;
reg [6:0]Timer;
reg [6:0]rTimer;
reg reset;

always@(posedge clk)
begin
	reset<=rst;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
	begin
	Timer<=7d'50;
	end
	else if(Start)
	begin
		if(upkey)
		begin
		Timer<=Timer+1'b1;
		end
		else if(downkey)
		begin
		Timer<=Timer-1'b1;
		end
	end
end

always@(posedge clk or negedge rst)
begin
	rTimer