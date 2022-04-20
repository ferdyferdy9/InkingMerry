extends Node


var is_controller:bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_controller = true
	elif event is InputEventKey:
		is_controller = false
