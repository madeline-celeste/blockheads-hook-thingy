
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer match:connectionWithPlayerFailed:withError:]
   DWARF original prototype: void -[BHServer_match:connectionWithPlayerFailed:withError:](BHServer *
   self, SEL _cmd, BHMatch * match, NSString * playerID, NSError * error) */

void __thiscall -[BHServer_match:connectionWithPlayerFailed:withError:]
          (void *this,SEL _cmd,BHMatch *match,NSString *playerID,NSError *error)

{
  undefined8 uVar1;
  char cVar2;
  code *pcVar3;
  NSError *error;
  NSString *playerID;
  BHMatch *match;
  SEL _cmd;
  BHServer *this;
  
  NSLog(@"connectionWithPlayerFailed %@", playerID);
  [this->unapprovedClients removeObject:playerID];
  [this->connectedClients removeObject:playerID];
  [this->tradePortalTransactions removeObjectForKey:playerID];

  [this clientDisconnected:playerID:wasKick:NO];
  
  // theory: uVar1 = *(undefined8 *)((long)this + 8); might be super i think
  BOOL respondsToPlayersChanged = [super respondsToSelector:@selector(playersChanged)];

  if (respondsToPlayersChanged) {
    [super playersChanged];
  }

  [this sendUpdatedPlayerListToClients];
}

