extends Node

onready var main_panel = $UI/Control/Title/VBoxContainer2/MainContent
onready var difficulty_panel = $UI/Control/Title/VBoxContainer2/Difficulty
onready var play_button = $UI/Control/Title/VBoxContainer2/MainContent/btn_play
onready var normal_button = $UI/Control/Title/VBoxContainer2/Difficulty/btn_normal


func _ready() -> void:
	get_tree().paused = false
	MusicPlayer.play_title_music()
	Transition.fade_in()
	play_button.grab_focus()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") or \
		Input.is_action_just_pressed("ui_down") or \
		Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_right"):
			SfxPlayer.play("maribelpullswitch", [0.9, 1.2])


func _on_btn_play_pressed() -> void:
	SfxPlayer.play("confirm")
	main_panel.hide()
	difficulty_panel.show()
	normal_button.grab_focus()


func _on_btn_options_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.change_scene("res://title/Options.tscn")


func _on_btn_credits_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.change_scene("res://title/Credits.tscn")


func _on_btn_exit_pressed() -> void:
	SfxPlayer.play("cancel")
	get_tree().paused = true
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()


func _on_btn_easy_focus_entered() -> void:
	$UI/Control/lbl_msg.show()


func _on_btn_easy_mouse_entered() -> void:
	$UI/Control/lbl_msg.show()


func _on_btn_easy_focus_exited() -> void:
	$UI/Control/lbl_msg.hide()


func _on_btn_easy_mouse_exited() -> void:
	$UI/Control/lbl_msg.hide()


func _on_btn_back_pressed() -> void:
	SfxPlayer.play("confirm")
	main_panel.show()
	difficulty_panel.hide()
	play_button.grab_focus()


func _on_btn_normal_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.difficulty = Globals.NORMAL
	Globals.change_scene("res://game/Game.tscn")


func _on_btn_easy_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.difficulty = Globals.EASY
	Globals.change_scene("res://game/Game.tscn")
