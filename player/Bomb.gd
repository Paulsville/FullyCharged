extends RigidBody2D

class_name Bomb

func _on_Timer_timeout():
	explode()
		
func explode():
	for body in ($BombExplosionArea as Area2D).get_overlapping_bodies():
		if body.has_method("hit_by_bullet"):
			body.call("hit_by_bullet")
	get_parent().remove_child(self)
	
	