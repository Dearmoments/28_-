module TopMod(
	clk,
	rest,
	spi_cs,
	spi_sclk,
	spi_mosi,
	spi_miso,
	ads5553_clkOut,
	ads5553_clkIn,
	ads5553_data,
	triggerIn,
	overDec
);
input clk,rest;
input ads5553_clkOut;
output ads5553_clkIn;
input[13:0] ads5553_data;
input spi_cs,spi_sclk,spi_mosi;
output spi_miso;
input triggerIn;
input overDec;

wire nTriggerIn=~triggerIn;

wire clk_hs;
PLLMod PLL(
	.inclk0(clk),
	.c0(clk_hs)
);

wire[31:0] spi_inputValue;
wire[31:0] spi_outputValue;
wire spi_outputValueTrigger;
SPIMod #(
	.VALUE_WIDTH(16'd32)) 
	SPI(
	.clk(clk),
	.cs(spi_cs),
	.sclk(spi_sclk),
	.mosi(spi_mosi),
	.miso(spi_miso),
	.rest(rest),
	.inputValue(spi_inputValue),
	.outputValue(spi_outputValue),
	.dataLoadTrigger(),
	.dataOutTrigger(spi_outputValueTrigger)
);


wire[31:0] equSamp_outputValue;
EquSampMod EquSamp(
   .clk(clk_hs),                       			/*时钟*/
   .rest(rest),                      				/*复位*/
   .adc_sampStartupClk(ads5553_clkIn),        	/*adc采样启动触发时钟*/
   .adc_sampDoneTrigger(ads5553_clkOut),       	/*adc采样完成触发输入*/
   .adc_value({ads5553_data,2'd0}),             /*adc数据输入*/
	.triggerIn(triggerIn),                 		/*触发信号输入*/
   .inputCmd(spi_outputValue),                  /*指令输入*/
	.inputCmdTrigger(spi_outputValueTrigger),    /*指令输入触发*/
   .outputValue(equSamp_outputValue)            /*数据输出*/
);


wire [31:0] fx_data,fs_data,duty_cycle_data;

Freq_measure U1(
	.clk_fs(clk),
	.clk_fx(nTriggerIn),
	.fs_cnt_buff(fs_data),
	.fx_cnt_buff(fx_data),			
	.duty_cycle_data(duty_cycle_data)
);

wire[31:0] freMea_outputValue;
FreCmd U2(
		.clk(clk),
		.rst(rest),
		.fx_data(fx_data),
		.fs_data(fs_data),
		.duty_cycle_data(duty_cycle_data),
		.spi_outputvalue(spi_outputValue),
		.spi_dataouttrigger(spi_outputValueTrigger),
		.spi_inputvalue(freMea_outputValue),
);

assign spi_inputValue=((spi_outputValue[31:28]==4'd1)||(spi_outputValue[31:28]==4'd2)||(spi_outputValue[31:28]==4'd3))?equSamp_outputValue:freMea_outputValue;

endmodule
