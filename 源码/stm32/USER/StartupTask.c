#include "StartupTask.h"

/***任务控制块******************************************************/
CPU_STK START_TASK_STK[STARTUP_TASK_STK_SIZE];
OS_TCB StartupTaskTCB;

/********************************************************************
函数原型:void StartupTask(void *p_arg)
功能:启动系统
输入参数:
  void *p_arg:任务参数,保留未用
返回值:无
*******************************************************************/
void StartupTask(void *p_arg)
{
  OS_ERR err;
	CPU_SR_ALLOC();
  
  #if	OS_CFG_SCHED_ROUND_ROBIN_EN  //当使用时间片轮转的时候
    OSSchedRoundRobinCfg(DEF_ENABLED,1,&err);//使能时间片轮转调度功能,时间片长度为1个系统时钟节拍，既1*5=5ms
  #endif
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_CRC,ENABLE);//开启CRC时钟
	WM_SetCreateFlags(WM_CF_MEMDEV);
	GUI_Init();  			//STemWin初始化
  
  OS_CRITICAL_ENTER();	//进入临界区
  /****创建GUI更新任务**********************************/
  OSTaskCreate(
    (OS_TCB 		*)&GUIExecTaskTCB,
    (CPU_CHAR 	*)"GUIExecTask",
    (OS_TASK_PTR )GUIExecTask,
    (void				*)0,
    (OS_PRIO		 )GUIEXEC_TASK_PRIO,
    (CPU_STK 		*)GUIEXEC_TASK_STK,
    (CPU_STK_SIZE)GUIEXEC_TASK_STK_SIZE/10,	//任务堆栈深度限位
    (CPU_STK_SIZE)GUIEXEC_TASK_STK_SIZE,		//任务堆栈大小
    (OS_MSG_QTY  )0,					//任务内部消息队列能够接收的最大消息数目,为0时禁止接收消息
    (OS_TICK	   )0,					//当使能时间片轮转时的时间片长度，为0时为默认长度，
    (void   	  *)0,					//用户补充的存储区
    (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
    ( OS_ERR 	  *)&err
  );
  /****创建触摸任务**********************************/
  OSTaskCreate(
    (OS_TCB 		*)&TouchTaskTCB,
    (CPU_CHAR 	*)"TouchTask",
    (OS_TASK_PTR )TouchTask,
    (void				*)0,
    (OS_PRIO		 )TOUCH_TASK_PRIO,
    (CPU_STK 		*)TOUCH_TASK_STK,
    (CPU_STK_SIZE)TOUCH_TASK_STK_SIZE/10,	//任务堆栈深度限位
    (CPU_STK_SIZE)TOUCH_TASK_STK_SIZE,		//任务堆栈大小
    (OS_MSG_QTY  )0,					//任务内部消息队列能够接收的最大消息数目,为0时禁止接收消息
    (OS_TICK	   )0,					//当使能时间片轮转时的时间片长度，为0时为默认长度，
    (void   	  *)0,					//用户补充的存储区
    (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
    ( OS_ERR 	  *)&err
  );
  /****创建主线任务**********************************/
  OSTaskCreate(
    (OS_TCB 		*)&UserMainTaskTCB,
    (CPU_CHAR 	*)"UserMainTask",
    (OS_TASK_PTR )UserMainTask,
    (void				*)0,
    (OS_PRIO		 )USER_MAIN_TASK_PRIO,
    (CPU_STK 		*)USER_MAIN_TASK_STK,
    (CPU_STK_SIZE)USER_MAIN_TASK_STK_SIZE/10,	//任务堆栈深度限位
    (CPU_STK_SIZE)USER_MAIN_TASK_STK_SIZE,		//任务堆栈大小
    (OS_MSG_QTY  )0,					//任务内部消息队列能够接收的最大消息数目,为0时禁止接收消息
    (OS_TICK	   )0,					//当使能时间片轮转时的时间片长度，为0时为默认长度，
    (void   	  *)0,					//用户补充的存储区
    (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
    ( OS_ERR 	  *)&err
  );
  OS_CRITICAL_EXIT();	//退出临界区
  OS_TaskSuspend((OS_TCB*)&StartupTaskTCB,&err);		//挂起开始任务			 
}
