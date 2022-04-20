extends Control

onready var keyboard = $Keyboard
onready var controller = $Controller

func _process(delta: float) -> void:
	if ControllerDetector.is_controller:
		controller.show()
		keyboard.hide()
	else:
		controller.hide()
		keyboard.show()
