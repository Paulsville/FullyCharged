extends Node

class_name Water

func _on_Detection_area_entered(body):
	if body.has_method("on_water_entry"):
		body.call("on_water_entry")	