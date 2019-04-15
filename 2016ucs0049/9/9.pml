#define pwr_on 1
#define pwr_off 0
#define fan_on 1
#define fan_off 0

mtype = {Idle,Power,Fan};
chan idle_chan=[0] of {bit};
chan power_chan=[0] of {bit};
chan fan_chan=[0] of {bit};
byte state; 

proctype idle()//Idle state
{
	do
	::	atomic
		{
			idle_chan?pwr_off;//Waiting for power off signal
			state=Idle;
			printf("Idle State.\n");
		}
		do
		:: 	
			power_chan ! pwr_on;//Sending power on signal
			break;
		:: 	skip
		od
	::skip
	od
}

proctype power()//Power State
{
	do
	::	atomic
		{
			power_chan?pwr_on;//Waiting for power on signal
			state=Power;
			printf("Power State.\n");
		}
		do
		:: 	idle_chan!pwr_off;//Sending power off signal
			break;
		:: 	fan_chan!fan_on;//Sending fan on signal
			break;
		:: 	skip
		od
	:: 	atomic
		{
			power_chan?fan_off//Waiting for fan off signal
			state=Power;
			printf("Power State.\n");
		}
		do
		:: 	idle_chan!pwr_off;//Sending power off signal
			break;
		:: 	fan_chan!fan_on;//sending fan on signal
			break;
		:: 	skip
		od
	::	skip;
	od
}

proctype fan()//Fan state
{
	do
	::	atomic
		{
			fan_chan?fan_on;//Waiting for fan on signal
			state=Fan;
			printf("Fan State.\n");
		}
		do
		:: 	power_chan!fan_off;//Sending fan off signal
			break;
		:: 	idle_chan!pwr_off;//Sending power off signal
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
	idle_chan!pwr_off;//Sending power off signal
}