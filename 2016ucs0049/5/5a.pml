proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::	q2!5;
	::	q2!10;
	od
}

proctype vender(chan qforb;chan coinBox)
{
	int i,milk,plain;
	milk=10;
	plain=5;
	do
	::	qforb?i;
		if
		::atomic
			{
				(i==5)-> 
				if
				::(milk>0)-> printf("Milk bar released.\n");
					coinBox!5;
					milk=milk-1;
				::(milk<=0)->printf("Milk bars are not available.\n");
				fi
			}
		::atomic
			{
				(i==10)-> 
				if
				::(plain>0)->  printf("Plain bar released.\n");
					coinBox!10;
					plain=plain-1;
				::(plain<=0)-> printf("Plain bars are not available.\n");
				fi
			}
		::(milk==0 && plain==0)->break;
		fi
	od	
}

init
{
	chan qname=[1] of { chan };
	chan qforb=[1] of { int };
	chan coinBox=[15] of { int };
	run customer(qname);
	run vender(qforb,coinBox);
	qname!qforb;
}
