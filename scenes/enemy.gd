extends KinematicBody2D

var motion = Vector2()
var speed = 135
export(String) var type
export(bool) var dir
#onready var healthbar = get_tree().get_root().get_node("HealthBar")
const TYPE = "enemy"
onready var healthbar = get_tree().get_root().get_node("GrassWorld/HUD/HealthBar")
onready var player = get_tree().get_root().get_node("GrassWorld/Player")
#signal health_updated(health)
func _ready():
	if type == "ud":
		$U.enabled = true
		$D.enabled = true
		$L.enabled = false
		$R.enabled = false
	if type == "lr":
		$R.enabled = true
		$L.enabled = true
		$U.enabled = false
		$D.enabled = false

""" Enemy Movement
"""
func _physics_process(delta):
	if type == "ud":
		if dir == true:
			motion.y = -speed	
		if dir == false:
			motion.y = speed	
		if $U.is_colliding() == true && $U.get_collider().get("TYPE") == null && dir == true:
			dir = false
		if $D.is_colliding() == true && $D.get_collider().get("TYPE") == null && dir == false:
			dir = true
			
	if type == "lr":
		if dir == true:
			motion.x = speed	
		if dir == false:
			motion.x = -speed	
		if $R.is_colliding() == true && $R.get_collider().get("TYPE") == null && dir == true:
			dir = false
		if $L.is_colliding() == true && $L.get_collider().get("TYPE") == null && dir == false:
			dir = true
	motion = move_and_slide(motion)

""" Reload scene when you hit enemy
"""

#func _on_Area2D_body_entered(body):
		#emit_signal("health_updated",20)
	#healthbar._on_health_updated(5,5)


func _on_HitBox_area_entered(area):
	#player._on_Player_health_updated(20)
	#healthbar._on_health_updated(68)
	#player.damage(25)
	#player._set_health(player.health - 25)
	player.take_damage(15)
