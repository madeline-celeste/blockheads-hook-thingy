
/* WARNING: Variable defined which should be unmapped: this_local */
/* WARNING: Struct "NPC": ignoring overlapping field "damage" */
/* DWARF original name: -[Blockhead addExpectedCraftItem:]
   DWARF original prototype: void -[Blockhead_addExpectedCraftItem:](Blockhead * self, SEL _cmd,
   ItemType itemType) */

void __thiscall -[Blockhead_addExpectedCraftItem:](void *this,SEL _cmd,ItemType itemType)

{
  value_type.conflict1 local_1e;
  ItemType local_1c;
  SEL poStack_18;
  ItemType itemType_local;
  SEL _cmd_local;
  Blockhead *this_local;
  
                    /* 0x978 = expectedCraftItems
                       
                       type={vector<unsigned short, std::allocator<unsigned short>
                       >={_Vector_impl=^S^S^S}} */
  //local_1e = (value_type.conflict1)itemType;
  //local_1c = itemType;
  //poStack_18 = _cmd;
  //_cmd_local = (SEL)this;
  //std::vector<>::push_back((vector<> *)((long)this + 0x978),&local_1e);

  self->expectedCraftItems.push_back(&ItemType); // i dont feel good abt this tbh

  return;
}

