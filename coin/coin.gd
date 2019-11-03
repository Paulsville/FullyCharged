extends Area2D

class_name Coin


var taken = false

func on_coin_body_enter(body):
	if not taken and body is Player:
		($Anim as AnimationPlayer).play("taken")
		taken = true
		body.update_energy(20)
