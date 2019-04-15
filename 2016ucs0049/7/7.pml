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
			atomic
			{
				chan_sensor?On;//Turning Farm road signal green and highway signal red when a vehicle arrive on farm road.			
				s1_status=Orange;
				chan_s1!s1_status;
				chan_s2?Green;
				s1_status=Red;
				chan_s1!s1_status;
			}	
			atomic
			{
				chan_s2?Orange;	//Turning highway signal green when farm road signal turn orange.
				chan_s1!Green;
				chan_s2?Red;
				s1_status=Green;	
			}
	:: 	chan_sensor?Off;
	od
}

proctype FarmRoadSignal(mtype status)
{
	s2_status=status;
	do
	:: 	
		atomic
		{
			chan_s1?Orange;	//Turning farm road signal green when highway signal turn orange.
			chan_s2!Green;
			chan_s1?Red;
			s2_status=Green;
		}
		do
		::
			atomic
			{
				chan_sensor?Off;	//Turning Farm road signal red and highway signal green when farm road is empty.
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
	:: 	
		atomic
		{
			sensor_status=On;
			chan_sensor!sensor_status;//vehicle arriving on farm road
		}
	:: 	
		atomic
		{
			sensor_status=Off;
			chan_sensor!sensor_status;//farm road is empty
		}
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