int milk,plain,coinBox;
proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::	q2!5;
	::	q2!10;
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
		::atomic{(i==5)-> 
				if
				::(milk>0)-> printf("Milk bar released.\n");
					coinBox=coinBox+5;
					milk=milk-1;
				::(milk<=0)->printf("Milk bars are not available.\n");
				fi
			}
		::atomic{(i==10)-> 
				if
				::(plain>0)->  printf("Plain bar released.\n");
					coinBox=coinBox+10;
					plain=plain-1;
				::(plain<=0)-> printf("Plain bars are not available.\n");
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

init
{
	chan qname=[0] of { chan };
	chan qforb=[0] of { int };
	
	milk=10;
	plain=5;
	coinBox=0;
	
	atomic{
	run customer(qname);
	run vender(qforb);
	run monitor();
	}
	qname!qforb;
}
