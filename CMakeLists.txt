cmake_minimum_required(VERSION 3.16)
project(hook LANGUAGES C CXX OBJC OBJCXX)

message(STATUS "C compiler:   ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "ObjC compiler: ${CMAKE_OBJC_COMPILER}")
message(STATUS "ObjC++ compiler: ${CMAKE_OBJCXX_COMPILER}")

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

# NOTE: compiled without ARC, because it results in errors at runtime.
# think blockheads wasnt compiled with it. no idea though, objc is new to me lol
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|AppleClang")
    target_compile_options(hook PRIVATE -fno-objc-arc)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(hook PRIVATE -fobjc-exceptions) # required for @throw
endif()


if (APPLE)
    find_library(COCOA_FRAMEWORK Cocoa REQUIRED)
    target_link_libraries(hook ${COCOA_FRAMEWORK})
else()
    target_link_libraries(hook dl)
    target_compile_options(hook PRIVATE -fconstant-string-class=NSConstantString)
endif()

# not sure if this is bad to be compiled as a different version than the source
target_compile_features(hook PRIVATE cxx_std_20)