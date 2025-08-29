#import <Foundation/Foundation.h>

#import "BHNetNode.h"
#import "BHNetConstants.h"
#import "MJMath.h"

@class BHNetServerMatch;
@class World;
@class DatabaseEnvironment;
@class Database;

typedef NS_ENUM(NSInteger, ListType) {
    LIST_TYPE_BLACKLIST,
    LIST_TYPE_WHITELIST,
    LIST_TYPE_ADMIN,
    LIST_TYPE_MOD
};

@interface BHServer : BHNetNode

@property (nonatomic, retain) World* world;
@property (nonatomic, retain) NSString* saveID;
@property (nonatomic, retain) NSMutableArray* unapprovedClients;
@property (nonatomic, retain) NSMutableArray* connectedClients;
@property (nonatomic, retain) NSMutableArray* chatHistory;
@property (nonatomic, retain) NSMutableArray* recentPlayers;
@property (nonatomic, retain) NSArray* blackList;
@property (nonatomic, retain) NSArray* curseList;
@property (nonatomic, retain) NSArray* whiteList;
@property (nonatomic, retain) NSArray* cloudWideAdminList;
@property (nonatomic, retain) NSArray* cloudWideInvisibleAdminList;
@property (nonatomic, retain) NSArray* modList;
@property (nonatomic, retain) NSArray* resetList;
@property (nonatomic, retain) NSArray* repairSet;
@property (nonatomic, assign) int maxPlayers;
@property (nonatomic, retain) NSMutableDictionary* cachedPlayerImages;
@property (nonatomic, retain) NSMutableDictionary* cachedPlayerBanned;
@property (nonatomic, assign) BOOL needsToSendUpdatedListToClients;
@property (nonatomic, retain) NSMutableArray* clientsWaitingForInitialData;
@property (nonatomic, retain) NSMutableArray* clientsConnectedWithPhotosUnsent;
@property (nonatomic, retain) NSMutableDictionary* tradePortalTransactions;
@property (nonatomic, retain) NSString* playerUpdate;
@property (nonatomic, assign) float playerUpdateTimer;
@property (nonatomic, assign) double lastPlayerUpdate;
@property (nonatomic, assign) double rulesChangedTime;
@property (nonatomic, retain) DatabaseEnvironment* serverDatabaseEnvironment;
@property (nonatomic, retain) Database* serverDatabase;

- (void)addPlayerDictToAllPlayersEver:(NSDictionary*)playerDict;
- (NSArray*)adminList;
- (NSArray*)blackList;
- (NSArray*)bootAllClientsDueToNoCredit;
- (void)bootPlayer:(NSString*)playerID wasBan:(BOOL)wasBan;
- (void)bootPlayerNamed:(NSString*)playerID wasBan:(BOOL)wasBan;
- (void)cleanup;
- (void)clearList:(ListType)listType;
- (void)clientDisconnected:(NSString*)playerID wasKick:(BOOL)wasKick;
- (void)clientFinishedAwaySimulation:(NSString*)clientID;
- (NSArray*)connectedClientIDs;
- (float)credit;
- (void)dealloc;
- (void)delayedDisconnectPlayerDueToKickWithID:(NSString*)playerID;
- (void)delayedDisconnectPlayerDueToNoCreditWithiD:(NSString*)playerID;
- (void)delayedSendUpdatedPlayerListToClients;
- (void)doRepairForTileAtPos:(intpair)pos;
- (BOOL)finishBulkTransaction;
- (BOOL)full;
- (void)fullPlayerInformationNowAvailableForPlayer:(NSString*)playerID;
- (NSString*)getDebugLog;
- (NSArray*)getRecentPlayerNamesForOwnershipSign;
- (void)handleCommand:(NSString*)command issueClient:(NSString*)issueClient;
- (void)infoArrived:(NSMutableDictionary*)dict forPlayer:(NSString*)forPlayer;
- (id)initWithDelegate:(id)delegate match:(BHMatch*)match netNodeType:(BHNetNodeType*)netNodeType saveID:(NSString*)saveID maxPlayers:(int)maxPlayers;
- (BOOL)isCloudMatch;
- (BOOL)isWaitingForMultiPartCommandResponse;
- (void)match:(BHMatch*)match connectionWithPlayerFailed:(NSString*)playerID withError:(NSError*)error;
- (void)match:(BHMatch*)match didFailWithError:(NSError*)error;
- (void)match:(BHMatch*)match didReceiveData:(NSData*)data fromPlayer:(NSString*)peer;
- (void)match:(BHMatch*)match player:(NSString*)playerID didChangeState:(BHPlayerConnectionState)state;
- (BOOL)match:(BHMatch*)match shouldReinvitePlayer:(NSString*)playerID;
- (NSString*)modifyPlayerListForPlayerOrIP:(NSString*)nameOrIP isAdded:(BOOL)isAdded listType:(BOOL)listType;
- (NSString*)modifyPlayerListForPlayerOrIP:(NSString*)nameOrIP isAdded:(BOOL)isAdded listType:(BOOL)listType banUDID:(BOOL)banUDID;
- (NSArray*)modList;
- (BOOL)playerIsAdminWithAlias:(NSString*)alias;
- (BOOL)playerIsAdminWithID:(NSString*)playerID;
- (BOOL)playerIsBannedWithID:(NSString*)playerID;
- (BOOL)playerIsBlacklistedWithInfo:(NSDictionary*)playerInfo;
- (BOOL)playerIsCloudWideAdminWithAlias:(NSString*)alias;
- (BOOL)playerIsCloudWideInvisibleAdminWithAlias:(NSString*)alias;
- (BOOL)playerIsConnctedWithInfo:(NSDictionary*)playerInfo;
- (BOOL)playerIsModWithAlias:(NSString*)alias;
- (BOOL)playerIsOwnerWithAlias:(NSString*)alias;
- (BOOL)playerIsWhitelistedWithAlias:(NSString*)alias;
- (NSArray*)playerListToSendIncludingPhotosForClients:(NSArray*)includeClients sendClient:(NSString*)sendClient;
- (BHServer*)playerNameForPlayerWithIDIncludingOldPlayers:(NSString*)playerID;
- (NSString*)playerUpdate;
- (NSString*)privacyString;
- (NSArray*)recentPlayers;
- (void)reloadLists;
- (NSString*)removeCurseWordsFromBlockheadName:(NSString*)blockheadName;
- (NSString*)replaceCurseWordsForMessage:(NSString*)message client:(NSString*)playerID;
- (void)saveAllPlayersArray;
- (void)savedPlayerInfoDataForPlayer:(NSString*)playerID;
- (void)saveResetList;
- (void)sendChatMessage:(NSString*)messageText displayNotification:(BOOL)displayNotification sendToClients:(NSArray*)clientsToSend;
- (void)sendInitialPlayerListToClient;
- (void)sendNetworkData:(NSData*)netData toPeers:(NSData*)peers reliable:(BOOL)reliable;
- (void)sendPlayerChangedNotificationToDelegate;
- (void)sendPortalChestAcknowledgementIfNeededForClient:(NSString*)clientID;
- (void)sendUpdatedPlayerListToclients;
- (Database*)serverDatabase;
- (NSString*)serverPlayerID;
- (void)setWorld:(World*)world;
- (void)startBulkTransaction;
- (void)updateCredit:(float)dt;
- (void)updatePlayer:(NSString*)clientID;
- (void)updatePlayers;
- (NSArray*)whiteList;

@end