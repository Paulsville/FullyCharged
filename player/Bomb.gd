extends RigidBody2D

class_name Bomb

func _on_Timer_timeout():
	explode()
		
func explode():
	for body in ($BombExplosionArea as Area2D).get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(5)
	get_parent().remove_child(self)
	
	