extends Node2D

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $TextureRect/GridContainer
var holding_item = null


func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#Currently holding an item
			if holding_item != null:
				#Empty Slot
				if !slot.item: # Place holding item to slot
					slot.putIntoSlot(holding_item)
					holding_item = null
				#Slot already contains an item
				else:
					#diff item, so swap
					if holding_item.item_name != slot.item.item_name:
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(holding_item)
						holding_item = temp_item
					#same item to try to merge	
					else: 
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_add)
							holding_item.decrease_item_quantity(able_to_add)	
			#Not holding an item
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()		

func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()							
