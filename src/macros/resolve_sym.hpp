// i dont remember what this was for lmao

#pragma once

#include <dlfcn.h>

#define RESOLVE_SYM(handle, name) \
    if (!(name)) { \
        (name) = (decltype(name)) dlysm((handle), #name); \
        if (!(name)) { \
            fprintf(stderr, "Failed to resolve %s\n", #name); \
            abort(); \
        } \
    }
