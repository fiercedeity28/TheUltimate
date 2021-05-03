extends Area2D

onready var player = get_tree().get_root().get_node("GrassWorld/Player")

func _ready():
	pass # Replace with function body.



func _on_HealthItem_area_entered(area):
	player.gainHealth(20)
	queue_free()
