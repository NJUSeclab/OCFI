#include <cstdio>
#include <iostream>
#include <string>
#include <cstring>

using namespace std;


double get_num()
{
    char s[10];
    scanf("%s",s);
    // printf("%s: ",s);
    double num = 0;
    int n = strlen(s);
    for(int i = 0;i < n;i++)
        if(s[i] >= '0' && s[i] <= '9')
            num = num * 10 + (s[i] - '0');
    num /= 100;
    // printf("%lf\n",num);
    return num;
}
int main(int argc,char* argv[])
{
    if(argc < 2)
    {
        printf("ERROR!\n");
        return -1;
    }
    double res[4][5];

    string dir(argv[1]),tmp;
    const char* output = argv[3];

    tmp = dir + "/usenix/GHIDRA.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
        res[0][i] = get_num();

    tmp = dir + "/usenix/GHIDRAN.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
        res[1][i] = get_num();

    tmp = dir + "/usenix/ANGR.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
        res[2][i] = get_num();

    tmp = dir + "/usenix/ANGRN.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
        res[3][i] = get_num();

    printf("           O0     O2     O3     Os     Of\n");
    char opt[4][10] = {"GHIDRA ","GHIDRAN","ANGR   ","ANGRN  "};
    for(int i = 0;i < 4;i++)
    {
        printf("%s  ",opt[i % 5]);
        for(int j = 0;j < 5;j++)
        {
            printf("%6.2f ",res[i][j]);
        }
        printf("\n");
    }
    return 0;
}