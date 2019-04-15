int waterLevel=30;
bit inlet=0,outlet=0,user=0,controller=0;

proctype User()
{
	do
	::	atomic
		{
			(user==1)->//User want's to turn on water outlet
				outlet=1;
		}
	::	atomic
		{
			(user!=1)->
				skip;
		}
	:: skip
	od
}

proctype Inlet()
{
	do
	:: 	atomic
		{
			(inlet==1 && controller==0)->//Checking if water inlet is allowed
				waterLevel++;
				printf("Water Level: %d\n",waterLevel);
				controller=1;
		}
	::
		(inlet==0);	
	od
}

proctype Outlet()
{
	do
	:: 	atomic
		{
			(outlet==1 && controller==0)->//Checking if water outlet is allowed
				waterLevel--;
				printf("Water Level: %d\n",waterLevel);
				controller=1;
		}
	::
		(outlet==0);
	od
}

proctype Sensors()
{
	do
	::	atomic
		{
			(waterLevel==20)->//Turning water inlet on as waterlevel is equal to 20
				outlet=0;
				user=0;
				inlet=1;
				controller=0;
		}
	:: 	atomic
		{
			(waterLevel==30)->//Turning water inlet off as waterlevel is equal to 30
				inlet=0;
				user=1;
				controller=0;
		}
	:: 	atomic
		{
			(waterLevel>20 && waterLevel<30)->
				controller=0;
		}
	od
}

proctype Monitor()
{
	do
	::assert(waterLevel>=20 && waterLevel<=30);//Making sure that waterLevel always remain between 20 and 30.
	od
}

init
{
	atomic
	{
		run User();
		run Inlet();
		run Outlet();
		run Sensors();
		run Monitor();
	}
}