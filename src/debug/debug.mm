
#import "debug.h"

#import <Foundation/Foundation.h>

// TODO: maybe remove this all and add
// lua equivalents since now stuff is being done in lua

void DumpIvarsForClass(Class cls) {
    unsigned count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    NSLog(@"Ivars for %@:", cls);
    for (unsigned i = 0; i < count; i++) {
        Ivar iv = ivars[i];
        const char *name = ivar_getName(iv);
        const char *type = ivar_getTypeEncoding(iv);
        ptrdiff_t off = ivar_getOffset(iv);
        NSLog(@"  %3u: %-30s off=0x%tx type=%s", i, name ? name : "(null)", off, type ? type : "?");
    }
    free(ivars);
}

void printSuperclasses(Class cls) {
    NSLog(@"Class hierarchy for %s:", class_getName(cls));
    while (cls) {
        NSLog(@"  %s", class_getName(cls));
        cls = class_getSuperclass(cls);
    }
}
