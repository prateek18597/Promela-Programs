proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::	q2!5;//Purchasing milk bar
	::	q2!10;//Purchasing plain bar
	od
}

proctype vender(chan qforb)
{
	int i;
	do
	::	qforb?i;//Receiving money from customer
		if
		::atomic
			{
				(i==5)-> printf("Milk bar released.\n");//Releasing milk bar
			}
		::atomic
			{
				(i==10)-> printf("Plain bar released.\n");//Releasing plain bar
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
		run customer(qname);//Running customer process
		run vender(qforb);//Running vender process
	}
	
	qname!qforb;
}
