# blockheads hooky thingy:tm:

note: i know very little about objc fyi so this might suck lol

## Build Dependencies
- libffi
- lua 5.4
- cmake
- probably something else
- luck

## Building

```sh
$ cmake .
$ make
```

## Running

### Linux

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