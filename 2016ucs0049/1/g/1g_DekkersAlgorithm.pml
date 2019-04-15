#define true 1
#define false 0
#define Aturn 1
#define Bturn 0

bool ARuns, BRuns, t;

proctype A()
{
	do
	::	ARuns = true;
		t = Bturn;
		(BRuns==false || t==Aturn);
		printf("Process A is in Critical Section.\n");
		ARuns = false		
	od
}

proctype B()
{
	do
	::	BRuns = true;
		t = Aturn;
		(ARuns==false || t==Bturn);
		printf("Process B is in Critical Section.\n");
		BRuns = false
	od
}

init
{
	run A();
	run B();
}
