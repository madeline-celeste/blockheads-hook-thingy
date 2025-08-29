
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[Blockhead addItemToInventory:flash:disableWarpCheck:]
   DWARF original prototype: int -[Blockhead_addItemToInventory:flash:disableWarpCheck:](Blockhead *
   self, SEL _cmd, InventoryItem * item, BOOL flash, BOOL disableWarpCheck) */

int __thiscall
-[Blockhead_addItemToInventory:flash:disableWarpCheck:]
          (void *this,SEL _cmd,InventoryItem *item,BOOL flash,BOOL disableWarpCheck)

{
  code *pcVar1;
  int iVar2;
  BOOL disableWarpCheck_local;
  BOOL flash_local;
  InventoryItem *item_local;
  SEL _cmd_local;
  Blockhead *this_local;
  
                    /* "addItemToInventory:flash:disableWarpCheck:forceSlotIndex:" */
  pcVar1 = (code *)objc_msg_lookup(this,0xbfc470);
  iVar2 = (*pcVar1)(this,0xbfc470,item,flash,disableWarpCheck,0xffffffff);
  return iVar2;

  return [self addItemToInventory:item:
    flash:flash:
    disableWarpCheck:
    disableWarpCheck:
    forceSlotIndex:0xffffffff
  ];
}

