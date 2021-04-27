extends Area2D

onready var player = get_tree().get_root().get_node("GrassWorld/Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HealthItem_area_entered(area):
	player.gainHealth(20)
	queue_free()
