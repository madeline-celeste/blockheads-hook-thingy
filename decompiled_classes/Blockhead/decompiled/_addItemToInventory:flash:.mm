
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[Blockhead addItemToInventory:flash:]
   DWARF original prototype: int -[Blockhead_addItemToInventory:flash:](Blockhead * self, SEL _cmd,
   InventoryItem * item, BOOL flash) */

int __thiscall
-[Blockhead_addItemToInventory:flash:](void *this,SEL _cmd,InventoryItem *item,BOOL flash)

{
  code *pcVar1;
  int iVar2;
  BOOL flash_local;
  InventoryItem *item_local;
  SEL _cmd_local;
  Blockhead *this_local;

  return [self addItemToInventory:item:flash:NO];
}

