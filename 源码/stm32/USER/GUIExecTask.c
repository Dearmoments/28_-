#include "GUIExecTask.h"

/***任务控制块******************************************************/
CPU_STK GUIEXEC_TASK_STK[GUIEXEC_TASK_STK_SIZE];
OS_TCB 	GUIExecTaskTCB;

/********************************************************************
函数原型:void GUIExecTask(void *arg)
功能:执行GUI更新函数
输入参数:
  void *arg:任务参数,保留未用
返回值:无
*******************************************************************/
void GUIExecTask(void *arg)
{
  OS_ERR err;
	while(1)
  {
    GUI_Exec();
    OSTimeDly(10,OS_OPT_TIME_DLY,&err);
  }
}
