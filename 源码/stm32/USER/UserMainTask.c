#include "UserMainTask.h"

/***任务控制块******************************************************/
CPU_STK USER_MAIN_TASK_STK[USER_MAIN_TASK_STK_SIZE];
OS_TCB UserMainTaskTCB;

void DataToPoint(GUI_POINT *pointBuff,const int16_t *dataBuff,uint32_t num)
{
  int16_t i;
  if((pointBuff==NULL)||(dataBuff==NULL))
  {
    return;
  }
  for(i=0;i<num;i++)
  {
    pointBuff[i].x=i*SAMP_PERIOD/1.5;
    pointBuff[i].y=dataBuff[i]/256;
  }
}

struct
{
  uint16_t count[256];
  double sum[256];
}Statistics;
uint8_t GetState(double lt,double ut,double data)
{
  uint8_t state;
  if(data<lt)
  {
    state=0;
  }
  else if((data>=lt)&&(data<ut))
  {
    state=1;
  }
  else
  {
    state=2;
  }
  return state;
}
double GetSlopeFactor(const int16_t *dataBuff,uint32_t num)
{
  uint16_t i;
  double xy=0,x=0,y=0,xx=0;
  for(i=0;i<num;i++)
  {
    xy+=i*dataBuff[i];
    x+=i;
    y+=dataBuff[i];
    xx+=i*i;
  }
  return (num*xy-x*y)/(num*xx-x*x);
}
void GetWaveInfo(const int16_t* waveBuff,uint32_t num,double *riseTime,double *fallTime,double *amplitude,double *dutyFactor)
{
  uint32_t i,index,maxIndex_1,maxIndex_2,max_1,max_2,index_1,index_2,riseSlopeCount,fallSlopeCount;
  double max,min,avg,ut,lt,k,amp,riseSlopeSum,fallSlopeSum;
  uint8_t lastState,nowState,sloveEN=0;
  for(i=0;i<256;i++)
  {
    Statistics.count[i]=0;
    Statistics.sum[i]=0;
  }
  for(i=0;i<num;i++)
  {
    index=waveBuff[i]/256+128;
    Statistics.count[index]++;
    Statistics.sum[index]+=waveBuff[i];
  }
  max_1=Statistics.count[0];
  maxIndex_1=0;
  for(i=1;i<10;i++)
  {
    if(Statistics.count[i]>max_1)
    {
      max_1=Statistics.count[i];
      maxIndex_1=i;
    }
  }
  
  maxIndex_2=Statistics.count[10];
  max_2=Statistics.sum[10];
  for(i=10;i<256;i++)
  {
    if(Statistics.count[i]>max_2)
    {
      max_2=Statistics.count[i];
      maxIndex_2=i;
    }
  }
  max=Statistics.sum[maxIndex_2]/Statistics.count[maxIndex_2];
  min=Statistics.sum[maxIndex_1]/Statistics.count[maxIndex_1];
  avg=(max+min)/2;
  amp=max-min;
  lt=avg-amp*0.3;
  ut=avg+amp*0.3;
  
  lastState=GetState(lt,ut,waveBuff[0]);
  riseSlopeCount=fallSlopeCount= riseSlopeSum=fallSlopeSum=0;
  
  for(i=1;i<num;i++)
  {
    nowState=GetState(lt,ut,waveBuff[i]);
    if((lastState==0)&&(nowState==1))
    {
      index_1=i;
      sloveEN=1;
    }
    if((lastState==1)&&(nowState==2)&&sloveEN)
    {
      index_2=i-1;
      k=GetSlopeFactor(&waveBuff[index_1],index_2-index_1);
      riseSlopeCount++;
      riseSlopeSum+=k;
    }
    if((lastState==2)&&(nowState==1))
    {
      index_1=i;
      sloveEN=1;
    }
    if((lastState==1)&&(nowState==0)&&sloveEN)
    {
      index_2=i-1;
      k=GetSlopeFactor(&waveBuff[index_1],index_2-index_1);
      fallSlopeCount++;
      fallSlopeSum+=k;
    }
    lastState=nowState;
  }
  
  *riseTime=amp/(riseSlopeSum/riseSlopeCount)*SAMP_PERIOD*0.8;
  *fallTime=-amp/(fallSlopeSum/fallSlopeCount)*SAMP_PERIOD*0.8;
  *amplitude=amp;
  *dutyFactor=1;
}
uint32_t GetTapStep(void)
{
  SPIReadWriteData((0x05<<28)|(0x04<<24));
  return SPIReadWriteData(0x00);
}
void TapStepClear(void)
{
  SPIReadWriteData(0x06<<28);
}

void SetSwitch(uint8_t sel)
{
  GPIOA->ODR|=(0x0F<<8);
  GPIOA->ODR&=sel?(~(0xA<<8)):(~(0x5<<8));
}
/********************************************************************
函数原型:void UserMainTask(void *arg)
功能:主线任务(负责事务逻辑)
输入参数:
  void *p_arg:任务参数,保留未用
返回值:无
*******************************************************************/

