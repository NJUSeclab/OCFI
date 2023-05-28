Makefile:
 
all:
	g++ -fPIC -shared -o libhook.so new_cxa_throw.cpp -ldl
	g++ exception_test.cpp -o exception_test
	cat test.input | LD_PRELOAD=./libhook.so ./exception_test
