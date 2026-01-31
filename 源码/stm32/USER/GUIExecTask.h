#ifndef __GUIEXECTASK_H
#define __GUIEXECTASK_H

#include "includes.h"
#include "GUI.h"

/*任务优先级*/
#define GUIEXEC_TASK_PRIO							10
/*任务堆栈大小*/
#define GUIEXEC_TASK_STK_SIZE 				1024
/*任务控制块*/
extern OS_TCB 	GUIExecTaskTCB;
/*任务堆栈*/
extern CPU_STK GUIEXEC_TASK_STK[GUIEXEC_TASK_STK_SIZE];

extern void GUIExecTask(void *arg);

#endif
