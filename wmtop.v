module wmtop (
	clk, 
	rst,
	start, 
	waterfull, 
	accelerate,
	stateindic,
	index_n,
	fourdigit,
	lastdigit,
);

input clk, rst; 
input start;
input accelerate;
input waterfull;
output [5:0] stateindic;
output [3:0] index_n;
output [7:0] fourdigit;
output [6:0] lastdigit;

parameter IDLE	= 6'b000001;
parameter WATER	= 6'b000010;
parameter RINSE	= 6'b000100; 
parameter DRAIN	= 6'b001000; 
parameter DRY	= 6'b010000; 
parameter ALERT = 6'b100000;

parameter RINSE_TIME	= 16'd6000; // 10min
parameter DRAIN_TIME	= 16'd300; // 30sec
parameter DRY_TIME		= 16'd3000; // 5min
parameter ALERT_TIME	= 16'd100; //10sec

wire start1;
reg [5:0] state;
reg timer_start;
reg [15:0] timer_state;
reg [1:0] step;
reg reset;
wire acc_wire;

wire [3:0] timer_done;
wire [15:0] time_wire;
wire [7:0] minute_wire;
wire [7:0] second_wire;
wire [3:0] second_p_wire;

assign stateindic = ~state;
assign acc_wire = ~accelerate;

always@(posedge clk)
begin
	reset<=rst;
end

always @ (posedge clk or negedge reset) 
begin
	if (!reset) 
	begin
		state <= IDLE;
		timer_start <= 1'b0;
		timer_state <= 0;
	end 
	else 
	begin
		case (state)
			IDLE: begin
				if (!start) 
				begin
					state <= WATER;
					timer_start <= 0;
					timer_state <= 0;
				end 
				else 
				begin
					state <= IDLE;
					timer_start <= 0;
					timer_state <= 0;
				end
			end
			
			WATER: 
			begin
				if (!waterfull) 
				begin
					state <= RINSE;
					timer_start <= 1;
					timer_state <= RINSE_TIME;
					step <= 2'b00;
				end 
			end
			
			RINSE: 
			begin
				if (timer_done[0]) 
				begin
					state <= DRAIN;
					timer_start <= 1;
					timer_state <= DRAIN_TIME;
					step <= 2'b01;
				end
			end
			
			DRAIN: 
			begin
				if (timer_done[1]) 
				begin
					state <= DRY;
					timer_start <= 1;
					timer_state <= DRY_TIME;
					step <= 2'b10;
				end
			end
			
			DRY: 
			begin
				if (timer_done[2]) 
				begin
					state <= ALERT;
					timer_start <= 1;
					timer_state <= ALERT_TIME;
					step <= 2'b11;
					
				end
			end
			
			ALERT: 
			begin
				if (timer_done[3]) 
				begin
					state <= IDLE;
					timer_start <= 0;
					timer_state <= 0;
				end 
			end
			default: begin
				state <= IDLE;
				timer_start <= 0;
				timer_state <= 0;
			end
			
		endcase
	end
end		

timer t (
	.clk(clk),
	.rst(rst),
	.timeshift(accelerate),
	.i_start(timer_start),
	.i_state(timer_state),
	.i_step(step),
	.o_response(timer_done),
	.o_time(time_wire)
);

gettime g (
	.i_time(time_wire),
	.minute(minute_wire),
	.second(second_wire),
	.second_p(second_p_wire),
);

display d (
	.clk(clk),
	.rst(rst),
	.minute(minute_wire),
	.second(second_wire),
	.second_p(second_p_wire),
	.o_index_n(index_n), 
	.o_seg_n(fourdigit),
	.o_lsb(lastdigit)
);

endmodule 