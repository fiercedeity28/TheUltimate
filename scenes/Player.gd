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


onready var invulnerability_timer = $InvulnerabilityTimer
onready var healthbar = get_tree().get_root().get_node("GrassWorld/HUD/HealthBar")
onready var percentHP = get_tree().get_root().get_node("GrassWorld/HUD/HealthBar/PercentHP")
"""onready var bodySprite = $Body/Body
onready var armsSprite = $Body/Arms
onready var eyeSprite = $Body/Eyes
onready var pantsSprite = $Body/Pants
onready var shirtSprite = $Body/Shirt
onready var shoesSprite = $Body/Shoes
onready var hairSprite = $Body/Hair
"""

const composite_sprites = preload("res://scenes/Body.gd")

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
	"""bodySprite.texture = composite_sprites.body_spritesheet[0]
	armsSprite.texture = composite_sprites.arms_spritesheet[0]
	hairSprite.texture = composite_sprites.hair_spritesheet[0]
	eyeSprite.texture = composite_sprites.eyes_spritesheet[0]
	pantsSprite.texture = composite_sprites.pants_spritesheet[0]
	shirtSprite.texture = composite_sprites.shirt_spritesheet[0]
	shoesSprite.texture = composite_sprites.shoes_spritesheet[0]
	"""
func take_damage(count):
	if state == STATES.DEAD:
		return

	health -= count
	if health <= 0:
		health = 0
		state = STATES.DEAD
		emit_signal("died")
		kill()

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

func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)

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
			



var items_in_range = {}




