	bit flag=1;
	byte mutex=0;
	proctype P(bit i)
	{
		flag != 1;
		flag = 1;
		mutex++;
		printf(“MSC: P(%d) has entered the critical section\n, i);
		mutex--;
		flag = 0;
	}
	proctype monitor() {
		assert(mutex !=2);
	}
	init 
	{
		{run P(0); run P(1); run monitor(); }
	}
