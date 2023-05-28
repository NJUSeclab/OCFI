#include <cstdio>
#include <cstring>

#include <iostream>
#include <string>

using namespace std;

int main(int argc,char* argv[])
{
	if(argc < 2)
		return -1;
	freopen(argv[1],"r",stdin);
	char s[100]; 
	string s1 = argv[1];
	s1 += "_new";
	freopen(s1.c_str(),"w",stdout);
	bool flag = false;
	int a;
	double b;
	double res;
	while(~scanf("%s%dm%lf",s,&a,&b))
	{
		if(s[0] == 'r')
		{
			res = a * 60 + b;
			printf("%d %f\n",a,b);
		}
		
	}
	printf("%f\n",res);
	return 0;
}
