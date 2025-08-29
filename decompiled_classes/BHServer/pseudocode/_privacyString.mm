
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer privacyString]
   DWARF original prototype: NSString * -[BHServer_privacyString](BHServer * self, SEL _cmd) */

NSString * __thiscall -[BHServer_privacyString](void *this,SEL _cmd)

{
  undefined8 uVar1;
  char cVar2;
  code *pcVar3;
  undefined8 uVar4;
  long lVar5;
  BHNetPrivacy privacy;
  SEL _cmd_local;
  BHServer *this_local;
  
                    /* "isCloudMatch" */
  pcVar3 = (code *)objc_msg_lookup(this,0xbe7cc8);
  cVar2 = (*pcVar3)(this,0xbe7cc8);
  if (cVar2 != '\0') {
    uVar1 = *(undefined8 *)((long)this + 0x10); // super->match
    uVar4 = objc_lookup_class("BHNetServerMatch");
                    /* "class" */
    pcVar3 = (code *)objc_msg_lookup(uVar4,0xbe7f48); 
    uVar4 = (*pcVar3)(uVar4,0xbe7f48);
                    /* "isKindOfClass:" */
    pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe7fd8);
    cVar2 = (*pcVar3)(uVar1,0xbe7fd8,uVar4);
    if (cVar2 != '\0') {
      uVar1 = *(undefined8 *)((long)this + 0x10); // super->match
                    /* "privacy" */
      pcVar3 = (code *)objc_msg_lookup(uVar1,0xbe7d88);
      lVar5 = (*pcVar3)(uVar1,0xbe7d88);
      if (lVar5 == 3) {
        return (NSString *).objc_str.327;
      }
      if (lVar5 == 2) {
        return (NSString *).objc_str.326;
      }
      return (NSString *).objc_str.322;
    }
  }
                    /* "private"
                       "searchable"
                       "public" */
  return (NSString *)0x0;
}

