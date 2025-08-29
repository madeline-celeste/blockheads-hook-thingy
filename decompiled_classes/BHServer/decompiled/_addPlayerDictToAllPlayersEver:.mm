
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer addPlayerDictToAllPlayersEver:]
   DWARF original prototype: void -[BHServer_addPlayerDictToAllPlayersEver:](BHServer * self, SEL
   _cmd, NSDictionary * playerDict) */

#include <Foundation/Foundation.h>
void __thiscall
-[BHServer_addPlayerDictToAllPlayersEver:](void *this,SEL _cmd,NSDictionary *playerDict)

{
  undefined8 uVar1;
  code *pcVar2;
  id pList;
  ulong uVar3;
  undefined8 uVar4;
  NSData *pNVar5;
  undefined8 uVar6;
  NSData *data;
  NSString *playerID;
  NSDictionary *lastEntry;
  NSMutableDictionary *newDictForAllPlayersEver;
  NSDictionary *playerDict_local;
  SEL _cmd_local;
  BHServer *this_local;

  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:playerDict];
  [dict removeObjectForKey:@"clientReconnected"];
  [dict removeObjectForKey:@"micOrSpeakerOn"];
  [dict removeObjectForKey:@"voiceConnected"];
  [dict removeObjectForKey:@"grp.photo"];

  NSDate* date = [NSDate date];
  [dict setObject:date:forKey:@"lastSeen"];

  [this->recentPlayers insertObject:pList:atIndex:0];
  
  while( true ) {
    int count = [this->recentPlayers count];
    if (count < 0x81) break;

    lastPlayer = [this->recentPlayers lastObject];
    World* world = this->world;
    NSString* playerID = [lastPlayer objectForKey:@"playerID"];
    [world archiveLightBlocksForClient:playerID];
    [recentPlayers removeLastObject];
  }
 
  NSString* playerID = [playerDict objectForKey:@"playerID"];
  NSData* data = dataFromPropertyList(pList);

  if (data != (NSData *)0x0) {
    Database* database = [this->serverDatabase];
    [database setData:data:forKey:[NSString stringWithFormat:@"%@_info"]];
  }

  return;
}

