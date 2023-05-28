#include <cstdio>
#include <iostream>
#include <cstring>

using namespace std;

int main(int argc,char* argv[])
{
    if(argc < 2)
    {
        printf("ERROR!\n");
        return -1;
    }
    freopen(argv[1],"r",stdin);
    char s[20];
    int res[30];
    memset(res,0,sizeof(res));
    while(~scanf("%s",s))
    {
        int depth = 0;
        int cnt = 0;
        int i = 0;
        int n = strlen(s);
        while(i < n)
        {
            if(s[i] == '.')
                break;
            depth = depth * 10 + (s[i] - '0');
            i++;
        }
        while(i < n)
        {
            if(s[i] == ':')
            {
                i++;
                break;
            }
            i++;
        }
        while(i < n)
        {
            cnt = cnt * 10 + (s[i] - '0');
            i++;
        }
        res[depth] = cnt;
    }
    double total = 0,n_5000,n_5001;
    int total_file = 0;
    for(int i = 0;i < 30;i++)
        if(res[i])
        {
            total += res[i] * i;
            total_file += res[i];
            if(total_file - res[i] < 5000 && total_file >= 5000)
                n_5000 = i;
            if(total_file - res[i] < 5001 && total_file >= 5001)
                n_5001 = i;
            printf("%d: %d\n",i,res[i]);
        }
    printf("mean: %lf \nmedian: %lf\n",total / total_file,(n_5000 + n_5001) / 2);
    return 0;
}