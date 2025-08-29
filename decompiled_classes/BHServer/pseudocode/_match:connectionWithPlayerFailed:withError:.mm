
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer match:connectionWithPlayerFailed:withError:]
   DWARF original prototype: void -[BHServer_match:connectionWithPlayerFailed:withError:](BHServer *
   self, SEL _cmd, BHMatch * match, NSString * playerID, NSError * error) */

void __thiscall
-[BHServer_match:connectionWithPlayerFailed:withError:]
          (void *this,SEL _cmd,BHMatch *match,NSString *playerID,NSError *error)

{
  undefined8 uVar1;
  char cVar2;
  code *pcVar3;
  NSError *error_local;
  NSString *playerID_local;
  BHMatch *match_local;
  SEL _cmd_local;
  BHServer *this_local;
  
  NSLog(.objc_str.290,playerID);
                    /* 0x48 = unapprovedClients */
  uVar1 = *(undefined8 *)((long)this + 0x48);
                    /* "removeObject:" */
  pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe7838);
  (*pcVar3)(uVar1,0xbe7838,playerID);
                    /* 0x50 = connectedClients */
  uVar1 = *(undefined8 *)((long)this + 0x50);
                    /* "removeObject:" */
  pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe7838);
  (*pcVar3)(uVar1,0xbe7838,playerID);
                    /* 0xe0 = tradePortalTransactions */
  uVar1 = *(undefined8 *)((long)this + 0xe0);
                    /* "removeObjectForKey:" */
  pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe8118);
  (*pcVar3)(uVar1,0xbe8118,playerID);
                    /* "clientDisconnected:wasKick:" */
  pcVar3 = (code *)objc_msg_lookup(this,0xbe8138);
  (*pcVar3)(this,0xbe8138,playerID,0);
  uVar1 = *(undefined8 *)((long)this + 8);
                    /* "respondsToSelector:" */
  pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe8098);
                    /* "playersChanged" */
  cVar2 = (*pcVar3)(uVar1,0xbe8098,0xbe7db8);
  if (cVar2 != '\0') {
    uVar1 = *(undefined8 *)((long)this + 8);
                    /* "playersChanged" */
    pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe7dc8);
    (*pcVar3)(uVar1,0xbe7dc8);
  }
                    /* "sendUpdatedPlayerListToClients" */
  pcVar3 = (code *)objc_msg_lookup(this,0xbe7d08);
  (*pcVar3)(this,0xbe7d08);
  return;
}

