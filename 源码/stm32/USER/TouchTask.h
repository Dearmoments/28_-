#ifndef __TOUCHTASK_H
#define __TOUCHTASK_H

#include "includes.h"
#include "GUIExecTask.h"

#include "GUI.h"
#include "WM.h"
#include "DIALOG.h"
#include "BUTTON.h"

/*任务优先级*/
#define TOUCH_TASK_PRIO				      4
/*任务堆栈大小*/
#define TOUCH_TASK_STK_SIZE 				1024
/*任务控制块*/
extern OS_TCB TouchTaskTCB;

/*任务堆栈*/
extern CPU_STK TOUCH_TASK_STK[TOUCH_TASK_STK_SIZE];


extern void TouchTask(void *p_arg);

#endif
