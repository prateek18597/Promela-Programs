int t=0;

proctype signalFirst()
{
	do
	::
	od
}

proctype signalMiddle()
{
	do
	::
	od
}

proctype signalLast()
{
	do
	::
	od
}

init
{
	atomic
	{
		run signalFirst();
		run signalMiddle();
		run signalLast();
	}
}