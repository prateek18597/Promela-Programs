#define pwr_on 1
#define pwr_off 0
#define fan_on 1
#define fan_off 0

mtype = {Idle,Power,Fan};
chan idle_chan=[0] of {bit};
chan power_chan=[0] of {bit};
chan fan_chan=[0] of {bit};
byte state; 

proctype idle()
{
	do
	::	atomic
		{
			idle_chan?pwr_off;
			state=Idle;
			printf("Idle State.\n");
		}
		do
		:: 	
			power_chan ! pwr_on;
			break;
		:: 	skip
		od
	::skip
	od
}

proctype power()
{
	do
	::	atomic
		{
			power_chan?pwr_on;
			state=Power;
			printf("Power State.\n");
		}
		do
		:: 	idle_chan!pwr_off;
			break;
		:: 	fan_chan!fan_on;
			break;
		:: 	skip
		od
	:: 	atomic
		{
			power_chan?fan_off
			state=Power;
			printf("Power State.\n");
		}
		do
		:: 	idle_chan!pwr_off;
			break;
		:: 	fan_chan!fan_on;
			break;
		:: 	skip
		od
	::	skip;
	od
}

proctype fan()
{
	do
	::	atomic
		{
			fan_chan?fan_on;
			state=Fan;
			printf("Fan State.\n");
		}
		do
		:: 	power_chan!fan_off;
			break;
		:: 	idle_chan!pwr_off;
			break;
		:: 	skip
		od
	:: 	skip;
	od
}

init
{
	atomic
	{
		run idle();
		run power();
		run fan();
	}
	idle_chan!pwr_off;
}