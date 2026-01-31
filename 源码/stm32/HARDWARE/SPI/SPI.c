#include "SPI.h"

void SPIInit(void)
{
	GPIO_InitTypeDef GPIO_InitStruct;
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB,ENABLE);
	/*CS,SCLK,MOSI*/
	GPIO_InitStruct.GPIO_Mode=GPIO_Mode_OUT;
	GPIO_InitStruct.GPIO_Pin=GPIO_Pin_6|GPIO_Pin_7|GPIO_Pin_8;
	GPIO_InitStruct.GPIO_Speed=GPIO_Speed_50MHz;
	GPIO_Init(GPIOB,&GPIO_InitStruct);
	
	/*MISO*/
	GPIO_InitStruct.GPIO_Mode=GPIO_Mode_IN;
	GPIO_InitStruct.GPIO_Pin=GPIO_Pin_5;
	GPIO_Init(GPIOB,&GPIO_InitStruct);
	
  SPI_CS_set();
  SPI_SCLK_res();
}
uint32_t SPIReadWriteData(uint32_t data)
{
  uint32_t i,temp=0;
  SPI_CS_res();
  for(i=0;i<32;i++)
  {
    if(data&0x80000000)
    {
      SPI_MOSI_set();
    }
    else
    {
      SPI_MOSI_res();
    }
    SPI_SCLK_set();
    temp<<=1;
    data<<=1;
    SPI_SCLK_res();
    temp|=SPI_MISO_read();
  }
  SPI_CS_set();
  return temp;
}
