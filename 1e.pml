proctype helloworld()
{
	printf("Hello World!\n");
}

init
{
	int h; 
	h=run helloworld();
	printf("PID of Hello world Process: %d\n",h);
	printf("PID of Process: %d\n",_pid);
}