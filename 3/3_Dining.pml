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
	:: (t<200)->t++;
	:: (t>=200)-> break;
	od
}

proctype philosopher(int i)
{
	do
	::(t<200)->
		if
		:: 	
			atomic
			{
				(i<(i+1)%5) ->

				chopstick[i]?p;
				printf("Philosopher %d acquired his first fork %d.\n",i,i);
				chopstick[(i+1)%5]?p;
				printf("Philosopher %d acquired his second fork %d.\n",i,(i+1)%5);

				printf("Philosopher %d is eating.\n",i);
				
				chopstick[i]!v;
				printf("Philosopher %d released his first fork %d.\n",i,i);
				chopstick[(i+1)%5]!v;
				printf("Philosopher %d released his second fork %d.\n",i,(i+1)%5);
			}
		:: 	
			atomic
			{
				(i>(i+1)%5) ->

				chopstick[(i+1)%5]?p;
				printf("Philosopher %d acquired his first fork %d.\n",i,(i+1)%5);
				chopstick[i]?p;
				printf("Philosopher %d acquired his second fork %d.\n",i,i);

				printf("Philosopher %d is eating.\n",i);

				chopstick[(i+1)%5]!v;
				printf("Philosopher %d released his first fork %d.\n",i,(i+1)%5);
				chopstick[i]!v;
				printf("Philosopher %d released his second fork %d.\n",i,i);
			}
		fi
	::(t>=200)-> break;
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