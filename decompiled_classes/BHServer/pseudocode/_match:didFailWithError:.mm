
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[BHServer match:didFailWithError:]
   DWARF original prototype: void -[BHServer_match:didFailWithError:](BHServer * self, SEL _cmd,
   BHMatch * match, NSError * error) */

void __thiscall
-[BHServer_match:didFailWithError:](void *this,SEL _cmd,BHMatch *match,NSError *error)

{
  code *pcVar1;
  NSError *error_local;
  BHMatch *match_local;
  SEL _cmd_local;
  BHServer *this_local;
  
  pcVar1 = (code *)objc_msg_lookup(this,0xbe7a28);
  (*pcVar1)(this,0xbe7a28);
  return;
}