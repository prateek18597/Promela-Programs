int t=0;

proctype signal(int i)
{

}

init
{
	atomic
	{
		run signal(1);
		run signal(2);
		run signal(3);
	}
}