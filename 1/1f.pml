#define p 0
#define v 1

proctype hello(chan q1)
{
	q1?v;
	printf("Hello\n");
	q1!p;
}

proctype world(chan q2)
{
	q2?v;
	printf("World!\n");
}

proctype control(chan q1;chan q2)
{
	q1!v;
	q1?p;
	q2!v;
}

init
{
	int h,w,c;
	chan c1=[0] of {bit};
	chan c2=[0] of {bit};
	atomic
	{
		h=run hello(c1);
		w=run world(c2);
		c=run control(c1,c2);
	}
	printf("PID of Hello Process: %d\n",h);
	printf("PID of World Process: %d\n",w);
	printf("PID of Control Process: %d\n",c);
	printf("PID of init Process: %d\n",_pid);
}