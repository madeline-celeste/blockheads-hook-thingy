
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

  return [self->actionQueue count];
}

