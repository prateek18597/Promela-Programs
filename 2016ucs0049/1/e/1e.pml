proctype hello()
{
	printf("Hello\n");
}

proctype world()
{
	printf("World!\n");
}

init
{
	int h,w; 
	h=run hello();
	w=run world();
	printf("PID of hello Process: %d\n",h);
	printf("PID of world Process: %d\n",w);
	printf("PID of init Process: %d\n",_pid);
}
