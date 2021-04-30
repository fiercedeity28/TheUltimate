extends Node

const SlotClass = preload("res://Slot.gd")
const NUM_INVENTORY_SLOTS = 20
const ItemClass = preload("res://Item.gd")
var inventory = {
	0: ["Iron Sword", 1],
	1: ["Iron Sword", 1],
	2: ["Potion", 98],
	3: ["Potion", 45]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
			
#			inventory[item][1] += item_quantity
#			return
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return		
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func remove_item(slot:SlotClass):
	inventory.erase(slot.slot_index)
func add_item_quantity(slot:SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add
