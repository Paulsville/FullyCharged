extends RigidBody2D

class_name Bullet

const IS_ENEMY = true

func _on_bullet_body_enter(body):
	if body.get("IS_ENEMY") != null:
		if body.IS_ENEMY:
			body.hit(1)
		else:
			body.update_energy(-25)
	get_parent().remove_child(self)

func _on_Timer_timeout():
	($Anim as AnimationPlayer).play("shutdown")
