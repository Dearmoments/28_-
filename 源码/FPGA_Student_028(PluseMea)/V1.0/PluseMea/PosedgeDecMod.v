/**********************************************************************
上升沿检测模块
**********************************************************************/
module PosedgeDecMod(
	clk,
	in,
	out
);
input clk,in;
output out;

reg lastIn=1'd0,nowIn=1'd0;
always @(posedge clk) begin
	lastIn<=nowIn;
	nowIn<=in;
end
assign out=(~lastIn)&nowIn;

endmodule