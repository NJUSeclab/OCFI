#include <iostream>
using namespace std;
void throw2()
{
	throw -1;
}
void throw1()
{	
	throw2();	
}
void exception_test(double m, double n)
{
    try {
        cout << "before dividing." << endl;
        if( n == 0)
            throw1(); //抛出int类型异常
        else
            cout << m / n << endl;
        cout << "after dividing." << endl;
    }
    catch(double d) {
        cout << "catch(double) " << d <<  endl;
    }
    catch(int e) {
        cout << "catch(int) " << e << endl;
    }
    cout << "finished" << endl;
}
int main()
{
    double m ,n;
    cin >> m >> n;
    exception_test(m,n);
    printf("TTTTT\n");
    return 0;
}
