extends "../enemy.gd"

const STATE_WALKING = 2
const STATE_JUMPING = 3

const JUMP_SPEED = -800

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_JUMPING

func _physics_process(delta):
	if state == STATE_WALKING or state == STATE_JUMPING:
		linear_velocity += GRAVITY_VEC * delta
		linear_velocity.x = direction * WALK_SPEED
		linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)
	
	if state == STATE_JUMPING:
		if DetectFloorLeft.is_colliding() or DetectFloorRight.is_colliding():
			state = STATE_WALKING
			linear_velocity.y = 0

	elif state == STATE_WALKING:
		if not DetectFloorLeft.is_colliding():
			linear_velocity.y = JUMP_SPEED
			state = STATE_JUMPING
		elif not DetectFloorRight.is_colliding():
			linear_velocity.y = JUMP_SPEED
			state = STATE_JUMPING
		
		elif DetectWallLeft.is_colliding():
			direction = 1
		elif DetectFloorRight.is_colliding():
			direction = -1

	sprite.scale = Vector2(direction, 1.0)