bit flag;
byte mutex;

proctype P(bit i)
{
	do	
	::	flag!=1;
		flag=1;
		mutex++;
		printf("P(%d) has entered in critical section.\n",i);
		mutex--;
		flag=0;
	od
}

proctype monitor()
{
	do	
	::	assert(mutex!=2);
	od
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
