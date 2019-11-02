extends KinematicBody2D

class_name Enemy


const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)

const STATE_IDLE = 0
const STATE_KILLED = 1
const WALK_SPEED = 70
const HEALTH_MAX = 10

var HEALTH_CUR = HEALTH_MAX

const IS_ENEMY = true

var linear_velocity = Vector2()
var anim = ""

enum DIRECTIONS { left, right }

export(DIRECTIONS) var starting_direction = DIRECTIONS.left 
var direction

# state machine
var state = STATE_IDLE

onready var DetectFloorLeft = $DetectFloorLeft
onready var DetectWallLeft = $DetectWallLeft
onready var DetectFloorRight = $DetectFloorRight
onready var DetectWallRight = $DetectWallRight
onready var sprite = $Sprite

func _ready():
	if starting_direction == 0:
		direction = -1
	else:
		direction = 1

func walk(delta):
	linear_velocity += GRAVITY_VEC * delta
	linear_velocity.x = direction * WALK_SPEED
	linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)
	
	if not DetectFloorLeft.is_colliding() and DetectFloorRight.is_colliding() or DetectWallLeft.is_colliding():
		direction = 1.0

	if not DetectFloorRight.is_colliding() and DetectFloorLeft.is_colliding() or DetectWallRight.is_colliding():
		direction = -1.0
		
	return direction

func hit(damage):
	HEALTH_CUR -= damage
	print(HEALTH_CUR)
	if HEALTH_CUR <= 0:
		state = STATE_KILLED
		get_parent().remove_child(self)
