extends KinematicBody2D

class_name Player

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 4000
const BOMB_VELOCITY_X = 250
const BOMB_VELOCITY_Y = 500
const SHOOT_TIME_SHOW_WEAPON = 0.2

var linear_vel = Vector2()
var shoot_time = 99999 # time since last shot

const ENERGY_MAX = 100
var ENERGY_CUR = 100
var dead = false
var invincible = false
const IS_ENEMY = false

signal energy_updated

var anim = ""

onready var sprite = $Sprite
onready var respawn_timer = $DeathTimer
onready var label = $Camera/DeathLabel
onready var stop_timer = $StopTimer

var Bullet = preload("res://bullet/Bullet.tscn")
var Bomb = preload("res://player/Bomb.tscn")

func _ready():
	label.visible = false
	respawn_timer.connect("timeout", self, "respawn")
	stop_timer.connect("timeout", self, "stop_player")

func _physics_process(delta):
	shoot_time += delta

	### MOVEMENT ###
	linear_vel += delta * GRAVITY_VEC
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	var on_floor = is_on_floor()

	### CONTROL ###
	var target_speed = 0
	if !dead:
		if Input.is_action_pressed("move_left"):
			target_speed -= 1
		if Input.is_action_pressed("move_right"):
			target_speed += 1
		target_speed *= WALK_SPEED
		linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)
		
		if Input.is_action_just_pressed("jump") and on_floor:
			global_position.y -= 5
			linear_vel.y =- JUMP_SPEED
			($SoundJump as AudioStreamPlayer2D).play()

		
		if Input.is_action_just_pressed("shoot"):
			var bullet = Bullet.instance()
			bullet.position = ($Sprite/BulletShoot as Position2D).global_position # use node for shoot position
			bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
			bullet.add_collision_exception_with(self) # don't want player to collide with bullet
			get_parent().add_child(bullet) # don't want bullet to move with me, so add it as child of parent
			($SoundShoot as AudioStreamPlayer2D).play()
			shoot_time = 0
			update_energy(-5)
		
		if Input.is_action_just_pressed("throw"):
			var bomb = Bomb.instance()
			bomb.position = ($Sprite/BulletShoot as Position2D).global_position
			bomb.linear_velocity = Vector2(sprite.scale.x * BOMB_VELOCITY_X, sprite.scale.y * BOMB_VELOCITY_Y * -1)
			get_parent().add_child(bomb)
			update_energy(-5)
	

	if ENERGY_CUR <= 0 and !dead:
		dead = true
		respawn_timer.start()
		stop_timer.start()
		var label_pos = label.get_position()
		label_pos.x = label_pos.x - 50
		label_pos.y = label_pos.y - 80
		label.set_position(label_pos)
		label.visible = true
	
		### ANIMATION ###
	
	var new_anim = "idle"
	
	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"
	
		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			sprite.scale.x = 1
	
		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"
	
	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_anim += "_weapon"
	
	if dead:
		new_anim = "crouch"
	
	if new_anim != anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)
		if dead:
			($Anim as AnimationPlayer).stop()
		
func on_water_entry():
	update_energy(0-ENERGY_CUR)

func on_hitbox_entered(body):
	if body.get_name() == "Hitbox" and body.get_parent().get("IS_ENEMY") != null:
		if !invincible and body.get_parent().IS_ENEMY:
			update_energy(-25)
			linear_vel = 300 * (global_position - body.get_parent().global_position)/(body.get_parent().global_position - global_position)
			invincible = true
			var timer = get_node("InvincibleTimer")
			timer.start()
		
func update_energy(value):
	if ENERGY_CUR < (ENERGY_MAX - value):
		ENERGY_CUR += value
	else:
		ENERGY_CUR = ENERGY_MAX
	emit_signal("energy_updated", value)

func on_invincible_timeout():
	invincible = false
	
func respawn():
	label.visible = false
	get_tree().reload_current_scene()
	
func stop_player():
	linear_vel.x = 0
