#include<stdio.h>

#define ROW 0
#define COL 1 

void print(void);

struct node{
	int crnum;
	int bucketnum;
	struct node *leftpointer;
	struct node *rightpointer;
	}; 

struct node **rowbuckets;
struct node **rowpointers;
struct node **colbuckets;
struct node **colpointers;
int *rowcount;
int totalrowcount=0;

int *mydeletedrow;
int *mydeletedcol=0;

int *colcount;
int totalcolcount=0;

int numrowbuckets=0;
int numrows=0;

int numcolbuckets=0;
int numcols=0;



#ifdef __STDC__
int bucketnum(int num,int flag)
#else
int bucketnum(num,flag)
int num;
int flag;
#endif
{
	if (flag==ROW) return (rowpointers[num]->bucketnum);
	else return (colpointers[num]->bucketnum);


}

#ifdef __STDC__
void insert(int num,struct node *p,int flag)
#else
void insert(num,p,flag)
int num;
struct node* p;
int flag;
#endif
{
	p->bucketnum=num;

	if (flag==ROW) {
	mydeletedrow[p->crnum]=0;
	if (rowcount[num]!=0)
	{
	(rowbuckets[num]->rightpointer)->leftpointer=p;
	p->rightpointer=(rowbuckets[num]->rightpointer);
	}
	else
	{
	p->rightpointer=NULL;
	}
	p->leftpointer=rowbuckets[num];
        rowbuckets[num]->rightpointer=p;

	rowcount[num]++;
	totalrowcount++;
	}
	else
	{
	mydeletedcol[p->crnum]=0;
        if (colcount[num]!=0)
        {
        (colbuckets[num]->rightpointer)->leftpointer=p;
        p->rightpointer=(colbuckets[num]->rightpointer);
        }
        else
        {
	p->rightpointer=NULL;
	}
	p->leftpointer=colbuckets[num];
        colbuckets[num]->rightpointer=p;        

        colcount[num]++;
        totalcolcount++;
	}

}
#ifdef __STDC__
int  mydelete(struct node *p,int flag)
#else
int  mydelete(p,flag)
struct node *p;
int flag;
#endif
{
	int num;
#ifdef DEBUG
	printf("HERE IN del\n");
#endif
	num=p->bucketnum;

	if(p->rightpointer!=NULL) {
	p->leftpointer->rightpointer=p->rightpointer;
	p->rightpointer->leftpointer=p->leftpointer;
	}	
	else 
	p->leftpointer->rightpointer=NULL;


	if(flag==ROW){
	rowcount[num]--;
	mydeletedrow[p->crnum]=1;
	totalrowcount--;	
	}
	else {
	colcount[num]--;
	mydeletedcol[p->crnum]=1;
	totalcolcount--;	
	}
#ifdef DEBUG
	printf("HERE exiting del\n");
#endif
	return num;

}

#ifdef __STDC__
void decreasekey(struct node *p,int flag)
#else
void decreasekey(p,flag)
struct node *p;
int flag;
#endif
{	
	int num;
	num=mydelete(p,flag);
	if (num > 0) {
		insert(num-1,p,flag);}
	else
		{
		//printf("ERROR\n");
		insert(0,p,flag);
		}
}

#ifdef __STDC__
void decreasekeylist(int *list,int num,int flag)
#else
void decreasekeylist(list,num,flag)
int *list;
int num;
int flag;
#endif
{
	int j;
	if (flag==ROW) {
	for (j=0;j<num;j++)
		if(!mydeletedrow[list[j]])
		decreasekey(rowpointers[list[j]],flag);}
	else
	for (j=0;j<num;j++)
		if(!mydeletedcol[list[j]])
		decreasekey(colpointers[list[j]],flag);

}


