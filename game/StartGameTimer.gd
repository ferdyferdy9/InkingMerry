extends Timer

signal game_start


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("walk"):
		emit_signal("game_start")


func _on_StartGameTimer_timeout() -> void:
	emit_signal("game_start")
