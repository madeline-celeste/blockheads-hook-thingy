

#import <Foundation/Foundation.h>
#include <Foundation/NSDate.h>
#include <cstdint>

#import "BHMatch.h"
#import "BHNetConstants.h"

@class BHMatch;
@class ENetHost;

@interface BHNetServerMatch : BHMatch

@property (nonatomic, assign) uint16_t serverPort;
@property (nonatomic, retain) ENetHost* enetServer;
@property (nonatomic, retain) NSMutableDictionary* connections;
@property (nonatomic, retain) NSMutableDictionary* persistentIdsToEnetIds;
@property (nonatomic, retain) NSMutableDictionary* enetIdsToPersistentIds;
@property (nonatomic, retain) NSMutableArray* playerInfos;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* worldName;
@property (nonatomic, retain) NSString* ownerName;
@property (nonatomic, retain) NSString* cloudSalt;
@property (nonatomic, assign) uint16_t portToUse;
@property (nonatomic, assign) BOOL hasLocalPlayer;
@property (nonatomic, retain) NSTimer* pollTimer;
@property (nonatomic, assign) float noCreditBootTimer;
@property (nonatomic, assign) NSTimeInterval credit;
@property (nonatomic, assign) NSTimeInterval pollTimerLastTime;
@property (nonatomic, assign) BHNetPrivacy privacy;

- (BHNetPrivacy)privacy;


@end