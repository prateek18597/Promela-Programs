byte x=2,y=3;

proctype A()
{
	x=x+1;
}

proctype B()
{
	x=x-1;
	y=y+x;
}

init
{
	atomic{run A();run B();}
}