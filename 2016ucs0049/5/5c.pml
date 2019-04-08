int milk,plain,coinBox,money;
int check;
int decre;
int incre;
int quit;

proctype customer(chan q1)
{
	chan q2;
	q1?q2;
	do
	::(money>0)->
		if
		::	atomic
			{
				(money>=5 && decre==1)->
				money=money-5;
				decre=0;
				incre=1;
				q2!5;
				
			}
		::	atomic
			{
				(money>=10 && decre==1)->
				money=money-10;
				decre=0;
				incre=1;
				q2!10;
			}
		fi
	::atomic
		{
			(money<=0 && decre==1)->
			quit=0;
			break;
		}
	::atomic
		{
			(quit==0)->break;
		}
	od
}

proctype vender(chan qforb)
{
	int i;

	do
	::	qforb?i;
		if
		::atomic
			{
				(i==5)-> 
				if
				::(milk>0 && incre==1)-> printf("Milk bar released.\n");
					coinBox=coinBox+5;
					milk=milk-1;
					incre=0;
					check=1;
				::(milk<=0)->printf("Milk bars are not available.\n");
				fi
			}
		::atomic
			{
				(i==10)-> 
				if
				::
					(plain>0 && incre==1)->  printf("Plain bar released.\n");
					coinBox=coinBox+10;
					plain=plain-1;
					incre=0;
					check=1;
				::
					(plain<=0)-> printf("Plain bars are not available.\n");
				fi
			}
		::atomic
			{
				(milk==0 && plain==0 && incre==1)->quit=0;break;
			}
		::atomic
			{
				(quit==0)->break;
			}
		fi
	od	
}

proctype monitor()
{
	do
	:: assert(coinBox==((5-plain)*10)+((10-milk)*5));
	::	(quit==0)->break;
	od
}

proctype monitor1()
{
	do
	:: atomic
		{
			(check==1)->
			assert(coinBox+money==45);
			check=0;
			decre=1;
		}
	::	(quit==0 && check==1)->break;
	od
}

init
{
	chan qname=[0] of { chan };
	chan qforb=[0] of { int };
	
	milk=10;
	plain=5;
	coinBox=0;
	money=45;
	quit=1;

	check=0;
	decre=1;
	incre=0;

	atomic
	{
		run customer(qname);
		run vender(qforb);
		run monitor();
		run monitor1();	
	}
	qname!qforb;
}
