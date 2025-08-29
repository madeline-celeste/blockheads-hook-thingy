
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[Blockhead addItemToInventory:]
   DWARF original prototype: int -[Blockhead_addItemToInventory:](Blockhead * self, SEL _cmd,
   InventoryItem * item) */

int __thiscall -[Blockhead_addItemToInventory:](void *this,SEL _cmd,InventoryItem *item)

{
  int iVar1;
  code *pcVar2;
  InventoryItem *item_local;
  SEL _cmd_local;
  Blockhead *this_local;
  
                    /* "addItemToInventory:flash:" */
  pcVar2 = (code *)objc_msg_lookup(this,0xbfcfa0);
  iVar1 = (*pcVar2)(this,0xbfcfa0,item,0);
  return iVar1;
}

