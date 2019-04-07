#define N 128
#define SIZE 16

chan in = [SIZE] of {short};
chan large = [SIZE] of {short};
chan small = [SIZE] of {short};

active proctype split()
{
	short cargo;
	do
	:: in ? cargo->
		if
		:: (cargo>=N)-> large!cargo;
		:: (cargo<N)-> small!cargo;
		fi
	od
}

init
{
	run split();
}