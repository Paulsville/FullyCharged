extends RigidBody2D

class_name Bomb

func _on_Timer_timeout():
	explode()

func _on_bomb_hit_body(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		explode()
		
func explode():
	for body in $BombExplosionArea.get_overlapping_bodies():
		if body.has_method("hit_by_bullet"):
			body.call("hit_by_bullet")
	get_parent().remove_child(self)