extends Node2D

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $TextureRect/GridContainer
onready var equip_slots = $TextureRect/EquipSlots.get_children()


func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slotType = SlotClass.SlotType.SWORD
	equip_slots[1].slotType = SlotClass.SlotType.SHIRT
	equip_slots[2].slotType = SlotClass.SlotType.SHOES	
	initialize_inventory()
	initialize_equips()
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
func initialize_equips():

	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#Currently holding an item
			if find_parent("HUD").holding_item != null:
				#Empty Slot
				if !slot.item: # Place holding item to slot
					left_click_empty_slot(slot)
					
				#Slot already contains an item
				else:
					#diff item, so swap
					if find_parent("HUD").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					#same item to try to merge	
					else: 
						left_click_same_item(slot)	
			#Not holding an item
			elif slot.item:
				left_click_not_holding(slot)	

func _input(event):
	if find_parent("HUD").holding_item:
		find_parent("HUD").holding_item.global_position = get_global_mouse_position()							
func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("HUD").holding_item,slot)
		slot.putIntoSlot(find_parent("HUD").holding_item)
		find_parent("HUD").holding_item = null
func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("HUD").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("HUD").holding_item)
		find_parent("HUD").holding_item = temp_item
func left_click_same_item(slot: SlotClass):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("HUD").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot,find_parent("HUD").holding_item.item_quantity)
			slot.item.add_item_quantity(find_parent("HUD").holding_item.item_quantity)
			find_parent("HUD").holding_item.queue_free()
			find_parent("HUD").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			find_parent("HUD").holding_item.decrease_item_quantity(able_to_add)
func left_click_not_holding(slot:SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("HUD").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("HUD").holding_item.global_position = get_global_mouse_position()				
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("HUD").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == SlotClass.SlotType.SWORD:
		return holding_item_category == "Sword"
	elif slot.slotType == SlotClass.SlotType.SHIRT:
		return holding_item_category == "Shirt"
	elif slot.slotType == SlotClass.SlotType.SHOES:
		return holding_item_category == "Shoes"
	return true
