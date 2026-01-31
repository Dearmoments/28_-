#include "sys.h"
#include "delay.h"
#include "usart.h"
#include "sram.h"
#include "malloc.h"
#include "ILI93xx.h"
#include "led.h"
#include "timer.h"
#include "touch.h"
#include "GUI.h"
#include "GUIDemo.h"
#include "includes.h"
#include "StartupTask.h"
#include "SPI.h"
#include "DAC8560.h"

int main(void)
{
	OS_ERR err;
	CPU_SR_ALLOC();
	delay_init(168);       	//延时初始化
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 	//中断分组配置
	TFTLCD_Init();			//初始化LCD
	TP_Init();				//初始化触摸屏
	LED_Init();   			//LED初始化
	FSMC_SRAM_Init(); 		//SRAM初始化	
	mem_init(SRAMIN); 		//内部RAM初始化
	mem_init(SRAMEX); 		//外部RAM初始化
	mem_init(SRAMCCM);		//CCM初始化
  
  DAC8560_Init();
  
  
	OSInit(&err);		//初始化UCOSIII
  
	OS_CRITICAL_ENTER();//进入临界区
	OSTaskCreate(
		(OS_TCB 	* )&StartupTaskTCB,
		(CPU_CHAR	* )"StartupTaskTCB",
		(OS_TASK_PTR)StartupTask,
		(void *)0,
		(OS_PRIO)STARTUP_TASK_PRIO,
		(CPU_STK *)START_TASK_STK,
		(CPU_STK_SIZE)STARTUP_TASK_STK_SIZE/10,
		(CPU_STK_SIZE)STARTUP_TASK_STK_SIZE,
		(OS_MSG_QTY  )0,
		(OS_TICK	  )0,	
		(void   	* )0,
		(OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
		(OS_ERR 	* )&err
	);
	OS_CRITICAL_EXIT();	//退出临界区	 
	OSStart(&err);  //开启UCOSIII
  
	printf("error!");
	while(1);
}


