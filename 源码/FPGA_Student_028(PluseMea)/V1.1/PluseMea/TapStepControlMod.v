module TapStepControlMod(
	clk,
	rest,
	inputCmd,
	inputCmdTrigger,
	outputValue,
	overDec,
	tapStep
);
input clk,rest;
input[31:0] inputCmd;
input inputCmdTrigger;
input overDec;
output reg[3:0] tapStep;
output reg[31:0] outputValue;

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

/******************************************************************************
命令解析状态机
******************************************************************************/
parameter cmd_idle=4'd0,
			 cmd_init=4'd1,
			 cmd_getValue=4'd2,
			 cmd_setValue=4'd3;
reg[3:0] cmdState=cmd_idle,next_cmdState=cmd_idle;

/*状态机第一部分*/
always @(posedge clk or negedge rest) begin
	if(!rest) begin
		cmdState<=cmd_idle;
	end
	else begin
		cmdState<=next_cmdState;
	end
end

/*状态机第二部分*/
always @(*) begin
	if(!rest) begin
		next_cmdState=cmd_idle;
	end
	else begin
		case(cmdState)
			cmd_idle:begin
					next_cmdState=inputCmdTriggerPos?cmd_init:cmd_idle;
				end
			cmd_init:begin
					case(inputCmd[31:28])
						4'd6:begin
								next_cmdState=cmd_getValue;
							end
						4'd7:begin
								next_cmdState=cmd_setValue;
							end
						default:begin
								next_cmdState=cmd_idle;
							end
					endcase
				end
			cmd_getValue:begin
					next_cmdState=cmd_idle;
				end
			cmd_setValue:begin
					next_cmdState=cmd_idle;
				end
			default:begin
					next_cmdState=cmd_idle;
				end
		endcase
	end
end
/*状态机第三部分*/
always @(posedge clk) begin
	if(!rest) begin
	end
	else begin
		case(cmdState)
			cmd_getValue:begin
					case(inputCmd[27:24])
						4'd1:begin
								outputValue<={27'd0,overDecD,tapStep};
							end
						default:begin
								outputValue<=32'hA55AAA55;
							end
					endcase
				end
			cmd_setValue:begin
					case(inputCmd[27:24])
						4'd1:begin
								tapStep<=inputCmd[3:0];
							end
					endcase
				end
			default:begin
				end
		endcase
	end
end

endmodule
