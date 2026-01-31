#include "TouchTask.h"

/***任务控制块******************************************************/
CPU_STK TOUCH_TASK_STK[GUIEXEC_TASK_STK_SIZE];
OS_TCB 	TouchTaskTCB;

/********************************************************************
函数原型:TouchTask(void *arg)
功能:触摸处理
输入参数:
  void *arg:任务参数,保留未用
返回值:无
*******************************************************************/
void TouchTask(void *arg)
{
  OS_ERR err;
	while(1)
  {
    GUI_TOUCH_Exec();
    OSTimeDlyHMSM(0,0,0,5,OS_OPT_TIME_PERIODIC,&err);//延时5ms
  }
}
