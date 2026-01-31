#ifndef __EQUSAMPMOD_H
#define __EQUSAMPMOD_H

#include "SPI.h"
#include "stdint.h"

extern void EquSamp_Init(void);
extern uint16_t EquSamp_GetID(void);
extern uint16_t EquSamp_GetStateReg(void);
extern void EquSamp_SetDelayTriggerTime(uint32_t clkNum);
extern uint16_t EquSamp_GetData(uint32_t addr);
extern void EquSamp_StartSamp(void);
extern void EquSamp_GetDatas(uint32_t addr,uint32_t num,int16_t *dataBuff);

#endif
