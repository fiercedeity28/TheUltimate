extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOP_STOP = 64
const TYPE = "Player"

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

onready var raycasts = $Raycasts
onready var anim_player = $Body/AnimationPlayer

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2*gravity * max_jump_height)
	min_jump_velocity = -sqrt(2*gravity * min_jump_height)
	

func _apply_movement():
	velocity = move_and_slide(velocity, UP)	
	
	is_grounded = _check_is_grounded()
func _apply_gravity(delta):
	velocity.y += gravity * delta
	
	#vine stuff
	if vine_on == true:
		print("hello")
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
	if move_direction != 0:
		 $Body.scale.x = move_direction
		 
	
func _get_h_weight():
	return 0.2 if is_grounded else  0.1

func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

#func _assign_animation():
#	var anim = "idle"
	
	#if !_check_is_grounded():
	#	anim = "jump"
	#elif velocity.x != 0:
	#	anim = "run"
	
		
	#if anim_player.assigned_animation != anim:
	#	anim_player.play(anim)		
