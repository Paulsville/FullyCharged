tool
extends Node2D

const IS_TRACK = true

const SIZE = 64
const TILESIZE = 32

enum TYPES { horizontal, vertical, top_left, top_right, bottom_left, bottom_right }
var REGIONS = [
	Vector2(1, 0), 
	Vector2(0, 1),
	Vector2(0, 0),
	Vector2(2, 0),
	Vector2(0, 2),
	Vector2(2, 2)
]

var DIRECTIONS = [
	Vector2(1, 0),
	Vector2(0, 1),
	[Vector2(-1, 0), Vector2(0, -1), true],
	[Vector2(1, 0), Vector2(0, 1), false],
	[Vector2(1, 0), Vector2(0, 1), false],
	[Vector2(-1, 0), Vector2(0, -1), true],
]

export(TYPES) var type = TYPES.horizontal setget set_type
onready var Sprite = $Sprite
onready var Area = $Area2D
onready var CollisionShape = $Area2D/CollisionShape2D

func _ready():
	set_region(Sprite)

func set_type(value):
	type = value
	if Engine.editor_hint:
		print('changed track type')
		if has_node("Sprite"):
			set_region(get_node("Sprite"))
			
func set_region(sprite):
	sprite.region_rect.position = REGIONS[type] * TILESIZE
	
func get_direction(last_type):
	if typeof(DIRECTIONS[type]) == TYPE_ARRAY:
		return [DIRECTIONS[type][last_type], DIRECTIONS[type][2]]
	else:
		return [DIRECTIONS[type], false]
	

