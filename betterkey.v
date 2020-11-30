module betterkey(keyin,keyout,clk,rst,key1);
input keyin;
input clk;
input rst;
output keyout;
output key1;

reg keyins1;
reg keyins2;
reg keyins3;
reg keyins4;
reg reset;
reg[18:0]count;

wire key1;

parameter delay_10ms=16'd240_000;

always@(posedge clk)
begin 
	reset<=rst;
end

always@(posedge clk or negedge reset)
begin	
	if(!reset)
		begin 
		keyins1<=1;
		keyins2<=1;
		end
	else
		begin
		keyins1<=keyin;
		keyins2<=keyins1;
		end
end

assign key1 = keyins1 & (~keyins2);

always@(posedge clk or negedge reset)
begin
	if(!reset)
		begin
		count<=0;
		end
	else if(count==delay_10ms)
	begin
		count<=0;
	end
	else if(key1)
	begin
		count<=0;
	end
	else
		begin
		count<=count+1'd1;
		end
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		begin
		keyins3<=1;
		end
	else if(count==delay_10ms)
		begin
		keyins3=keyin;
		end
end

always @(posedge clk or negedge reset)
begin
	if(!reset)
	begin
		keyins4<=1;
	end
	else
	begin
		keyins4<=keyins3;
	end
end

assign keyout = keyins4 & (~keyins3);
endmodule
