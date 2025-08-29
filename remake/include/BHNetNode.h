#import <Foundation/Foundation.h>
#include <Foundation/NSDictionary.h>

@class BHMatch;
@class World;
@class GKVoiceChat;

typedef NSInteger BHNetNodeType;

@interface BHNetNode : NSObject

@property (nonatomic, assign) NSObject* delegate;
@property (nonatomic, retain) BHMatch* match;
@property (nonatomic, retain) GKVoiceChat* voiceChat;
@property (nonatomic, retain) NSMutableArray* livePlayerInfos;
@property (nonatomic, retain) NSMutableDictionary* playerInfosForAllPlayersByID;
@property (nonatomic, assign) BHNetNodeType netNodeType;

@end