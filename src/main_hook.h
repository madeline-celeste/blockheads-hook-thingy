#import <Foundation/Foundation.h>

extern BOOL isFoundationReady;

typedef int (*main_fn)(int, char **, char **);
typedef int (*libc_start_main_fn)(main_fn, int, char **,
                                  void (*)(void), void (*)(void),
                                  void (*)(void), void *);

void init_hook_state();