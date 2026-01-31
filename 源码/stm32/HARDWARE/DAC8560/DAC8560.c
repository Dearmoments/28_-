#include "DAC8560.h"

static void WriteData(uint32_t data)
{
  uint16_t i;
  DAC8560_SYNS_Set();
  DAC8560_SCLK_Set();
  DAC8560_SYNS_Res();
  for(i=0;i<24;i++)
  {
    DAC8560_SCLK_Set();
    if(data&0x800000)
    {
      DAC8560_DIN_Set();
    }
    else
    {
      DAC8560_DIN_Res();
    }
    DAC8560_SCLK_Res();
    data<<=1;
  }
  DAC8560_SYNS_Set();
  DAC8560_SCLK_Set();
}

void DAC8560_Init(void)
{
  /************************************************************
  使用者实现:GPIO初始化
  *************************************************************/
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC,ENABLE);
	GPIO_InitTypeDef GPIO_InitStruct;
	GPIO_InitStruct.GPIO_Pin=GPIO_Pin_0|GPIO_Pin_2|GPIO_Pin_4;
	GPIO_InitStruct.GPIO_Mode=GPIO_Mode_OUT;
	GPIO_InitStruct.GPIO_Speed=GPIO_High_Speed;
	GPIO_Init(GPIOC,&GPIO_InitStruct);
  /************************************************************
  使用者无需修改
  *************************************************************/
  DAC8560_SYNS_Set();
  DAC8560_SCLK_Set();
}

void DAC8560_DisenableInternalVref(void)
{
  WriteData(0x480401);
}

void DAC8560_EnableInternalVref(void)
{
  WriteData(0x4C0400);
  WriteData(0x490400);
}

void DAC8560_SetData(uint16_t data)
{
  data&=0x00FFFFFF;
  WriteData(data|(uint32_t)0<<17);
}


