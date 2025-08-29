#import <Foundation/Foundation.h>
#import "World.h"
#import "BHServer.h"

@interface GameController : NSObject

@property(nonatomic, retain) World* world;
@property(nonatomic, retain) BHServer* bhServer;
@property(nonatomic, retain) NSString* worldName;
//cache
//updateimer
//lasttime
//accumulator
//needstoexitworld
//windowinfo
//appdelegate
@property(nonatomic, retain) NSNumber* port;
@property(nonatomic, retain) NSString* saveID;
@property(nonatomic, retain) NSArray* chatMessages;

- (void)clearChat;

@end