#ifdef __STDC__
int mydeletemin(int flag,int del)
#else
int mydeletemin(flag,del)
int flag;
int del;
#endif
{
	int mycrnum;
	int i;
	struct node *temp;	

	if (flag==ROW) {
			i=0;
			while((rowcount[i]==0)&&(i<=numrowbuckets)) i++;
			if (i==numrowbuckets+1)	{
#ifdef DEBUG
				printf("ERROR , NO ROW LEFT\n");
#endif		
				return -1;
				}

			temp=rowbuckets[i]->rightpointer; 
			mycrnum=temp->crnum;
#ifdef DEBUG
	printf("HERE bef del %d %d %d\n",mycrnum,flag,i);
	if (mycrnum>100) {print(); printf("%d\n",temp->bucketnum);}
#endif
		if (del > 0) {
       		        mydelete(temp,flag);
			rowpointers[mycrnum]=NULL;
			free((char *)temp);}
       		        return mycrnum;
	}
	else {
                        i=0;
                        while((colcount[i]==0)&&(i<=numcolbuckets)) i++;
                        if (i==numcolbuckets+1)   {
#ifdef DEBUG
                                printf("ERROR , NO COL LEFT\n");
#endif
                                return -1;
                                }
                        temp=colbuckets[i]->rightpointer;
                        mycrnum=temp->crnum;
#ifdef DEBUG
		printf("HERE bef del %d %d %d\n",mycrnum,flag,i);
	if (mycrnum>100){ print(); printf("%d\n",temp->bucketnum);}

#endif
                        if (del > 0) {
			mydelete(temp,flag);
			colpointers[mycrnum]=NULL;
			free((char *)temp);}
                        return mycrnum;
	}

}
#ifdef __STDC__
void initialise(int rho,double *sum,int size,int flag)
#else
void initialise(rho,sum,size,flag)
int rho;
double *sum;
int size;
int flag;
#endif
{
	int i;
	if (flag==ROW) {
	numrowbuckets=rho;
	numrows=size;
	rowbuckets=(struct node **)calloc(rho+1,sizeof(struct node *));
	for (i=0;i<=rho;i++)
		{
		rowbuckets[i]=(struct node *)calloc(1,sizeof(struct node));
		rowbuckets[i]->leftpointer=NULL;
		rowbuckets[i]->rightpointer=NULL;
		}
	rowpointers=(struct node **)calloc(size,sizeof(struct node *));
	rowcount=(int *)calloc(rho+1,sizeof(int));
	mydeletedrow=(int *)calloc(size,sizeof(int));
	

	for(i=0;i<size;i++)	{
		rowpointers[i]=(struct node *)calloc(1,sizeof(struct node));
		rowpointers[i]->crnum=i;
		mydeletedrow[i]=0;
		insert((int)sum[i],rowpointers[i],flag);
	}	
	totalrowcount=size;
	}
	else {

	numcolbuckets=rho;
        numcols=size;
        colbuckets=(struct node **)calloc(rho+1,sizeof(struct node *));
        for (i=0;i<=rho;i++)
                {
                colbuckets[i]=(struct node *)calloc(1,sizeof(struct node));
                colbuckets[i]->leftpointer=NULL;
                colbuckets[i]->rightpointer=NULL;
                }
        colpointers=(struct node **)calloc(size,sizeof(struct node *));
        colcount=(int *)calloc(rho+1,sizeof(int));
	mydeletedcol=(int *)calloc(size,sizeof(int));
 
 
        for(i=0;i<size;i++)     {
                colpointers[i]=(struct node *)calloc(1,sizeof(struct node));
                colpointers[i]->crnum=i;
		mydeletedcol[i]=0;
                insert((int)sum[i],colpointers[i],flag);
        }
        totalcolcount=size;

	}
}
void print()
{
int i;

	for (i=0;i<=numrowbuckets;i++)
		printf("%d ",rowcount[i]);
	printf("\n");
	printf("%d\n",totalrowcount);	

	for (i=0;i<=numcolbuckets;i++)
		printf("%d ",colcount[i]);
	printf("\n");
	printf("%d\n",totalcolcount);	
	for (i=0;i<numrows;i++)
		if (!mydeletedrow[i]) printf("%d ",rowpointers[i]->crnum);
	printf("\n");
	for (i=0;i<numcols;i++)
		if (!mydeletedcol[i]) printf("%d ",colpointers[i]->crnum);
	printf("\n");
}
