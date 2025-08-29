
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
  
                    /* 0x38 = world */
  uVar2 = *(undefined8 *)((long)this + 0x38);
                    /* "serverClients" */
  pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7f68);
  uVar2 = (*pcVar1)(uVar2,0xbe7f68);
                    /* "count" */
  pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7d58);
  uVar3 = (*pcVar1)(uVar2,0xbe7d58);
                    /* 0x50 = connectedClients */
  uVar2 = *(undefined8 *)((long)this + 0x50);
                    /* "count" */
  pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7d58);
  uVar4 = (*pcVar1)(uVar2,0xbe7d58);
  if (uVar4 < uVar3) {
                    /* 0x38 = world */
    uVar2 = *(undefined8 *)((long)this + 0x38);
                    /* "serverClients" */
    pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7f68);
    uVar2 = (*pcVar1)(uVar2,0xbe7f68);
                    /* "count" */
    pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7d58);
    local_58 = (*pcVar1)(uVar2,0xbe7d58);
  }
  else {
                    /* 0x50 = connectedClients */
    uVar2 = *(undefined8 *)((long)this + 0x50);
                    /* "count" */
    pcVar1 = (code *)objc_msg_lookup(uVar2,0xbe7d58);
    local_58 = (*pcVar1)(uVar2,0xbe7d58);
  }
                    /* 0xb0 = maxPlayers */
  local_61 = *(int *)((long)this + 0xb0) <= local_58 || 0x1f < local_58;
  return local_61;
}

