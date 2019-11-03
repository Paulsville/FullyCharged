extends Area2D

class_name Battery

var taken = false

func on_battery_body_enter(body):
	if not taken and body is Player:
		taken = true
		body.update_energy(20)
		get_parent().remove_child(self)
