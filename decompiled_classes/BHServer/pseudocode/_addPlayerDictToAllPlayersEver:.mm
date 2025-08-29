
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer addPlayerDictToAllPlayersEver:]
   DWARF original prototype: void -[BHServer_addPlayerDictToAllPlayersEver:](BHServer * self, SEL
   _cmd, NSDictionary * playerDict) */

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
  
  uVar1 = objc_lookup_class("NSMutableDictionary");
                    /* "dictionaryWithDictionary:" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7768);
  pList = (id)(*pcVar2)(uVar1,0xbe7768,playerDict);
                    /* "removeObjectForKey:" */
  pcVar2 = (code *)objc_msg_lookup(pList,0xbe8118);
                    /* "clientReconnected" */
  (*pcVar2)(pList,0xbe8118,.objc_str.264);
                    /* "removeObjectForKey:" */
  pcVar2 = (code *)objc_msg_lookup(pList,0xbe8118);
                    /* "micOrSpeakerOn" */
  (*pcVar2)(pList,0xbe8118,.objc_str.265);
                    /* "removeObjectForKey:" */
  pcVar2 = (code *)objc_msg_lookup(pList,0xbe8118);
                    /* "voiceConnected" */
  (*pcVar2)(pList,0xbe8118,.objc_str.266);
                    /* "removeObjectForKey:" */
  pcVar2 = (code *)objc_msg_lookup(pList,0xbe8118);
                    /* "grp.photo" */
  (*pcVar2)(pList,0xbe8118,.objc_str.267);
  uVar1 = objc_lookup_class("NSDate");
                    /* "date" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7c78);
  uVar1 = (*pcVar2)(uVar1,0xbe7c78);
                    /* "setObject:forKey:" */
  pcVar2 = (code *)objc_msg_lookup(pList,0xbe7e48);
                    /* "lastSeen" */
  (*pcVar2)(pList,0xbe7e48,uVar1,.objc_str.291);
  uVar1 = *(undefined8 *)((long)this + 0x60);
                    /* "insertObject:atIndex:" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7fe8);
  (*pcVar2)(uVar1,0xbe7fe8,pList,0);
  while( true ) {
                    /* 0x60 = recentPlayers */
    uVar1 = *(undefined8 *)((long)this + 0x60);
                    /* "count" */
    pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7d58);
    uVar3 = (*pcVar2)(uVar1,0xbe7d58);
    if (uVar3 < 0x81) break;
                    /* 0x60 = recentPlayers */
    uVar1 = *(undefined8 *)((long)this + 0x60);
                    /* "lastObject" */
    pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7d68);
    uVar4 = (*pcVar2)(uVar1,0xbe7d68);
                    /* 0x38 = world */
    uVar1 = *(undefined8 *)((long)this + 0x38);
                    /* "objectForKey:" */
    pcVar2 = (code *)objc_msg_lookup(uVar4,0xbe8038);
                    /* "playerID" */
    uVar4 = (*pcVar2)(uVar4,0xbe8038,.objc_str.274);
                    /* "archiveLightBlocksForClient:" */
    pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7fc8);
    (*pcVar2)(uVar1,0xbe7fc8,uVar4);
                    /* 0x60 = recentPlayers */
    uVar1 = *(undefined8 *)((long)this + 0x60);
                    /* "removeLastObject" */
    pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe77c8);
    (*pcVar2)(uVar1,0xbe77c8);
  }
                    /* "objectForKey:" */
  pcVar2 = (code *)objc_msg_lookup(playerDict,0xbe8038);
                    /* "playerID" */
  uVar1 = (*pcVar2)(playerDict,0xbe8038,.objc_str.274);
  pNVar5 = dataFromPropertyList(pList);
  if (pNVar5 != (NSData *)0x0) {
                    /* 0x110 = serverDatabase */
    uVar4 = *(undefined8 *)((long)this + 0x110);
    uVar6 = objc_lookup_class("NSString");
                    /* "stringWithFormat:" */
    pcVar2 = (code *)objc_msg_lookup(uVar6,0xbe7798);
                    /* "%@_info" */
    uVar1 = (*pcVar2)(uVar6,0xbe7798,.objc_str.292,uVar1);
                    /* "setData:forKey:" */
    pcVar2 = (code *)objc_msg_lookup(uVar4,0xbe80b8);
    (*pcVar2)(uVar4,0xbe80b8,pNVar5,uVar1);
  }
  return;
}

