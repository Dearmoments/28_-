#include "FreAndDutyCmd.h"

void FreAndDutyCmd_Init(void)
{
	SPIInit();
}

double FreAndDutyCmd_GetFrequency(void)
{
	double Fre;
	uint32_t Fx_data,Fs_data;
	
	SPIReadWriteData((0x05<<28)|(0x00<<24));
	Fx_data=SPIReadWriteData((0x05<<28)|(0x01<<24));
	Fs_data=SPIReadWriteData(0xffffffff);
	Fre=Fx_data/(double)(Fs_data/Fs);
	return Fre;
}

double FreAndDutyCmd_GetDutyRatio(void)
{
	double Duty_cycle;
	uint32_t Fs_Data,Duty_cycle_data;
	
	SPIReadWriteData((0x05<<28)|(0x01<<24));
	Fs_Data=SPIReadWriteData((0x05<<28)|(0x02<<24));
	Duty_cycle_data=SPIReadWriteData(0xffffffff);
	Duty_cycle=(double)Duty_cycle_data/Fs_Data;
	return Duty_cycle;
}



