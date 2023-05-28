
#include <dlfcn.h>
#include <iostream>
#include <exception>


#ifdef __GNUC__
typedef void __attribute__((__noreturn__)) (*cxa_throw_type)(void*, void*, void(*)(void*));
#elif defined(__clang__)
typedef void __attribute__((__noreturn__)) (*cxa_throw_type)(void*, std::type_info*, void (_GLIBCXX_CDTOR_CALLABI*) (void*));
#endif

typedef void __attribute__((__noreturn__)) (*cxa_rethrow_type)(void);

cxa_rethrow_type orig_cxa_rethrow = nullptr;

void load_orig_rethrow_code()
{
    orig_cxa_rethrow = (cxa_rethrow_type) dlsym(RTLD_NEXT, "__cxa_rethrow");
}

extern "C"
void __cxa_rethrow()
{
    if (orig_cxa_rethrow == nullptr)
        load_orig_rethrow_code();

    {
	//std::freopen("/tmp/throw_count.log","r",stdin);
	//std::freopen("/tmp/throw_count.log","w",stdout);
	//int throw_count_T = 20;
	//std::cin >> throw_count_T;
	//throw_count_T++;
	std::cerr << "T:Enter cxa_rethrow" << std::endl;
	//abort();
	//freopen("/dev/console", "r", stdin);
	//freopen("/dev/console", "w", stdout);
	//fclose(stdout);
    }
    orig_cxa_rethrow();
}

cxa_throw_type orig_cxa_throw = nullptr;

void load_orig_throw_code()
{
    orig_cxa_throw = (cxa_throw_type) dlsym(RTLD_NEXT, "__cxa_throw");
}

extern "C"
void __cxa_throw(void* thrown_exception, void* pvtinfo, void (*dest)(void *))
{
    if (orig_cxa_throw == nullptr)
        load_orig_throw_code();

    {
	//std::freopen("/tmp/throw_count.log","r",stdin);
	//std::freopen("/tmp/throw_count.log","w",stdout);
	//int throw_count_T = 20;
	//std::cin >> throw_count_T;
	//throw_count_T++;
	std::cerr << "T:Enter cxa_throw" << std::endl;
	//abort();
	//freopen("/dev/console", "r", stdin);
	//freopen("/dev/console", "w", stdout);
	//fclose(stdout);
    }
    orig_cxa_throw(thrown_exception, pvtinfo, dest);
}

