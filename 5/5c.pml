#define p 0
#define v 1
int milk,plain,coinBox,money;
chan sema=[0] of {bit};
chan sema1=[0] of {bit};

int quit;

proctype dijkstra()
{
	do
	:: atomic
		{
			sema!p -> sema?v;
		}
	::	(quit==0)->break;
	od
}

proctype dijkstra1()
{
	do
	:: atomic
		{
			sema1!p -> sema1?v;
		}
	::	(quit==0)->break;
	od
}

proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::(money>0)->
		if
		::	atomic
			{
				(money>=5)->
				sema?p;
				money=money-5;
				q2!5;
				
			}
		::	atomic
			{
				(money>=10)->
				sema?p;
				money=money-10;
				q2!10;
			}
		fi
	::atomic
		{
			(money<=0)->
			quit=0;
			break;
		}
	::atomic
		{
			(quit==0)->break;
		}
	od
}

proctype vender(chan qforb)
{
	int i;

	do
	::	qforb?i;
		if
		::atomic
			{
				(i==5)-> 
				if
				::(milk>0)-> printf("Milk bar released.\n");
					coinBox=coinBox+5;
					milk=milk-1;
					sema1!v;
				::(milk<=0)->printf("Milk bars are not available.\n");
				fi
			}
		::atomic
			{
				(i==10)-> 
				if
				::
					(plain>0)->  printf("Plain bar released.\n");
					coinBox=coinBox+10;
					plain=plain-1;
					sema1!v;
				::
					(plain<=0)-> printf("Plain bars are not available.\n");
				fi
			}
		::atomic
			{
				(milk==0 && plain==0)->quit=0;break;
			}
		::atomic
			{
				(quit==0)->break;
			}
		fi
	od	
}

proctype monitor()
{
	do
	:: assert(coinBox==((5-plain)*10)+((10-milk)*5));
	::	(quit==0)->break;
	od
}

proctype monitor1()
{
	do
	:: atomic
		{
			sema1?p;
			assert(coinBox+money==45);
			sema!v;
		}
	::	(quit==0)->break;
	od
}

init
{
	chan qname=[0] of { chan };
	chan qforb=[0] of { int };
	
	milk=10;
	plain=5;
	coinBox=0;
	money=45;
	quit=1;
	atomic
	{
		run dijkstra();
		run dijkstra1();
		run customer(qname);
		run vender(qforb);
		run monitor();
		run monitor1();	
	}
	qname!qforb;
}
