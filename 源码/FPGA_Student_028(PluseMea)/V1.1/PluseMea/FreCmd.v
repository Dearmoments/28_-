module FreCmd(
		input clk,
		input rst,
		input [31:0] fx_data,
		input [31:0] fs_data,
		input [31:0] duty_cycle_data,
		input [31:0] spi_outputvalue,
		input spi_dataouttrigger,
		output reg [31:0] spi_inputvalue,
		output reg [31:0] Gate_Time,
		input[3:0] tapStep
);

parameter state_idle=4'd0,
			 state_init=4'd1,
			 state_setvalue=4'd2,
			 state_getvalue=4'd3;
			 
reg[3:0] state=state_idle,next_state=state_idle;

//spi_dataouttrigger上升沿检测
reg spi_dataouttrigger1,spi_dataouttrigger2;
wire spi_dataouttrigger_pos=spi_dataouttrigger1&~spi_dataouttrigger2;
always @(posedge clk or negedge rst) begin
		if(rst==0) begin
			spi_dataouttrigger1<=0;
			spi_dataouttrigger2<=0;
		end
		else begin
			spi_dataouttrigger1<=spi_dataouttrigger;
			spi_dataouttrigger2<=spi_dataouttrigger1;
		end
end

//命令处理状态机
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		state<=state_idle;
	end
	else begin
		state<=next_state;
	end
end

always @(*) begin
	if(!rst) begin
		next_state<=state_idle;
	end
	else begin
		case(state)
			state_idle:begin
					next_state<=spi_dataouttrigger_pos?state_init:state_idle;
				end
			state_init:begin
					case(spi_outputvalue[31:28])
						4'd4:next_state<=state_setvalue;
						4'd5:next_state<=state_getvalue;
						default:begin
								next_state<=state_idle;
							end
					endcase
				end
			state_setvalue:begin
					next_state<=state_idle;
				end
			state_getvalue:begin
					next_state<=state_idle;
				end
			default:begin
					next_state<=state_idle;
				end
		endcase
	end
end

always @(posedge clk) begin
    case(state)
        state_getvalue:begin
                case(spi_outputvalue[27:24])
                    0:spi_inputvalue=fx_data;
                    1:spi_inputvalue=fs_data;
						  2:spi_inputvalue=duty_cycle_data;
						  3:spi_inputvalue=16'h5AA5;
						  4:spi_inputvalue={28'd0,tapStep};
                endcase
            end
        state_setvalue:begin
					Gate_Time={8'd0,spi_outputvalue[23:0]};
            end
    endcase
end

endmodule 