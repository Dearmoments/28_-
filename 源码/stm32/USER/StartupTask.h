#ifndef __STARTUPTASK_H
#define __STARTUPTASK_H

#include "includes.h"
#include "WM.h"

#include "GUIExecTask.h"
#include "UserMainTask.h"
#include "TouchTask.h"

/*任务优先级*/
#define STARTUP_TASK_PRIO				3
/*任务堆栈大小*/
#define STARTUP_TASK_STK_SIZE 				1024
/*任务控制块*/
extern OS_TCB StartupTaskTCB;

/*任务堆栈*/
extern CPU_STK START_TASK_STK[STARTUP_TASK_STK_SIZE];

extern void StartupTask(void *p_arg);

#endif
