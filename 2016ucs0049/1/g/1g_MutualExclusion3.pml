#define A_TURN 0
#define B_TURN 1
bit flag1,flag2;
byte mutex,turn;

proctype A()
{
	do
	::	flag1=1;
		turn=B_TURN;
		(flag2==0 || turn==A_TURN);
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
		turn=A_TURN;
		(flag1==0 || turn==B_TURN);
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
