extends Area2D

class_name DeathZone

const TILE_SIZE = 64

export(int) var width = 0
export(int) var height= 0

func _ready():
	var collision = CollisionShape2D.new()
	add_child(collision)
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(TILE_SIZE * width / 2, TILE_SIZE * height / 2)
	collision.shape = shape
	connect("area_shape_entered", self, "_on_Detection_area_entered")

# This function takes 4 functions for some reason, the second one is needed
func _on_Detection_area_entered(a, body, c, d):
	if body.get_parent().has_method("on_water_entry"):
		body.get_parent().call("on_water_entry")	