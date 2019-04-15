int msg[10];

proctype writer(chan buffer)
{
	int t;
	int w_pos=0;//Contains pos to write in buffer.
	t=1;
	do
	:: 	(w_pos==10) -> break;// Checking whether buffer is full, If full writer would stop writing.
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
			skip;// Checking whether reader has read everything written by writer till now. 
	:: 	atomic
		{
			(r_pos<len(buffer))->
			printf("\t\tReader %d read: %d\n",id,msg[r_pos]);
			r_pos++;
		}
	:: 	atomic
		{
			(r_pos==10)->
			break;// Checking if reader has completely read the buffer.
		}
	od
}

proctype monitor(chan buffer)
{
	do
	::	assert(len(buffer)>=0 && len(buffer)<=10);//Checking program invarient.
	od
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