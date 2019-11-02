extends "../enemy.gd"

const STATE_WALKING = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_WALKING

func _physics_process(delta):
	var new_anim = "idle"

	if state == STATE_WALKING:
		direction = walk(delta)

		sprite.scale = Vector2(direction, 1.0)
		new_anim = "walk"
	else:
		new_anim = "explode"

	if anim != new_anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)
