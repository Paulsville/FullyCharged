extends RigidBody2D

class_name Bomb

func _on_Timer_timeout():
	($Anim as AnimationPlayer).play("explode")