bit flag1,flag2;
byte mutex;

proctype A()
{
	do	
	::	flag1=1;
		flag2==0;
		mutex++;
		printf("Process A is in Critical Section.\n");
		mutex--;
		flag1=0;
	od
}

proctype B()
{
	do
	::	flag2=1;
		flag1==0;
		mutex++;
		printf("Process B is in Critical Section.\n");
		mutex--;
		flag2=0;
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
		run A();
		run B();
		run monitor();
	}
}
