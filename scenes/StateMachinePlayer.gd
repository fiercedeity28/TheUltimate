extends StateMachine
onready var anim_player = $Body/AnimationPlayer
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	call_deferred("set_state", states.idle)
	

func _input(event):
	
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump") && parent.is_grounded:
			
			parent.velocity.y = parent.max_jump_velocity
	if state == states.jump:
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity	
	if state == states.attack:
		if event.is_action_pressed("punch"):
			anim_player.play("PunchAttack")
func _state_logic(delta):
	
	parent._handle_move_input()
	parent._apply_movement()
	parent._apply_gravity(delta)
	
func _get_transition(delta):
	match state:
		states.idle:
		
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				
				return states.run
			elif (parent.velocity.x == 0) && (parent.velocity.y == 0):
				parent.anim_player.play("idle")	
		states.run:
			
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				parent.anim_player.play("run")
				return states.run
			elif (parent.velocity.x == 0) && (parent.velocity.y == 0):
				parent.anim_player.play("idle")	
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall	
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump	
		states.attack:

			return states.attack							
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			parent.anim_player.play("run")
		states.jump:
			parent.anim_player.play("jump")
		states.fall:
			parent.anim_player.play("fall")
		states.attack:
			parent.anim_player.play("PunchAttack")
func _exit_state(old_state,new_state):
	pass
