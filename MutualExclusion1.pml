bit flag;
byte mutex;

proctype P(bit i)
{
	flag!=1;
	flag=1;
	mutex++;
	printf("P(%d) has entered in critical section.\n",i);
	mutex--;
	flag=0;
}

proctype monitor()
{
	assert(mutex!=2);
}

init
{
	atomic
	{
		run P(0);
		run P(1);
		run monitor();
	}
}
