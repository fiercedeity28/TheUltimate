extends Node

signal active_item_updated

const SlotClass = preload("res://Slot.gd")
const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 8
const ItemClass = preload("res://Item.gd")
var inventory = {
	0: ["Iron Sword", 1],
	1: ["Iron Sword", 1],
	2: ["Potion", 98],
	3: ["Potion", 45],
}

var hotbar =  {
	0: ["Iron Sword", 1],
	1: ["Iron Sword", 1],
	2: ["Potion", 98],
	3: ["Potion", 45],
}
var equips =  {
	0: ["Iron Sword", 1],
	1: ["Brown Shirt", 1],
	2: ["Brown Boots", 1],
}
var active_item_slot = 0
func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item,inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
			
#			inventory[item][1] += item_quantity
#			return
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			inventory[i] = [item_name, item_quantity]
			return		
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:		
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]	
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func remove_item(slot:SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:		
			inventory.erase(slot.slot_index)	
		_:
			equips.erase(slot.slot_index)	
			
func add_item_quantity(slot:SlotClass, quantity_to_add: int):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:		
			inventory[slot.slot_index][1] += quantity_to_add	
		_:
			equips[slot.slot_index][1] += quantity_to_add
	
func update_slot_visual(slot_index, item_name, new_quantity):
	
	var slot = get_tree().root.get_node("/root/GrassWorld/HUD/Inventory/TextureRect/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)	
func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")
	
func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")	
