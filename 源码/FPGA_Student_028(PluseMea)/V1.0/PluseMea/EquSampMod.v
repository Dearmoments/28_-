/*******************************************************************************
note:
	①“全局设置”中，recordStep,onceRecordNum,recordLength三者间必须满足恒等式：
	               recordLength==recordStep*onceRecordNum
	②“adc采样时钟产生”中，“assign adc_sampStartupClk=clkDivCount[2]”对时钟分频得到ADC时钟，
	  分频比必须和recordStep值相等
*******************************************************************************/
module EquSampMod(
   clk,                       /*时钟*/
   rest,                      /*复位*/
   adc_sampStartupClk,        /*adc采样启动触发时钟*/
   adc_sampDoneTrigger,       /*adc采样完成触发输入*/
   adc_value,                 /*adc数据输入*/
   triggerIn,                 /*触发信号输入*/
   inputCmd,                  /*指令输入*/
   inputCmdTrigger,           /*指令输入触发*/
   outputValue                /*数据输出*/
);
/*******************************************************************************
端口声明
*******************************************************************************/
input clk,rest;
output adc_sampStartupClk;
input adc_sampDoneTrigger;
input[15:0] adc_value;
input triggerIn;
input[31:0] inputCmd;
input inputCmdTrigger;
output reg[31:0] outputValue;

/*******************************************************************************
全局设置
*******************************************************************************/
parameter waitAdcSampDoneClkNum=8'd30;


reg[31:0] delayTriggerTime=32'd0;/*延迟触发时间*/
reg[15:0] recordStep=16'd8;/*记录步进:recordStep=时钟频率/adc实时采样频率*/
reg[15:0] onceRecordNum=16'd1024;/*单次记录数量:onceRecordNum=recordLength/recordStep,onceRecordNum与recordStep乘积必须等于recordLength*/

/*******************************************************************************
寄存器
*******************************************************************************/
wire[15:0] ID=16'hA55A;
/***
stateReg[0]:采样完成标志位
	0:正在采样
	1:采样完成
***/
reg[15:0] stateReg=16'hA5ff;


/*******************************************************************************
上升沿检测
*******************************************************************************/
/*采样启动时钟上升沿检测*/
wire adc_sampStartupClkPos;
PosedgeDecMod adc_sampStartupClkPosDec(.clk(clk),.in(adc_sampStartupClk),.out(adc_sampStartupClkPos));
/*采样完成信号上升沿检测*/
wire adc_sampDoneTriggerPos;
PosedgeDecMod adc_sampDoneTriggerPosDec(.clk(clk),.in(adc_sampDoneTrigger),.out(adc_sampDoneTriggerPos));
/*触发输入信号上升沿检测*/
wire triggerInPos;
PosedgeDecMod triggerInPosDec(.clk(clk),.in(triggerIn),.out(triggerInPos));
/*指令输入信号上升沿检测*/
wire inputCmdTriggerPos;
PosedgeDecMod inputCmdTriggerPosDec(.clk(clk),.in(inputCmdTrigger),.out(inputCmdTriggerPos));

/*******************************************************************************
RAM实例化
*******************************************************************************/
reg[12:0] RecordRAM_WriteAddress;
wire[15:0] RecordRAM_WriteData;
wire RecordRAM_WriteClock;
wire RecordRAM_WriteEN;
wire[12:0] RecordRAM_ReadAddress;
wire[15:0] RecordRAM_ReadData;
wire RecordRAM_ReadClock;
/*RAM实例*/
RecordRAMMod RecordRAM(
	.data(RecordRAM_WriteData),
	.rdaddress(RecordRAM_ReadAddress),
	.rdclock(RecordRAM_ReadClock),
	.wraddress(RecordRAM_WriteAddress),
	.wrclock(RecordRAM_WriteClock),
	.wren(RecordRAM_WriteEN),
	.q(RecordRAM_ReadData)
);

/*******************************************************************************
触发检测、触发延迟
*******************************************************************************/
/*RS触发器检测*/
reg triggerInDecEN=1'd1,triggerInDecStart=1'd0,triggerInDecStop=1'd0;
/*指令输入信号上升沿检测*/
wire triggerInDecStartPos;
PosedgeDecMod triggerInDecStartPosDec(.clk(clk),.in(triggerInDecStart),.out(triggerInDecStartPos));
/*指令输入信号上升沿检测*/
wire triggerInDecStopPos;
PosedgeDecMod triggerInDecStopPosDec(.clk(clk),.in(triggerInDecStop),.out(triggerInDecStopPos));
always @(posedge triggerInDecStartPos or posedge triggerInDecStopPos) begin
	if(triggerInDecStartPos) begin
		triggerInDecEN<=1'd1;
	end
	else begin
		triggerInDecEN<=1'd0;
	end
