
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
  
                    /* "addItemToInventory:flash:disableWarpCheck:" */
  pcVar1 = (code *)objc_msg_lookup(this,0xbfc530);
  iVar2 = (*pcVar1)(this,0xbfc530,item,flash,0);
  return iVar2;
}

