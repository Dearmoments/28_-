module Freq_measure(
	input	clk_fs,
	input	clk_fx,
	output [31:0] fs_cnt_buff,	
	output [31:0] fx_cnt_buff,		
	output [31:0] duty_cycle_data
);

//被测信号与时钟同步
reg	clk_fx_r0 = 1'b0;
reg	clk_fx_r1 = 1'b0;
always@(posedge clk_fs)
begin
	clk_fx_r0 <= clk_fx;
	clk_fx_r1 <= clk_fx_r0;
end

//检测被测信号边沿
reg	clk_fx_r2 = 1'b0;
reg	clk_fx_r3 = 1'b0;
wire	clk_fx_pose,clk_fx_nege;
always@(posedge clk_fs)
begin
	clk_fx_r2 <= clk_fx_r1;
	clk_fx_r3 <= clk_fx_r2;
end
assign	clk_fx_pose = clk_fx_r2 & ~clk_fx_r3;
assign	clk_fx_nege = ~clk_fx_r2 & clk_fx_r3;

//预置闸门
reg	[31:0]cnt1 = 32'd0;
reg	gate = 1'b0;				//闸门信号
always@(posedge clk_fs)
begin
	if(cnt1 == 32'd49_999_999)	begin
		cnt1 <= 32'd0;
		gate <= ~gate;
	end
	else	begin
		cnt1 <= cnt1+1'b1;
	end
end

//实际闸门
reg	gatebuff = 1'b0;
always@(posedge clk_fs)
begin
	if(clk_fx_pose == 1'b1)
		gatebuff <= gate;		
end

//闸门开启与关闭上升沿
reg	gatebuff1 = 1'b0;
always@(posedge clk_fs)
begin
		gatebuff1 <= gatebuff;
end

wire	gate_start;
wire	gate_end;
assign	gate_start = gatebuff & ~gatebuff1;		//闸门开启时刻
assign	gate_end   = ~gatebuff & gatebuff1;		//闸门关闭时刻

//标准时钟计数
reg	[31:0] cnt2  = 32'd0;
reg	[31:0] fs_cnt = 32'd0;
always@(posedge clk_fs)
begin
	if(gate_start == 1'b1) begin
		cnt2 <= 32'd0;
	end
	else if(gate_end == 1'b1) begin
		fs_cnt <= cnt2;
		cnt2   <= 32'd0;	
	end
	else if(gatebuff1 == 1'b1) begin	
		cnt2 <= cnt2 + 1'b1;
	end
end
assign	fs_cnt_buff = fs_cnt;

//被测信号计数
reg	[31:0] cnt3 = 32'd0;
reg	[31:0] fx_cnt = 32'd0;
always@(posedge clk_fs)
begin
	if(gate_start == 1'b1) begin
		cnt3 <= 32'd0;
	end
	else if(gate_end == 1'b1) begin
		fx_cnt <= cnt3;
		cnt3   <= 32'd0;
	end
	else if(gatebuff1 == 1'b1 && clk_fx_nege == 1'b1) begin//计数被测信号的下降沿
		cnt3 <= cnt3 + 1'b1;
	end
end
assign	fx_cnt_buff = fx_cnt;

//计数被测信号占空比
reg	[31:0]	cnt4 = 32'd0;
reg	[31:0]	cnt4_r = 32'd0;
always@(posedge clk_fs)
begin	
	if(gate_start == 1'b1)	begin
		cnt4 <= 32'd0;
	end
	else if(gate_end == 1'b1)	begin
		cnt4_r <= cnt4;
		cnt4   <= 32'd0;
	end
	else if(gatebuff1 == 1'b1 && clk_fx == 1'b1)	begin
		cnt4 <= cnt4 + 1'b1;
	end
end
assign	duty_cycle_data = cnt4_r;

endmodule