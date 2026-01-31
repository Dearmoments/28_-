module TapStepControlMod(
	clk,
	rest,
	inputCmd,
	inputCmdTrigger,
	overDec,
	tapStep
);
input clk,rest;
input[31:0] inputCmd;
input inputCmdTrigger;
input overDec;
output reg[3:0] tapStep;

reg overDecD;
always @(posedge clk or negedge rest) begin
	if(!rest) begin
		overDecD<=1'd0;
	end
	else begin
		overDecD<=overDec;
	end
end


wire inputCmdTriggerPos;
PosedgeDecMod inputCmdTriggerPosDec(
	.clk(clk),
	.in(inputCmdTrigger),
	.out(inputCmdTriggerPos)
);

wire tapStepClear=(inputCmd[31:28]==4'd6)&&inputCmdTriggerPos;

parameter tapStep_max=4'b1010,
			 tapStep_min=4'b0101;
always @(posedge tapStepClear or posedge overDecD) begin
	if(tapStepClear) begin
		tapStep<=tapStep_max;
	end
	else begin
		tapStep<=tapStep_min;
	end
end

endmodule
