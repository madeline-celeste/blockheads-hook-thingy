
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer getDebugLog]
   DWARF original prototype: NSString * -[BHServer_getDebugLog](BHServer * self, SEL _cmd) */

NSString * __thiscall -[BHServer_getDebugLog](void *this,SEL _cmd)

{
  undefined8 uVar1;
  code *pcVar2;
  NSString *pNVar3;
  long lVar4;
  float local_100;
  float local_f0;
  float local_d8;
  long pageSize;
  statm_t memory;
  NSMutableString *result;
  SEL _cmd_local;
  BHServer *this_local;
  
  uVar1 = objc_lookup_class("NSMutableString");
                    /* "string" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe8078);
  pNVar3 = (NSString *)(*pcVar2)(uVar1,0xbe8078);
                    /* "appendFormat:" */
  pcVar2 = (code *)objc_msg_lookup(pNVar3,0xbe8258);
                    /* "server version:%@\n"
                       "1.7.1" */
  (*pcVar2)(pNVar3,0xbe8258,.objc_str.440,.objc_str.441);
                    /* 0x50 = connectedClients */
  uVar1 = *(undefined8 *)((long)this + 0x50);
                    /* "count" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7d58);
  uVar1 = (*pcVar2)(uVar1,0xbe7d58);
                    /* "appendFormat:" */
  pcVar2 = (code *)objc_msg_lookup(pNVar3,0xbe8258);
                    /* "connectedClients:%lu\n" */
  (*pcVar2)(pNVar3,0xbe8258,.objc_str.442,uVar1);
  read_off_memory_status();
  lVar4 = sysconf(0x1e);
  if (pageSize != -1) {
    local_d8 = (float)(ulong)(pageSize * lVar4);
    local_f0 = (float)(memory.size * lVar4);
    local_100 = (float)(memory.resident * lVar4);
                    /* "appendFormat:" */
    pcVar2 = (code *)objc_msg_lookup(pNVar3,0xbe8258);
                    /* "memory usage: total:%.2f MB resident:%.2f MB share:%.2f MB\n" */
    (*pcVar2)((double)(local_d8 / 1048576.0),(double)(local_f0 / 1048576.0),
              (double)(local_100 / 1048576.0),pNVar3,0xbe8258,.objc_str.443);
  }
                    /* 0x38 = world */
  uVar1 = *(undefined8 *)((long)this + 0x38);
                    /* "appendDebugLog:" */
  pcVar2 = (code *)objc_msg_lookup(uVar1,0xbe7bd8);
  (*pcVar2)(uVar1,0xbe7bd8,pNVar3);
  return pNVar3;
}

