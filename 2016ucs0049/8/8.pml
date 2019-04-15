#define msg0 0
#define ack0 0
#define msg1 1
#define ack1 1

proctype sender(chan channel)
{
	channel!msg0;//Sender Sent msg0
	printf("Sender Sent msg0\n");
	do
	:: 	channel?ack0;//Sender waiting for ack0
		printf("Sender Sent msg1\n");
		channel!msg1;//Sender Sent msg1
	::	channel?ack1;//Sender waiting for ack1
		printf("Sender Sent msg0\n");
		channel!msg0;//Sender Sent msg0
	od
}

proctype receiver(chan channel)
{
	do
	:: 	channel?msg0;//Receiver waiting for msg0
		printf("Receiver Sent ack0\n");
		channel!ack0;//Receiver Sent ack0
	::	channel?msg1;//Receiver waiting for msg1
		printf("Sender Sent ack1\n");
		channel!ack1;//Receiver Sent ack1
	od
}

init
{
	chan channel=[0] of {bit};
	atomic
	{
		run sender(channel);//running sender
		run receiver(channel);//running receiver
	}
}