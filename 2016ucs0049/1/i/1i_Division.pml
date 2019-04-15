int a, b, quo, rem;
bit done,load;

proctype quo_rem()
{
	do
	:: (load==1) -> quo=0; rem=a; done=0;
	:: (load!=1) -> if
					:: (rem>=b) -> rem=rem-b; quo=quo+1;
					:: (b>rem) -> done=1; break;
					fi
	od
}

init
{
	a=7;
	b=2;
	done=1;
	load=1;
	run quo_rem();
	done==0;
	load=0;
	done==1;
	printf("Quotient= %d\n",quo);
	printf("Remainder= %d\n",rem);
}
