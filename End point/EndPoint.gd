extends RigidBody2D

class_name EndPoint

export(PackedScene) var next_scene

func change_level():
	get_tree().change_scene(next_scene)
	
func _on_Hitbox_area_entered(body):
	if body is Player:
		change_level()