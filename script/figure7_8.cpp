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
    double res[20][12];

    for(int i = 0;i < 5;i++)
        for(int j = 0;j < 4;j++)
            res[i][j * 3] = 100.0;
    for(int i = 15;i < 20;i++)
        for(int j = 6;j < 12;j++)
            res[i][j] = -1;
    string dir(argv[1]),tmp;
    const char* output = argv[3];
    tmp = dir + "/Symbol/x64_changed.log";
    //Symbol
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
    {
        res[i][1] = get_num();
        res[i][4] = get_num();
    }
    tmp = dir + "/Symbol/aarch64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 0;i < 5;i++)
    {
        res[i][7] = get_num();
        res[i][10] = get_num();
    }


    //Ghidra
    tmp = dir + "/Ghidra/x64_unchanged.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 5;i < 10;i++)
    {
        res[i][0] = get_num();
        res[i][3] = get_num();
    }
    tmp = dir + "/Ghidra/x64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 5;i < 10;i++)
    {
        res[i][1] = get_num();
        res[i][4] = get_num();
    }
    tmp = dir + "/Ghidra/aarch64_unchanged.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 5;i < 10;i++)
    {
        res[i][6] = get_num();
        res[i][9] = get_num();
    }
    tmp = dir + "/Ghidra/aarch64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 5;i < 10;i++)
    {
        res[i][7] = get_num();
        res[i][10] = get_num();
    }
    //Angr
    tmp = dir + "/Angr/x64_unchanged.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 10;i < 15;i++)
    {
        res[i][0] = get_num();
        res[i][3] = get_num();
    }
    tmp = dir + "/Angr/x64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 10;i < 15;i++)
    {
        res[i][1] = get_num();
        res[i][4] = get_num();
    }
    tmp = dir + "/Angr/aarch64_unchanged.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 10;i < 15;i++)
    {
        res[i][6] = get_num();
        res[i][9] = get_num();
    }
    tmp = dir + "/Angr/aarch64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 10;i < 15;i++)
    {
        res[i][7] = get_num();
        res[i][10] = get_num();
    }

    //FETCH
    tmp = dir + "/FETCH/x64_unchanged.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 15;i < 20;i++)
    {
        res[i][0] = get_num();
        res[i][3] = get_num();
    }
    tmp = dir + "/FETCH/x64_changed.log";
    freopen(tmp.c_str(),"r",stdin);
    for(int i = 15;i < 20;i++)
    {
        res[i][1] = get_num();
        res[i][4] = get_num();
    }


    for(int i = 0;i < 20;i++)
        for(int j = 0;j < 4;j++)
        {
            int k = j * 3 + 2;
            if(res[i][k - 2] == -1)
                res[i][k] = -1;
            else
                res[i][k] = (res[i][k - 2] - res[i][k - 1]) / res[i][k - 2] * 100;
        }
    /*
    printf("    --------------------x64--------------------   ------------------aarch64------------------\n");
    printf("    ------Precision------  -------Recall-------   ------Precision------  -------Recall-------\n");
    printf("     Orig    OCFI   DEC     Orig    OCFI   DEC     Orig    OCFI   DEC     Orig    OCFI   DEC\n");
    char opt[5][5] = {"O0","O2","O3","Os","Of"};
    for(int i = 0;i < 20;i++)
    {
        printf("%s  ",opt[i % 5]);
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
        if((i + 1) % 5 == 0)
            printf("    -------------------------------------------- ---------------------------------------------\n");
    }
*/
    printf("-------------------------------------------------------------------\n");
    printf("                           firgure 7                               \n");
    printf("-------------------------------------------------------------------\n");
    printf("                       O0      O2      O3      Of      Os\n");
    char info[4][30] = {"X64 Precsion    ","X64 Recall      ","AArch64 Precsion","AArch64 Recall  "};
    int cnt = 0;
    for(int i = 0;i < 12;i++)
    {
        if(i % 3 != 1)
            continue;
        for(int j = 0;j < 5;j++)
        {
            if(j % 5 == 0)
            {
                printf("%s = [",info[cnt]);
                cnt = (cnt + 1) % 6;
            }
            printf("%6.2f ",res[j][i]);
            if(j % 5 == 4)
                printf("]\n");
            else
                printf(",");
        }
    }
    printf("\n-------------------------------------------------------------------\n");
    printf("                           firgure 8                               \n");
    printf("-------------------------------------------------------------------\n");
    printf("\n--------------------------X64 Precsion-----------------------------\n");
    printf("                 O0      O2      O3      Of      Os\n");
    char info1[6][20] = {"Ghidra-Orig","Angr-Orig  ","FETCH-Orig ","Ghidra-OCFI","Angr-OCFI  ","FETCH-OCFI "};
    cnt = 0;
    for(int i = 0;i < 3;i++)
    {
        if(i % 3 == 2)
            continue;
        for(int j = 5;j < 20;j++)
        {
            if(j % 5 == 0)
            {
                printf("%s = [",info1[cnt]);
                cnt = (cnt + 1) % 6;
            }
            printf("%6.2f ",res[j][i]);
            if(j % 5 == 4)
                printf("]\n");
            else
                printf(",");
        }
    }
    printf("--------------------------X64 Recall-------------------------------\n");
    printf("                 O0      O2      O3      Of      Os\n");
    cnt = 0;
    for(int i = 3;i < 6;i++)
    {
        if(i % 3 == 2)
            continue;
        for(int j = 5;j < 20;j++)
        {
            if(j % 5 == 0)
            {
                printf("%s = [",info1[cnt]);
                cnt = (cnt + 1) % 6;
            }
            printf("%6.2f ",res[j][i]);
            if(j % 5 == 4)
                printf("]\n");
            else
                printf(",");
        }
    }
    printf("-----------------------AArch64 Precsion----------------------------\n");
    printf("                 O0      O2      O3      Of      Os\n");
    cnt = 0;
    char info2[4][20] = {"Ghidra-Orig","Angr-Orig  ","Ghidra-OCFI","Angr-OCFI  "};
    for(int i = 6;i < 9;i++)
    {
        if(i % 3 == 2)
            continue;
        for(int j = 5;j < 15;j++)
        {
            if(j % 5 == 0)
            {
                printf("%s = [",info2[cnt]);
                cnt = (cnt + 1) % 6;
            }
            printf("%6.2f ",res[j][i]);
            if(j % 5 == 4)
                printf("]\n");
            else
                printf(",");
        }
    }
    printf("-----------------------AArch64 Recall------------------------------\n");
    printf("                 O0      O2      O3      Of      Os\n");
    cnt = 0;
    for(int i = 9;i < 12;i++)
    {
        if(i % 3 == 2)
            continue;
        for(int j = 5;j < 15;j++)
        {
            if(j % 5 == 0)
            {
                printf("%s = [",info2[cnt]);
                cnt = (cnt + 1) % 6;
            }
            printf("%6.2f ",res[j][i]);
            if(j % 5 == 4)
                printf("]\n");
            else
                printf(",");
        }
    }
    printf("-------------------------------------------------------------------\n");
    // for(int i = 0;i < 12;i++)
    // {
    //     if(i % 3 == 2)
    //         continue;
    //     for(int j = 0;j < 5;j++)
    //     {
    //         if(j % 5 == 0)
    //         	printf("[");
    //         printf("%6.2f ",res[j][i]);
    //         if(j % 5 == 4)
    //             printf("]\n");
    //         else
    //             printf(",");
    //     }
    // }
    return 0;
}
