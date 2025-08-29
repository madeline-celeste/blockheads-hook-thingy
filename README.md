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

running:

```sh
LD_PRELOAD=./libhook.so ./blockheads_server171
```
example:
```sh
LD_PRELOAD=./libhook.so ./blockheads_server171 --load [worldID]
```

### MacOS
```sh
$ cowsay "god help you"
```

## Lua API
- objc objects are turned into an `ObjcObject`
    - with some exceptions, like `NSString`s and `NSArray`s
- objc selectors are turned into an `ObjcSelector`

## Notes

- better readme coming Soon:TM:
- you will find that i could not make up my mind on what i should name things lmao
- stuff really starts in main_hook.mm, probably shouldnt in retrospect lmao
- this is very incomplete and unstable and incomplete and very unstable