int msg[10];

proctype writer(chan buffer)
{
	int t;
	int w_pos=0;
	t=1;
	do
	:: 	(w_pos==10) -> break;
	:: 	atomic
		{
			(w_pos!=10) -> 
			msg[w_pos]=t;
			buffer!t; 
			printf("Writer wrote: %d\n",t);
			t++;
			w_pos++;
		}
	od
}

proctype reader(chan buffer;int id)
{
	int t;
	int r_pos=0;
	do
	::	(r_pos==len(buffer))-> 
			skip;
	:: 	atomic
		{
			(r_pos<len(buffer))->
			printf("\t\tReader %d read: %d\n",id,msg[r_pos]);
			r_pos++;
		}
	:: 	atomic
		{
			(r_pos==10)->
			break;
		}
	od
}

proctype monitor(chan buffer)
{
	assert(len(buffer)>=0 && len(buffer)<=10);
}

init
{
	chan buffer=[10] of {int};
	atomic
	{
		run writer(buffer);
		run reader(buffer,1);
		run reader(buffer,2);	
	}
}