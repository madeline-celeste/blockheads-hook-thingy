// originally i hooked multiple c functions but now this is kinda useless lol
// though makes it easier for anyone to add their own c hooks if they want and need for some reason

#include <cstdlib>
#include <dlfcn.h>
#include <stdio.h>

#define DEFINE_OVERRIDE_SYM(symbol_name) \
    static decltype(&symbol_name) r_##symbol_name = NULL
template<typename T>
T load_symbol(const char* name) {
    void* symbol = dlsym(RTLD_NEXT, name);
    if (!symbol) {
        fprintf(stderr, "Failed to load %s: %s\n", name, dlerror());
        std::abort();
    }
    return reinterpret_cast<T>(symbol);
}


#define LOAD_OVERRIDE_SYM(symbol_name) \
    r_##symbol_name = load_symbol<decltype(r_##symbol_name)>(#symbol_name)
