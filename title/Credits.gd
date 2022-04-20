extends Node


func _ready() -> void:
	$UI/Control/MarginContainer/VBoxContainer/btn_back.grab_focus()


func _on_btn_back_pressed() -> void:
	SfxPlayer.play("cancel")
	Globals.change_scene("res://title/Title.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") or \
		Input.is_action_just_pressed("ui_down") or \
		Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_right"):
			SfxPlayer.play("maribelpullswitch", [0.9, 1.2])
