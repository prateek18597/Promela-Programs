#define train 1

proctype signalFirst(chan b1)//Signal for first block
{
	do
	:: 	atomic
		{
			(len(b1)==1)-> //Train coming to occupied Block 1
				printf("Unsafe State: Crash Occured in Block 1.\n");
		}
	:: 	atomic
		{
			(len(b1)!=1)-> 	//Train coming to empty Block 1
				b1!train;
				printf("Train Arrived in Block 1.\n");
		}
	od
}

proctype signalMiddle(chan b1,b2)//Signal for second block
{
	do
	:: 	atomic
		{
			(len(b2)==1)-> //Train coming to occupied Block 2
				printf("Unsafe State: Crash Occured in Block 2.\n");
		}
	:: 	atomic
		{
			(len(b2)!=1)-> 	//Train coming to empty Block 2
				b1?train;
				printf("Train Departed from Block 1.\n");
				b2!train;
				printf("Train Arrived in Block 2.\n");
		}
	od
}

proctype signalLast(chan b2)//Signal for third block
{
	do
	::	atomic
		{
			b2?train;	//Train departing from Block 2
			printf("Train Departed from Block 2.\n")
		}
	od
}

init
{
	chan block1 = [2] of {bit};
	chan block2 = [2] of {bit};

	atomic
	{
		run signalFirst(block1);//Running signal processes.
		run signalMiddle(block1,block2);
		run signalLast(block2);
	}
}