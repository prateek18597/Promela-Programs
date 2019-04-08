#define p 0
#define v 1

chan sema=[0] of {bit};

proctype djikstra()
{
	do
	:: sema!p -> sema?v;
	od
}

proctype writer(chan buffer)
{
	int t;
	t=1;
	do
	::	if
		:: 	(len(buffer)==10) -> break;
		:: 	(len(buffer)!=10) -> 
				buffer!t; 
				printf("Writer wrote: %d\n",t);
				t++;
		fi
	od
}

proctype reader(chan buffer;int id)
{
	int t;
	do
	::	if
		:: (len(buffer)==0) -> skip;
		:: 	
			(len(buffer)!=0) ->	buffer?t;
				printf("\t\tReader %d read: %d\n",id,t);
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
		run djikstra();
		run writer(buffer);
		run reader(buffer,1);
		run reader(buffer,2);	
	}
}