end
/*产生延迟脉冲*/
reg[31:0] delayCount=32'd0;
always @(posedge clk or negedge rest) begin
	if(!rest) begin
		delayCount<=32'd0;
	end
	else begin
		if(triggerInPos&triggerInDecEN) begin
			delayCount<=32'd0;
		end
		else begin
			triggerInDecStop<=(delayCount==32'd0)?1'd1:1'd0;
			delayCount<=(delayCount<32'HFFFFFFFF)?(delayCount+32'd1):delayCount;
		end
	end
end
wire delayTriggerIn=((delayCount>delayTriggerTime)?1'd1:1'd0);
/*延迟触发信号信号上升沿检测*/
wire delayTriggerInPosTemp;
PosedgeDecMod delayTriggerInPosDec(.clk(clk),.in(delayTriggerIn),.out(delayTriggerInPosTemp));
wire delayTriggerInPos=delayTriggerInPosTemp&(~stateReg[0]);

/******************************************************************************
adc采样时钟产生
******************************************************************************/
reg[3:0] clkDivCount=4'd0;
reg[3:0] clkPhase=4'd0;/*时钟相位*/
reg[3:0] clkPhaseDelayCount=4'd0;
always @(posedge clk or negedge rest or posedge delayTriggerInPos) begin
	if((!rest)||delayTriggerInPos) begin
		clkDivCount<=4'd0;
		clkPhaseDelayCount<=clkPhase;
	end
	else begin
		clkDivCount<=(clkPhaseDelayCount!=4'd0)?4'd0:(clkDivCount+4'd1);
		clkPhaseDelayCount<=(clkPhaseDelayCount!=4'd0)?(clkPhaseDelayCount-4'd1):4'd0;
	end
end

assign adc_sampStartupClk=clkDivCount[2];/*8分频*/

/******************************************************************************
adc时钟计数
******************************************************************************/
reg[15:0] adcClockCount=16'd0;
always @(posedge clk or negedge rest or posedge delayTriggerInPos) begin
	if((!rest)||delayTriggerInPos) begin
		adcClockCount<=16'd0;
	end
	else begin
		adcClockCount<=(adcClockCount<16'hffff)?(adcClockCount+{15'd0,adc_sampStartupClkPos}):adcClockCount;
	end
end

/******************************************************************************
RAM写控制
******************************************************************************/
assign RecordRAM_WriteClock=clk;
assign RecordRAM_WriteEN=adc_sampDoneTriggerPos&&(adcClockCount>waitAdcSampDoneClkNum)&&(adcClockCount<=(waitAdcSampDoneClkNum+onceRecordNum));
assign RecordRAM_WriteData=adc_value;
always @(posedge clk or negedge rest) begin
	if(!rest) begin
		RecordRAM_WriteAddress<=13'd0;
	end
	else begin
		if(delayTriggerInPos) begin
			RecordRAM_WriteAddress<=clkPhase;
		end
		else begin
			RecordRAM_WriteAddress<=RecordRAM_WriteEN?(RecordRAM_WriteAddress+recordStep[12:0]):RecordRAM_WriteAddress;
		end
	end
end

wire singleWriteDone=(adcClockCount>(waitAdcSampDoneClkNum+onceRecordNum))?1'd1:1'd0;

/******************************************************************************
采样控制状态机
******************************************************************************/
parameter state_idle=4'd0,
			 state_waitDelayTriggerIn=4'd1,
			 state_waitSingleWriteDone=4'd2,
			 state_singleSampDone=4'd3,
			 state_sampDone=4'd4;
reg[3:0] state=state_idle,next_state=state_idle;
/*状态机第一部分*/
always @(posedge clk or negedge rest) begin
	if(!rest) begin
		state<=state_idle;
	end
	else begin
		state<=next_state;
	end
end
/*状态机第二部分*/
always @(*) begin
	if(!rest) begin
		next_state=state_idle;
	end
	else begin
		case(state)
			state_idle:begin
					next_state=(inputCmdTriggerPos&(inputCmd[31:28]==4'h1))?state_waitDelayTriggerIn:state_idle;
				end
			state_waitDelayTriggerIn:begin
					next_state=delayTriggerInPos?state_waitSingleWriteDone:state_waitDelayTriggerIn;
				end
			state_waitSingleWriteDone:begin
					next_state=singleWriteDone?state_singleSampDone:state_waitSingleWriteDone;
				end
			state_singleSampDone:begin
					next_state=(clkPhase==4'd7)?state_sampDone:state_waitDelayTriggerIn;
				end
			state_sampDone:begin
					next_state=state_idle;
				end
			default:begin
					next_state=state_idle;
				end
		endcase
	end
end
/*状态机第三部分*/
always @(posedge clk or negedge rest) begin
	if(!rest) begin
	end
	else begin
		case(state)
			state_idle:begin
					triggerInDecStart<=1'd0;
				end
			state_waitDelayTriggerIn:begin
					stateReg[0]<=1'd0;
					triggerInDecStart<=1'd1;
				end
			state_singleSampDone:begin
					triggerInDecStart<=1'd0;
					clkPhase=(clkPhase>=4'd7)?4'd0:(clkPhase+4'd1);
				end
			state_sampDone:begin
					stateReg[0]<=1'd1;
				end
			default:begin
				end
		endcase
	end
end
/******************************************************************************
RAM读控制
******************************************************************************/
assign RecordRAM_ReadAddress=inputCmd[12:0];
assign RecordRAM_ReadClock=clk;

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
						4'd2:begin
								next_cmdState=cmd_getValue;
							end
						4'd3:begin
								next_cmdState=cmd_setValue;
							end
						default:begin
								next_cmdState=state_idle;
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
						4'd0:begin
								outputValue<={16'd0,ID};
							end
						4'd1:begin
								outputValue<={16'd0,stateReg};
							end
						4'd2:begin
								outputValue<={16'd0,RecordRAM_ReadData};
							end
						default:begin
								outputValue<=32'hA55AAA55;
							end
					endcase
				end
			cmd_setValue:begin
					case(inputCmd[27:24])
						4'd1:begin
								delayTriggerTime[31:16]<=inputCmd[15:0];
							end
						4'd2:begin
								delayTriggerTime[15:0]<=inputCmd[15:0];
							end
						4'd3:begin
								recordStep<=inputCmd[15:0];
							end
						4'd4:begin
								onceRecordNum<=inputCmd[15:0];
							end
					endcase
				end
			default:begin
				end
		endcase
	end
end
 
endmodule
