cmake_minimum_required(VERSION 3.16)
project(hook LANGUAGES C CXX OBJC OBJCXX)

# Grab all source files in src/
file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS src/*.mm src/*.m src/*.cpp src/*.c)

# Build the shared library
add_library(hook SHARED ${SRC_FILES})

# Include headers in ./src
# i dont know WHY but this breaks everything all of a sudden. it did not before and then
# i broke it somehow lmao
#target_include_directories(hook PRIVATE src)

find_package(Lua 5.4 REQUIRED)
target_include_directories(hook PRIVATE ${LUA_INCLUDE_DIR})
target_link_libraries(hook ${LUA_LIBRARIES})

# libffi
find_path(FFI_INCLUDE_DIR ffi.h)
find_library(FFI_LIBRARY ffi)
target_include_directories(hook PRIVATE ${FFI_INCLUDE_DIR})
target_link_libraries(hook ${FFI_LIBRARY})

target_link_libraries(hook dl)

# NOTE: compiled without ARC, because it results in errors at runtime.
# think blockheads wasnt compiled with it. no idea though, objc is new to me lol

# Extra compiler flags
target_compile_options(hook PRIVATE
    -fobjc-exceptions # gimmee
    -fconstant-string-class=NSConstantString   # i had to do this to stop errors at
                                                # some point but seems to be fine now

                                                # ^^^ FUCK NEVERMIND keep it on...
)

# C++ standard if needed
target_compile_features(hook PRIVATE cxx_std_17)