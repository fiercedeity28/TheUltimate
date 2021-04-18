extends KinematicBody2D

signal health_updated(health)

signal killed()

const UP = Vector2(0, -1)
const SLOP_STOP = 64
const TYPE = "Player"
###############
signal health_changed
signal died

export var max_health = 100
var health = max_health



#export (float) var max_health = 100.0
#signal max_health_updated(max_health)
#var health = max_health setget _set_health
#var health = 100
onready var invulnerability_timer = $InvulnerabilityTimer
onready var healthbar = get_tree().get_root().get_node("GrassWorld/HUD/HealthBar")
onready var percentHP = get_tree().get_root().get_node("GrassWorld/HUD/HealthBar/PercentHP")


var move_speed = 5 * Globals.UNIT_SIZE
var velocity = Vector2()
var gravity
var max_jump_velocity
var min_jump_velocity
var is_grounded
var is_jumping = false
var is_wall_sliding = false
var is_dodging = false
var is_dead = false
var is_moonwalking = true
var vine_on = false

var max_jump_height = 1.8 * Globals.UNIT_SIZE
var min_jump_height = 0.1 * Globals.UNIT_SIZE
var jump_duration = 0.5
var amount = 20

signal damaged(by)


const HP_MAX = 100.0
var hp = 100

onready var raycasts = $Raycasts
onready var anim_player = $Body/AnimationPlayer

# When the character dies, we fade the UI
enum STATES {ALIVE, DEAD}
var state = STATES.ALIVE

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2*gravity * max_jump_height)
	min_jump_velocity = -sqrt(2*gravity * min_jump_height)
	
func take_damage(count):
	if state == STATES.DEAD:
		return

	health -= count
	if health <= 0:
		health = 0
		state = STATES.DEAD
		emit_signal("died")
		kill()

	#$AnimationPlayer.play("take_hit")

	emit_signal("health_changed", health)
	
func _apply_movement():
	velocity = move_and_slide(velocity, UP)	
	is_grounded = _check_is_grounded()
	
func _apply_gravity(delta):
	velocity.y += gravity * delta
	
	#vine stuff
	if vine_on == true:
		
		gravity = 0
		if Input.is_action_pressed("jump"):
			velocity.y = -move_speed
		elif Input.is_action_pressed("S"):
			velocity.y = move_speed
		else:
			velocity.y = 0
	else:
		gravity = 2 * max_jump_height / pow(jump_duration, 2)

		
func _handle_move_input():
	if(Input.is_action_pressed("move_left")):
		#health -= amount
		#_set_health(amount)
		#damage(10)
#=		percentHP.text = "health"
		
		pass
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	#Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if move_direction != 0:
		 $Body.scale.x = move_direction
		 
	
func _get_h_weight():
	return 0.2 if is_grounded else  0.1

func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func damage(amount):
	#if invulnerability_timer.is_stopped():
		#invulnerability_timer.start()
	_set_health(health - amount)

func gainHealth(amount):
	if state == STATES.DEAD:
		return

	if health < max_health:
		health += amount
		if health > max_health:
			health = max_health
	else:
		return	

	#$AnimationPlayer.play("take_hit")

	emit_signal("health_changed", health)
	
func kill():
	get_tree().reload_current_scene()


	
func _set_health(value):
	var prev_health =health
	health = clamp(value, 0.0, max_health)
	
	percentHP.text = str(health)
	#if health != prev_health:
	emit_signal("health_updated", health)
	emit_signal("max_health_updated", max_health)
	
		
	if health == 0:
		kill()
		emit_signal("killed")
			

#func _assign_animation():
#	var anim = "idle"
	
	#if !_check_is_grounded():
	#	anim = "jump"
	#elif velocity.x != 0:
	#	anim = "run"
	
		
	#if anim_player.assigned_animation != anim:
	#	anim_player.play(anim)		



#func _on_Area2D_body_entered(body):
	#if body.get("TYPE") == "enemy":
		#get_tree().reload_current_scene()
		
		




#func _on_HurtBox_area_entered(area):
		#take_damage(20)
	#_set_health(20)
	#damage(15)
	#damage(10)
		#get_tree().reload_current_scene()



func _on_Player_max_health_updated(max_health):
	pass # Replace with function body.


