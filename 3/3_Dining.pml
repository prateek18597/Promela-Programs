#define p 0
#define v 1

chan chopstick[5]=[0] of {bit};
int t=0;
proctype djikstra(int i)
{
	do
	:: chopstick[i]!p -> chopstick[i]?v;
	od
}

proctype timer()
{
	do
	:: (t<100)->t++;
	:: (t>=100)-> break;
	od
}

proctype philosopher(int i)
{
	do
	::(t<100)->
		if
		:: (i<(i+1)%5) ->
			atomic
			{
				chopstick[i]?p;
				chopstick[(i+1)%5]?p;

				printf("Philosopher %d is eating at time %d\n",i,t);
				chopstick[i]!v;
				chopstick[(i+1)%5]!v;
			}
		:: (i>(i+1)%5) ->
			atomic
			{
				chopstick[(i+1)%5]?p;
				chopstick[i]?p;

				printf("Philosopher %d is eating at time %d\n",i,t);

				chopstick[(i+1)%5]!v;
				chopstick[i]!v;
			}
		fi
	::(t>=100)-> break;
	od
}

init
{
	atomic
	{
		run timer();
		run djikstra(0);
		run djikstra(1);
		run djikstra(2);
		run djikstra(3);
		run djikstra(4);

		run philosopher(0);
		run philosopher(1);
		run philosopher(2);
		run philosopher(3);
		run philosopher(4);
	}
}