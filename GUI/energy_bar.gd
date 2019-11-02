extends Node2D

onready var bar = $Bar
onready var tween = $Tween

var animated_health = 0
var current_health = 0

func _ready():
	var player_max_health = $"../../Player".ENERGY_MAX
	bar.max_value = player_max_health
	animated_health = player_max_health
	current_health = player_max_health

func _process(delta):
	var round_value = round(animated_health)
	bar.value = round_value

func _on_Player_energy_updated(value):
	current_health += value
	tween.interpolate_property(self, "animated_health", animated_health, current_health, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	if not tween.is_active():
    	tween.start()
