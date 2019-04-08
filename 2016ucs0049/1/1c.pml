byte state=1;

proctype A()
{
	(state==1)-> state=state+1;
}

proctype B()
{
	(state==1)-> state=state-1;
}

init
{
	atomic{ run A();run B();}
}