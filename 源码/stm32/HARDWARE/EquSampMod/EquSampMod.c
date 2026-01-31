#include "EquSampMod.h"

void EquSamp_Init(void)
{
  SPIInit();
}

uint16_t EquSamp_GetID(void)
{
  SPIReadWriteData((0x02<<28)|(0<<24));
  return SPIReadWriteData(0);
}

uint16_t EquSamp_GetStateReg(void)
{
  SPIReadWriteData((0x02<<28)|(1<<24));
  return SPIReadWriteData(0);
}
void EquSamp_SetDelayTriggerTime(uint32_t clkNum)
{
  SPIReadWriteData((0x03<<28)|(1<<24)|((clkNum>>16)&0xFFFF));
  SPIReadWriteData((0x03<<28)|(2<<24)|((clkNum>>0)&0xFFFF));
}
void EquSamp_StartSamp(void)
{
  SPIReadWriteData((0x01<<28));
}

void EquSamp_GetDatas(uint32_t addr,uint32_t num,int16_t *dataBuff)
{
  uint32_t i;
  SPIReadWriteData((0x02<<28)|(0x02<<24)|(addr++));
  for(i=0;i<num;i++)
  {
    dataBuff[i]=(int16_t)SPIReadWriteData((0x02<<28)|(0x02<<24)|(addr++));
  }
}
