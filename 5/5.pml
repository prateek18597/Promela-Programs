proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::	q2!5;
	::	q2!10;
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
				(i==5)-> printf("Milk bar released.\n");
			}
		::atomic
			{
				(i==10)-> printf("Plain bar released.\n");
			}
		fi
	od	
}

init
{
	chan qname=[0] of { chan };
	chan qforb=[0] of { int };
	atomic
	{
		run customer(qname);
		run vender(qforb);
	}
	qname!qforb;
}
