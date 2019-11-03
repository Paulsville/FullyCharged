extends Enemy

const STATE_TRACK = 2

var last_pos = position
var next_pos = position

var last_track = null

var path = [Vector2(1, 0)]

export(float) var speed = 1 setget set_speed

onready var DetectTrack = $DetectTrack
onready var TrackCollision = $DetectTrack/CollisionShape2D
onready var Tween = $Tween

func _ready():
	HEALTH_CUR = 1
	$Anim.play('spin')

func _physics_process(delta):
	if state == STATE_IDLE:
		var areas = DetectTrack.get_overlapping_areas()
		var found_track = false
		var track
		for area in areas:
			track = area.get_owner()
			if track.get('IS_TRACK') != null and track != last_track:
				found_track = true
				move(track)

		if not found_track and last_track:
			if not inside(TrackCollision, last_track.CollisionShape):
				direction *= -1
			move(last_track)
			
	elif state == STATE_KILLED:
		Tween.stop_all()

func move(track):
	var last_type
	if path[-1].x == 0:
		last_type = 0
	else:
		last_type = 1
	
	state = STATE_TRACK
	var dirs = track.get_direction(last_type)
	var dir = dirs[0] * track.SIZE * direction
	var switch_dir = dirs[1]
	Tween.interpolate_property(self, 'position', position, position + dir, 1 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not Tween.is_active():
		Tween.start()
	last_track = track
	path = path + [dir]
	
	if switch_dir:
		direction *= -1

func inside(area1, area2):
	return (area1.global_position.x >= area2.global_position.x and area1.global_position.y >= area2.global_position.y
	and area1.shape.extents.x + area1.global_position.x <= area2.shape.extents.x + area2.global_position.x
	and area1.shape.extents.y + area1.global_position.y <= area2.shape.extents.y + area2.global_position.y)
	
func _on_tween_completed(object, key):
	if state == STATE_TRACK:
		state = STATE_IDLE
		
func set_speed(value):
	if value == 0:
		speed = 1
	else:
		speed = value
