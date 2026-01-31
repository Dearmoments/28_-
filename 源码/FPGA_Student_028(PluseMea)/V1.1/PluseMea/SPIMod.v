/***********************************************************
文件名:SPIMod.v
创建日期:2018年10月13日
版本:V1.0
修订日志:
    V1.0:模块发布
************************************************************/
module SPIMod #(
	parameter VALUE_WIDTH=16'd8)(
	clk,
	cs,
	sclk,
	mosi,
	miso,
	rest,
	inputValue,
	outputValue,
	dataLoadTrigger,
	dataOutTrigger
	);
/***数据位宽*************************************************/

/***端口声明*************************************************/
/*数据/控制线*/
input clk,sclk,mosi,cs,rest;
output reg miso;
/*需要通过SPI总线发送的数据*/
input[VALUE_WIDTH-1:0] inputValue;
/*在SPI总线上接收到的数据*/
output reg[VALUE_WIDTH-1:0] outputValue;
/*输出触发*/
output dataOutTrigger,dataLoadTrigger;


/***数据接收/发送*********************************************/
reg[VALUE_WIDTH-1:0] inputValueBuff,outputValueBuff;
reg[15:0] spiBitCounter;
wire spiClk=sclk&(~cs);
reg OutputTrigger,InputTrigger;
always @(negedge rest or posedge spiClk  or posedge cs) begin
	if(rest==0) begin
		spiBitCounter<=VALUE_WIDTH-8'd1;
		outputValueBuff<=0;
		outputValue<=0;
		miso<=0;
		OutputTrigger<=0;
		InputTrigger<=0;
	end
	else if(cs==1) begin
		spiBitCounter<=VALUE_WIDTH-8'd1;
		outputValueBuff<=0;
		miso<=0;
		OutputTrigger<=0;
		InputTrigger<=0;
	end
	else begin
		if(spiBitCounter==VALUE_WIDTH-8'd1) begin
			inputValueBuff<=inputValue;
			miso<=inputValue[VALUE_WIDTH-8'd1];
			outputValueBuff[spiBitCounter]<=mosi;
			OutputTrigger<=0;
			InputTrigger<=1;
		end
		else if(spiBitCounter==0) begin
			miso<=inputValueBuff[0];
			outputValue<=outputValueBuff+mosi;
			OutputTrigger<=1;
			InputTrigger<=0;
		end
		else begin
			miso<=inputValueBuff[spiBitCounter];
			outputValueBuff[spiBitCounter]<=mosi;
			OutputTrigger<=0;
			InputTrigger<=0;
		end
		spiBitCounter<=((spiBitCounter==0)?VALUE_WIDTH:spiBitCounter)-8'd1;
	end
end

/**********************************************
数据载入脉冲输出
***********************************************/
reg[3:0] dataOutTriggerCounter,dataLoadTriggerCounter;

reg NowOutputTrigger,NowInputTrigger,LastOutputTrigger,LastInputTrigger;
wire OutputTriggerPos,InputTriggerPos;

/*脉冲*/
assign dataOutTrigger=dataOutTriggerCounter[3];
assign dataLoadTrigger=dataLoadTriggerCounter[3];

/*上升沿检测*/
assign OutputTriggerPos=(~LastOutputTrigger)&NowOutputTrigger;
assign InputTriggerPos=(~LastInputTrigger)&NowInputTrigger;
/*InputTrigger数据移位*/
always @(posedge clk or negedge rest) begin
	if(rest==0) begin
		LastInputTrigger<=1;
		NowInputTrigger<=0;
	end
	else begin
		NowInputTrigger<=InputTrigger;
		LastInputTrigger<=NowInputTrigger;
	end
end
/*OutputTrigger数据移位*/
always @(posedge clk or negedge rest) begin
	if(rest==0) begin
		LastOutputTrigger<=1;
		NowOutputTrigger<=0;
	end
	else begin
		NowOutputTrigger<=OutputTrigger;
		LastOutputTrigger<=NowOutputTrigger;
	end
end
/*载入数据脉冲产生*/
always @(posedge clk or negedge rest) begin
	if(rest==0) begin
		dataLoadTriggerCounter<=0;
	end
	else begin
		if(InputTriggerPos==1) begin
			dataLoadTriggerCounter<=4'HF;
		end
		else begin
			dataLoadTriggerCounter<=(dataLoadTriggerCounter==4'H0)?(4'H0):(dataLoadTriggerCounter-4'H1);
		end
	end
end
/*数据输出脉冲产生*/
always @(posedge clk or negedge rest) begin
	if(rest==0) begin
		dataOutTriggerCounter<=0;
	end
	else begin
		if(OutputTriggerPos==1) begin
			dataOutTriggerCounter<=4'HF;
		end
		else begin
			dataOutTriggerCounter<=(dataOutTriggerCounter==4'H0)?(4'H0):(dataOutTriggerCounter-4'H1);
		end
	end
end

endmodule
