
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[Blockhead actionCount]
   DWARF original prototype: int -[Blockhead_actionCount](Blockhead * self, SEL _cmd) */

int __thiscall -[Blockhead_actionCount](void *this,SEL _cmd)

{
  undefined8 uVar1;
  int iVar2;
  code *pcVar3;
  SEL _cmd_local;
  Blockhead *this_local;
  
                    /* 0x908 = actionQueue */
  uVar1 = *(undefined8 *)((long)this + 0x908);
                    /* "count" */
  pcVar3 = (code *)objc_msg_lookup(uVar1,0xbfcc90);
  iVar2 = (*pcVar3)(uVar1,0xbfcc90);
  return iVar2;
}

