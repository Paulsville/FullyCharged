extends KinematicBody2D

class_name Enemy


const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)

const STATE_IDLE = 0
const STATE_KILLED = 1
const WALK_SPEED = 70 

var linear_velocity = Vector2()
var direction = -1
var anim = ""

# state machine
var state = STATE_IDLE

onready var DetectFloorLeft = $DetectFloorLeft
onready var DetectWallLeft = $DetectWallLeft
onready var DetectFloorRight = $DetectFloorRight
onready var DetectWallRight = $DetectWallRight
onready var sprite = $Sprite

func walk(delta):
	linear_velocity += GRAVITY_VEC * delta
	linear_velocity.x = direction * WALK_SPEED
	linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)

	if not DetectFloorLeft.is_colliding() or DetectWallLeft.is_colliding():
		direction = 1.0

	if not DetectFloorRight.is_colliding() or DetectWallRight.is_colliding():
		direction = -1.0
		
	return direction

func hit_by_bullet():
	state = STATE_KILLED
