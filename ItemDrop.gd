extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name

# Called when the node enters the scene tree for the first time.
func _ready():
	item_name = "Potion"
	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2(0,MAX_SPEED), ACCELERATION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)
