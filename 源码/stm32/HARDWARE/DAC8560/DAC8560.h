#ifndef __DAC8560_H
#define __DAC8560_H

#include "stm32f4xx.h"
#include "stdint.h"

#define DAC8560_DIN_Set()                     do{GPIOC->ODR|=1<<4;}while(0)
#define DAC8560_DIN_Res()                     do{GPIOC->ODR&=~(1<<4);}while(0)
#define DAC8560_SCLK_Set()                    do{GPIOC->ODR|=1<<2;}while(0)
#define DAC8560_SCLK_Res()                    do{GPIOC->ODR&=~(1<<2);}while(0)
#define DAC8560_SYNS_Set()                    do{GPIOC->ODR|=1<<0;}while(0)
#define DAC8560_SYNS_Res()                    do{GPIOC->ODR&=~(1<<0);}while(0)

extern void DAC8560_Init(void);
extern void DAC8560_DisenableInternalVref(void);
extern void DAC8560_EnableInternalVref(void);
extern void DAC8560_SetData(uint16_t data);

#endif
