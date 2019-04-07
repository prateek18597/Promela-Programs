bit train=1
chan FirstBlock = [2] of {bit};
chan SecondBlock = [2] of {bit};

proctype FirstSignal(chan FirstBlockenter)
{
    do
	::atomic{len(FirstBlockenter)==1 ->printf(" Train will crash");}
	::atomic{len(FirstBlockenter)!=1 -> FirstBlockenter ! train  -> printf(" Train signaled  for entering the first block \n");}
    od
}

proctype SecondSignal (chan FirstBlockenter, SecondBlockenter)
{
    do
	::atomic{len(SecondBlockenter)==1 ->printf(" Train will crash")}
	::atomic{len(SecondBlockenter)!=1->FirstBlockenter ? train ->printf(" Train exits from first block \n");
			SecondBlockenter ! train->printf("Train signaled  for entering the second block \n");}
    od
}

proctype ThirdSignal(chan SecondBlockenter)
{
    do
	:: atomic {SecondBlockenter ? train->printf(" Train exits from second block\n");}
    od
}

init {
    atomic{
    run FirstSignal(FirstBlock);
    run SecondSignal(FirstBlock,SecondBlock);
    run ThirdSignal(SecondBlock);
    }
}