GlobalType Global;
int16_t dataBuff[8192];
char sprintfBuff[128];

GUI_POINT graphPointBuff[8192];

void UserMainTask(void *arg)
{
  OS_ERR err;
  uint32_t tapStep;
  WM_HWIN hItem;
  uint16_t i=0;
  double dutyFactor;
  GPIO_InitTypeDef GPIO_InitStruct;
  CPU_SR_ALLOC();
  GRAPH_DATA_Handle hGraphData;
  //更换皮肤
	BUTTON_SetDefaultSkin(BUTTON_SKIN_FLEX); 
	CHECKBOX_SetDefaultSkin(CHECKBOX_SKIN_FLEX);
	DROPDOWN_SetDefaultSkin(DROPDOWN_SKIN_FLEX);
	FRAMEWIN_SetDefaultSkin(FRAMEWIN_SKIN_FLEX);
	HEADER_SetDefaultSkin(HEADER_SKIN_FLEX);
	MENU_SetDefaultSkin(MENU_SKIN_FLEX);
	MULTIPAGE_SetDefaultSkin(MULTIPAGE_SKIN_FLEX);
	PROGBAR_SetDefaultSkin(PROGBAR_SKIN_FLEX);
	RADIO_SetDefaultSkin(RADIO_SKIN_FLEX);
	SCROLLBAR_SetDefaultSkin(SCROLLBAR_SKIN_FLEX);
	SLIDER_SetDefaultSkin(SLIDER_SKIN_FLEX);
	SPINBOX_SetDefaultSkin(SPINBOX_SKIN_FLEX);
  
  
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA,ENABLE);
	/*CS,SCLK,MOSI*/
	GPIO_InitStruct.GPIO_Mode=GPIO_Mode_OUT;
	GPIO_InitStruct.GPIO_Pin=GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_11;
	GPIO_InitStruct.GPIO_Speed=GPIO_Speed_50MHz;
	GPIO_Init(GPIOA,&GPIO_InitStruct);
  
  EquSamp_Init();
  FreAndDutyCmd_Init();
  
  CreatePulseParameterMeasurement();
  
  hGraphData=GRAPH_DATA_XY_Create(GUI_BLUE,1000,NULL,0);
  GRAPH_DATA_XY_SetOffX(hGraphData,-8192+750);
  GRAPH_AttachData(Global.hGraph,hGraphData);
  
  while(1)
  {
    if(Global.runEN)
    {
      Global.frequency=FreAndDutyCmd_GetFrequency();
      Global.dutyRatio=FreAndDutyCmd_GetDutyRatio();
      if(Global.frequency<100e3)
      {
        EquSamp_SetDelayTriggerTime((1-Global.dutyRatio)/Global.frequency*300e6-1000);
      }
      EquSamp_StartSamp();
      do
      {
        i=EquSamp_GetStateReg();
      }
      while(!(i&0x01));
      EquSamp_GetDatas(0,8192,dataBuff);
      
      DataToPoint(graphPointBuff,dataBuff,8192);
      OS_CRITICAL_ENTER();
      GRAPH_DetachData(Global.hGraph,hGraphData);
      GRAPH_DATA_XY_Delete(hGraphData);
      hGraphData=GRAPH_DATA_XY_Create(GUI_BLUE,8192,graphPointBuff,8192);
      GRAPH_DATA_XY_SetOffX(hGraphData,-8192+750);
      GRAPH_DATA_XY_SetOffY(hGraphData,150);
      GRAPH_AttachData(Global.hGraph,hGraphData);
      OS_CRITICAL_EXIT();
      
      GetWaveInfo(dataBuff,8192,&Global.riseTime,&Global.fallTime,&Global.amplitude,&dutyFactor);
      Global.dutyRatio*=dutyFactor;
      
      Global.amplitude/=((GPIOA->ODR>>8)&0xF)==0x0A?(58874/10.0):63564.0;
      
      Global.amplitude*=1.01;
      
      if(Global.amplitude>1.02)
      {
        SetSwitch(0);
      }
      else if(Global.amplitude<0.98)
      {
        SetSwitch(1);
      }

      for(i=0;i<1024;i++)
      {
        printf("%d\r\n",dataBuff[i]);
      }
      
      sprintf(sprintfBuff,"%.3fHZ",Global.frequency);
      LISTVIEW_SetItemText(Global.hListView,1,0,sprintfBuff);
      
      sprintf(sprintfBuff,"%.3f%%",Global.dutyRatio*100);
      LISTVIEW_SetItemText(Global.hListView,1,1,sprintfBuff);
      
      sprintf(sprintfBuff,"%.3f",Global.amplitude);
      LISTVIEW_SetItemText(Global.hListView,1,2,sprintfBuff);
      
      sprintf(sprintfBuff,"%.3f",Global.riseTime);
      LISTVIEW_SetItemText(Global.hListView,1,3,sprintfBuff);
      
      sprintf(sprintfBuff,"%.3f",Global.fallTime);
      LISTVIEW_SetItemText(Global.hListView,1,4,sprintfBuff);
    }
  }
}
