extends Panel

var default_tex = preload("res://InventoryTileFull.png")
var empty_tex = preload("res://scenes/InventoryTile.png")
var selected_tex = preload("res://Sprites/ground.png")
var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Item.tscn")
var item = null
var slot_index
var slotType = null
enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	SWORD,
	SHIRT,
	SHOES,
}

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex

func refresh_style():
	if slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
	
	elif item == null:		
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)	

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("HUD")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventoryNode = find_parent("HUD")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()	
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

