module timer(clk,rst,i_start,timeshift,i_state,i_step,o_response,o_time);

input clk;
input rst;
input timeshift;
input [1:0] i_step;
input i_start;
input [15:0] i_state; // time to count
output [3:0] o_response;
output [15:0] o_time;

reg [3:0] o_response;
reg [15:0] temp_time;
reg [15:0] o_time;

reg clkout_100hz;
reg clkout_1hz;
reg [24:0]cnt1;
reg [24:0]cnt2;
reg clk_reg;
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
		clkout_1hz<=0;
	end
	else if(cnt1==25'd11_999_999)
	begin
		cnt1<=0;
		clkout_1hz<=~clkout_1hz;
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
		clkout_100hz<=0;
	end
	else if(cnt2==32'd119_999)
	begin
		cnt2<=0;
		clkout_100hz<=~clkout_100hz;
	end
	else
	begin
		cnt2<=cnt2+1;
	end
end

always @ (posedge clk) begin
	if (timeshift) begin
		clk_reg <= clkout_100hz;
	end else begin
		clk_reg <= clkout_1hz;
	end
end

always @ (posedge clk_reg or negedge reset) 
begin
	if (!reset) 
	begin
		o_time <= 0;
		o_response <= 4'b0;
	end 
	else 
	begin
		if (i_start) 
		begin
			o_time <= o_time + 1;
			temp_time <= temp_time + 1;
			if (temp_time < i_state) 
			begin	
				temp_time <= temp_time + 1;
			end 
			else 
			begin
				temp_time <= 16'd0;
				o_time <= 0;
				o_response[i_step] <= 1'b1;
			end
		end 
		else 
		begin
			o_time <= 0;
			temp_time <= 16'd0;
		end
	end

end

endmodule 