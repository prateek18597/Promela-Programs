#define On 1
#define Off 0

mtype = { Red , Orange , Green };

byte s1_status;
byte s2_status;
bit sensor_status;

chan chan_s1=[0] of {byte};

chan chan_s2=[0] of {byte};

chan chan_sensor=[0] of {bit};

proctype HighwaySignal(mtype status)
{
	s1_status=status;
	
	do
	:: 	
		if
		::
			atomic
			{
				chan_sensor?On;			
				s1_status=Orange;
				chan_s1!s1_status;
				chan_s2?Green;
				s1_status=Red;
				chan_s1!s1_status;
			}	
			atomic
			{
				chan_s2?Orange;
				chan_s1!Green;
				chan_s2?Red;
				s1_status=Green;	
			}
		:: 	chan_sensor?Off;
		fi	
	od
}

proctype FarmRoadSignal(mtype status)
{
	s2_status=status;
	do
	:: 	
		atomic
		{
			chan_s1?Orange;
			chan_s2!Green;
			chan_s1?Red;
			s2_status=Green;
		}
		do
		::
			atomic
			{
				chan_sensor?Off;
				s2_status=Orange;
				chan_s2!s2_status;
				chan_s1?Green;
				s2_status=Red;
				chan_s2!s2_status;
				break;
			}
		::
			atomic
			{
				chan_sensor?On;
			}
		od
	od	
}

proctype Sensor()
{
	do
	:: 	if
		::	sensor_status=On;
		:: 	sensor_status=Off;
		fi
		chan_sensor!sensor_status;
	od
}

init 
{
	atomic
	{
		run HighwaySignal(Green);
		run FarmRoadSignal(Red);
		run Sensor();		
	}
}