#ifndef __FreAndDutyCmd__H
#define __FreAndDutyCmd__H

#include "spi.h"

#define Fs  50e6

extern double FreAndDutyCmd_GetFrequency(void);
extern double FreAndDutyCmd_GetDutyRatio(void);
extern void FreAndDutyCmd_Init(void);
#endif

