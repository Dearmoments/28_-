## Generated SDC file "01.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Full Version"

## DATE    "Wed Jul 10 08:02:29 2019"

##
## DEVICE  "EP4CE6E22C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]
create_clock -name {spi_cs} -period 1.000 -waveform { 0.000 0.500 } [get_ports {spi_cs}]
create_clock -name {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn} -period 1.000 -waveform { 0.000 0.500 } [get_registers {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}]
create_clock -name {rest} -period 1.000 -waveform { 0.000 0.500 } [get_ports {rest}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {PLL|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {PLL|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 4 -master_clock {clk} [get_pins {PLL|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -rise_to [get_clocks {spi_cs}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -fall_to [get_clocks {spi_cs}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {spi_cs}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -rise_to [get_clocks {spi_cs}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -fall_to [get_clocks {spi_cs}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {spi_cs}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rest}] -rise_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rest}] -fall_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rest}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {rest}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {rest}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {rest}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {rest}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rest}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rest}] -rise_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rest}] -fall_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rest}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {rest}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {rest}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {rest}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {rest}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rest}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {spi_cs}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {spi_cs}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {spi_cs}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {spi_cs}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {rest}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {rest}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {rest}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {rest}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {spi_cs}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {spi_cs}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {spi_cs}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {spi_cs}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {rest}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {rest}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {rest}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {rest}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {EquSampMod:EquSamp|PosedgeDecMod:triggerInDecStopPosDec|lastIn}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {spi_cs}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {PLL|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

