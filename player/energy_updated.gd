extends Node

signal energy_updated

func _ready():
	emit_signal("energy_updated")