#ifndef __MAINTASK_H
#define __MAINTASK_H

#include "includes.h"
#include "GUIExecTask.h"

#include "GUI.h"
#include "WM.h"
#include "DIALOG.h"
#include "BUTTON.h"

#include "EquSampMod.h"
#include "FreAndDutyCmd.h"

#define SAMP_PERIOD                     (1.0/300e6*1e9)

/*任务优先级*/
#define USER_MAIN_TASK_PRIO				      11
/*任务堆栈大小*/
#define USER_MAIN_TASK_STK_SIZE 				1024
/*任务控制块*/
extern OS_TCB UserMainTaskTCB;


typedef struct
{
  double frequency;
  double dutyRatio;
  double amplitude;
  double riseTime;
  double fallTime;
  WM_HWIN hListView;
  WM_HWIN hGraph;
  uint32_t runEN:1;
}GlobalType;
extern GlobalType Global;

/*任务堆栈*/
extern CPU_STK USER_MAIN_TASK_STK[USER_MAIN_TASK_STK_SIZE];

extern WM_HWIN CreatePulseParameterMeasurement(void);

extern void UserMainTask(void *p_arg);

#endif
