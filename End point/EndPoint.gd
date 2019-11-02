extends Node2D

class_name EndPoint

export(String) var next_scene

func _ready():
	$Hitbox.connect("area_entered", self, "_on_Hitbox_area_entered")

func change_level():
	get_tree().change_scene("res://" + next_scene + ".tscn")

func _on_Hitbox_area_entered(body):
	if body.get_parent() is Player:
		change_level()
