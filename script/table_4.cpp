#include <cstdio>
#include <iostream>
#include <string>
#include <cstring>

using namespace std;


double T;
int N;
double get_avg(string tmp)
{
    int x,cnt;
    double t;
    t = 0;
    cnt = 0;
    freopen(tmp.c_str(),"r",stdin);
    while(~scanf("%d",&x))
    {
        t += x;
        cnt++;
    }
    T = t;
    N = cnt;
    t /= cnt;
    return t;
}
int main(int argc,char* argv[])
{
    if(argc < 2)
    {
        printf("ERROR!\n");
        return -1;
    }
    double res[6][12];
    double sum[6][12];
    int num[6][12];
    string dir(argv[1]),tmp;
    // const char* output = argv[3];


    dir = dir + "/issta_testsuite@";
    string arch[2] = {"x64_executables@","aarch64_executables@"};
    string kind[4] = {"c_unchanged@","c_changed@","cpp_unchanged@","cpp_changed@"};
    string opt_x[5] = {"O0","O2","O3","Os","Ofast"};
    for(int i = 0;i < 2;i++)
    {
        for(int j = 0;j < 4;j++)
            for(int k = 0;k < 5;k++)
            {
                string tmp = dir + arch[i] + kind[j] + opt_x[k];
                int x = i * 6 + j;
//                printf("T:%s %d %d\n",tmp.c_str(),x,k);
                if(j > 1)
                    x += 1;
                res[k][x] = get_avg(tmp);
		sum[k][x] = T;
		num[k][x] = N;
            }
    }
    double unchanged = 0,changed = 0;
    int unchanged_num = 0,changed_num = 0;
    for(int i = 0;i < 12;i++)
    {
        double t = 0;
	int n = 0;
	if(i % 3 == 2)
		continue;
        for(int j = 0;j < 5;j++)
	{
            t += sum[j][i];
	    n += num[j][i];
	}
	if(i % 3 == 0)
	{
		unchanged += t;
		unchanged_num += n;
	}
	else
	{
		changed += t;
		changed_num += n;
	}
        res[5][i] = t / n;
    }
    for(int i = 0;i < 6;i++)
    {
        for(int k = 0;k < 4;k++)
        {
            int j = k * 3 + 2;
            res[i][j] = (res[i][j - 1] - res[i][j - 2]) / res[i][j - 2] * 100;
        }
    }


    printf("    --------------------x64--------------------     ------------------aarch64------------------\n");
    printf("    ----------C----------   ---------C++--------    ----------C----------  ---------C++--------\n");
    printf("     Orig   OCFI    DEC     Orig    OCFI     DEC     Orig   OCFI    DEC     Orig     OCFI   DEC\n");
    char opt[6][5] = {"O0 ","O2 ","O3 ","Os ","Of ","Avg"};
    for(int i = 0;i < 6;i++)
    {
        printf("%s ",opt[i]);
        for(int j = 0;j < 12;j++)
        {
            if(res[i][j] == -1)
                printf("------ ");
            else
                printf("%6.2f ",res[i][j]);
            if((j + 1) % 3 == 0)
                printf("| ");
        }
        printf("\n");
    }
    printf("    -------------------------------------------- ---------------------------------------------\n");
    unchanged /= unchanged_num;
    changed /= changed_num;
//    printf("%6.2f %6.2f %6.2f\n",unchanged, changed, (changed - unchanged) / unchanged * 100);
    return 0;
}
