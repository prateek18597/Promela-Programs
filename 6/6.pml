int waterLevel=30;
bit inlet=0,outlet=0,user=0,controller=0;

proctype User()
{
	do
	::	atomic
		{
			(user==1)->
				outlet=1;
		}
	::	atomic
		{
			(user!=1)->
				skip;
		}
	od
}

proctype Inlet()
{
	do
	:: 	atomic
		{
			(inlet==1 && controller==0)->
				waterLevel++;
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
			(outlet==1 && controller==0)->
				waterLevel--;
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
			(waterLevel==20)->
				outlet=0;
				user=0;
				inlet=1;
				controller=0;
		}
	:: 	atomic
		{
			(waterLevel==30)->
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
	::assert(waterLevel>=20 && waterLevel<=30);
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