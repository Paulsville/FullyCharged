extends RigidBody2D

class_name Bullet

const IS_ENEMY = true

func _on_bullet_body_enter(body):
	if body.has_method("hit"):
		body.hit(1)
		get_parent().remove_child(self)

func _on_Timer_timeout():
	($Anim as AnimationPlayer).play("shutdown")
