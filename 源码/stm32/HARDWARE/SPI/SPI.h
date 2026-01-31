#ifndef __SPI_H
#define __SPI_H

#include "stm32f4xx.h"
#include "stdint.h"

#define SPI_CS_set()              do{GPIOB->ODR|=1<<8;}while(0)
#define SPI_CS_res()              do{GPIOB->ODR&=~(1<<8);}while(0)
#define SPI_SCLK_set()            do{GPIOB->ODR|=1<<7;}while(0)
#define SPI_SCLK_res()            do{GPIOB->ODR&=~(1<<7);}while(0)
#define SPI_MOSI_set()            do{GPIOB->ODR|=1<<6;}while(0)
#define SPI_MOSI_res()            do{GPIOB->ODR&=~(1<<6);}while(0)
#define SPI_MISO_read()           ((GPIOB->IDR>>5)&0x01)

extern void SPIInit(void); 
extern uint32_t SPIReadWriteData(uint32_t data);

#endif
