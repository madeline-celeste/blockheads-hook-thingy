
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer privacyString]
   DWARF original prototype: NSString * -[BHServer_privacyString](BHServer * self, SEL _cmd) */

#import <Foundation/Foundation.h>

@implementation BHServer;

- (NSString *)privacyString{
  if ([self isCloudMatch]) {
    BOOL isNetServerMatch = [self->match isKindOfClass:[BHNetServerMatch class]];

    if (isNetServerMatch) {
      BHNetPrivacy privacyMode = [self->match privacy];

      if (privacyMode == 3) {
        return @"private";
      } else if (privacyMode == 2) {
        return @"searchable"
      } else {
        return @"public";
      }
    }
  }

  return nil;
}

@end