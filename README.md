# blockheads hooky thingy:tm:

note: i know very little about objc fyi so this might suck lol

## Build Dependencies
- libffi
- lua 5.4
- cmake
- libgnustep
- gcc-objc (if using gcc)
- probably something else
- luck
### On Arch Linux
```sh
# if using gcc:
$ pacman -Syu cmake gcc --asdeps gnustep-base gcc-objc
# if using clang:
$ pacman -Syu cmake clang --asdeps gnustep-base
```

## Building
must have `cmake` installed. then just need to run:
```sh
$ cmake -B build -S .
$ cmake --build build
```
can also add `-G Ninja` if you want it to use ninja when building. is a lot faster but not really necessary.
```sh
$ cmake -B build -S . -G Ninja
$ cmake --build build
```
or if you want a specific compiler:
#### gcc/gcc++
```sh
$ cmake -B build_gcc -S . \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_OBJC_COMPILER=gcc \
  -DCMAKE_OBJCXX_COMPILER=g++
$ cmake --build build_gcc
```
#### clang/clang++
```sh
$ cmake -B build_clang -S . \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_OBJC_COMPILER=clang \
  -DCMAKE_OBJCXX_COMPILER=clang++
$ cmake --build build_clang
```

## Running

### Linux

launch the server with the library loaded. the easiest (and non-permanent) way to do this is to use `LD_PRELOAD`.
```sh
$ LD_PRELOAD=./libhook.so ./blockheads_server171
```
example:
```sh
$ LD_PRELOAD=./libhook.so ./blockheads_server171 --load [worldID]
```

### MacOS
```sh
$ cowsay "god help you"
```

## Lua API
- objc objects are turned into an `ObjcObject`
    - with some exceptions, like `NSString`s and `NSArray`s
    - calls to `ObjcObject`s work through magic. kind of. barely.
- objc selectors are turned into an `ObjcSelector`

## Notes

- better readme coming Soon:TM:
- you will find that i could not make up my mind on what i should name things lmao
- this is very incomplete and unstable and incomplete and very unstable
- the real main() function is throttled for 100 ms (defined by `MAIN_THROTTLE_MS`).
    - this is intended to fix race conditions with lua hooking.
    - i am not sure if there is a better solution. all suggestions and stuff are welcome!

## Issues

- sometimes it will segfault. only sometimes. dont ask me why!!! (probably some sort of race condition with the horrendous lua_runner junk)
- seems to be some undefined behavior causing stuff to be on the lua stack when they shouldnt be.
(has caused wait() to think it has a function or something as an argument when it was supplied nothing)
