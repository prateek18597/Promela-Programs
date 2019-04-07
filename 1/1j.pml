#define p 0
#define v 1

chan sema=[0] of {bit};

proctype djikstra()
{
	do
	:: sema!p -> sema?v;
	od
}

proctype producer(chan buffer)
{
	int t;
	t=1;
	do
	::	if
		:: (len(buffer)==10) -> skip;
		:: 	atomic
			{
				(len(buffer)!=10) -> 
				sema?p;
				buffer!t; 
				printf("Producer produced item: %d\n",t);
				t++;
				sema!v;
			}
		fi
	od
}

proctype consumer(chan buffer)
{
	int t;
	do
	::	if
		:: (len(buffer)==0) -> skip;
		:: 	atomic
			{
				(len(buffer)!=0) -> 
				sema?p;
				buffer?t;
				printf("\t\tConsumer consumed item: %d\n",t);
				sema!v;
			}
		fi
	od
}

proctype monitor(chan buffer)
{
	assert(len(buffer)>=0 && len(buffer)<=10);
}
init
{
	chan buffer=[10] of {int};
	atomic
	{
		run producer(buffer);
		run consumer(buffer);
		run djikstra();	
	}
}