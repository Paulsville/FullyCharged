extends "../enemy.gd"

const STATE_WALKING = 2
const STATE_SHOOTING = 3

const SHOOT_DELAY = 0.5
const BULLET_VELOCITY = 3000
const RELOAD_TIME = 3

onready var DetectPlayerLeft = $DetectPlayerLeft
onready var DetectPlayerRight = $DetectPlayerRight
onready var Player = $"../../Player"

var Bullet = preload("res://bullet/Bullet.tscn")

var shoot_timer = 0
var reload_timer = RELOAD_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_WALKING

func _physics_process(delta):
	if state == STATE_WALKING:
		direction = walk(delta)
		sprite.scale = Vector2(direction, 1.0)
		if reload_timer <= 0:
			if direction > 0 and Player in DetectPlayerRight.get_overlapping_bodies():
				shoot()
			elif direction < 0 and Player in DetectPlayerLeft.get_overlapping_bodies():
				shoot()
	elif state == STATE_SHOOTING:
		if shoot_timer < 0:
			var bullet = Bullet.instance()
			bullet.position = ($Sprite/BulletShoot as Position2D).global_position # use node for shoot position
			bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0)
			bullet.add_collision_exception_with(self) # don't want player to collide with bullet
			get_parent().add_child(bullet) # don't want bullet to move with me, so add it as child of parent
			# sound?
			shoot_timer = 0
			state = STATE_WALKING
			reload_timer = RELOAD_TIME
		else:
			shoot_timer -= delta
			
	if reload_timer > 0:
		reload_timer -= delta
			
func shoot():
	shoot_timer = SHOOT_DELAY
	state = STATE_SHOOTING
