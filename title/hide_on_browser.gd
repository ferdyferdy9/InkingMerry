extends Control

func _init() -> void:
	if OS.get_name() == "HTML5":
		hide()
