extends MarginContainer

onready var number_label = $Bars/LifeBar/Count/Background/Number
onready var bar = $Bars/LifeBar/TextureProgress
onready var tween = $Tween
onready var player = get_tree().get_root().get_node("GrassWorld/Player")
var animated_health = 0
export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (Color) var pulse_color = Color.darkred
export (Color) var flash_color = Color.orange
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2
export (bool) var will_pulse = false
onready var pulse_tween = $PulseTween
onready var flash_tween = $FlashTween
const FLASH_RATE = 0.05
const N_FLASHES = 4

func _ready():
	var player_max_health = player.max_health
	bar.max_value = player_max_health
	update_health(player_max_health)


func _on_Player_health_changed(player_health):
	update_health(player_health)
	if(player.health <= 100):
		bar.tint_progress = healthy_color
	if(player.health < 75):
		bar.tint_progress = caution_color
	if(player.health < 50):
		bar.tint_progress = flash_color
	if(player.health < 25):
		bar.tint_progress = danger_color
		for i in range(N_FLASHES * 2):
			var color = bar.tint_progress if i % 2 == 1 else flash_color
			var time = FLASH_RATE * i + FLASH_RATE
			pulse_tween.interpolate_callback(bar, time, "set", "tint_progress", color)	
			pulse_tween.start()
	
func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	if not tween.is_active():
		tween.start()
	

func _process(delta):
	var round_value = round(animated_health)
	number_label.text = str(round_value)
	bar.value = round_value


func _on_Player_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)

func _assign_color(player_health):
	if player_health < bar.max_value * danger_zone:
		#will_pulse = true
		if will_pulse:
			if !pulse_tween.is_active():
				pulse_tween.interpolate_property(bar, "tint_progress", pulse_color, danger_color, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				pulse_tween.interpolate_callback(self, 0.0, "emit_signal", "pulse")
				pulse_tween.start()
			else:	
				bar.tint_progress = danger_color
	
		else:
			#pulse_tween.set_active(false)
			if player_health < bar.max_value * caution_zone:
				bar.tint_progress = caution_color
			else:
				bar.tint_progress = healthy_color
