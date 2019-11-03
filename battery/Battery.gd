extends Area2D

class_name Battery

var taken = false

func on_battery_body_enter(body):
	if !taken and body.get_parent() is Player:
		print("battery entered")
		taken = true
		body.get_parent().update_energy(25)
		get_parent().remove_child(self)
