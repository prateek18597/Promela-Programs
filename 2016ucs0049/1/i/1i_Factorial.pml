proctype fact(int n;chan p)
{
	chan chil=[1] of {int};
	int result;
	if
	:: (n<=1) ->p!1;
	:: (n>=2) ->
				run fact(n-1,chil);
				chil?result;
				p!n*result;
	fi
}

init
{
	int result;
	chan child=[1] of {int};
	run fact(7,child);
	child?result;
	printf("Factorial: %d\n",result);
}