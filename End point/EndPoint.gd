extends RigidBody2D

class_name EndPoint

export(PackedScene) var next_scene
onready var coll_rect = $CollisionShape2D

func change_level():
	get_tree().change_scene(next_scene)

func _on_RigidBody2D_body_entered(body):
	change_level()
