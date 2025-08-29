
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer full]
   DWARF original prototype: BOOL -[BHServer_full](BHServer * self, SEL _cmd) */

BOOL __thiscall -[BHServer_full](void *this,SEL _cmd)

{
  code *pcVar1;
  undefined8 uVar2;
  ulong uVar3;
  ulong uVar4;
  bool local_61;
  int local_58;
  int count;
  SEL _cmd_local;
  BHServer *this_local;

  serverClientsCount = [[this->world serverClients] count];
  connectedClientsCount = [this->connectedClients count];

  if (connectedClientsCount < serverClientsCount) {
    local_58 = [[[this->world] serverClients] count];
  } else {
    local_58 = [this->connectedClients count];
  }

  BOOL isFull = ((this->maxPlayers <= local_58) || 0x1f < local_58);

  return isFull;
}

