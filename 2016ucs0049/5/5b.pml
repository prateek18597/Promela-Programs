int milk,plain,coinBox,quit;
proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::	q2!5;//Purchasing MIlk bar
	::	q2!10;//Purchasing Plain bar
	::atomic
		{
			(quit==0)->break;//Leaving machine
		}
	od
}

proctype vender(chan qforb)
{
	int i;

	do
	::	qforb?i;//Receiving Payment
		if
		::	atomic
			{
				(i==5)-> 
				if
				::(milk>0)-> printf("Milk bar released.\n");//Releasing milk bar
					coinBox=coinBox+5;
					milk=milk-1;
				::(milk<=0)->printf("Milk bars are not available.\n");//Milk bar not available
				fi
			}
		::atomic{(i==10)-> 
				if
				::(plain>0)->  printf("Plain bar released.\n");//Releasing plain bar
					coinBox=coinBox+10;
					plain=plain-1;
				::(plain<=0)-> printf("Plain bars are not available.\n");//Plain bar not available
				fi
			}
		::atomic
			{
				(milk==0 && plain==0)->quit=0;break;//Closing machine
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
	:: assert(coinBox==((5-plain)*10)+((10-milk)*5));//Checking consistency of money in system.
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
	quit=1;

	atomic
	{
		run customer(qname);
		run vender(qforb);
		run monitor();
	}
	qname!qforb;
}
