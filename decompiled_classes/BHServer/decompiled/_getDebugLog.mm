
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer getDebugLog]
   DWARF original prototype: NSString * -[BHServer_getDebugLog](BHServer * self, SEL _cmd) */

#import <Foundation/Foundation.h>

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

  NSString* debugLog = [NSMutableString string]
  [debugLog appendFormat:@"server version:%@\n", @"1.7.1"];
  [debugLog appendFormat:@"connectedClients:%lu\n", [self->connectedClients count]];
  
  read_off_memory_status();
  lVar4 = sysconf(0x1e);
  if (pageSize != -1) {
    local_d8 = (float)(ulong)(pageSize * lVar4);
    local_f0 = (float)(memory.size * lVar4);
    local_100 = (float)(memory.resident * lVar4);

    [debugLog appendFormat:@"memory usage: total:%.2f MB resident:%.2f MB share:%.2f MB\n",
      (double)(local_d8 / 1048576.0),
      (double)(local_f0 / 1048576.0),
      (double)(local_100 / 1048576.0)
    ];
  }

  [this->world appendDebugLog:debugLog];

  return debugLog;
}

