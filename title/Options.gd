extends Node

onready var master_slider = $UI/Control/MasterProgress
onready var music_slider = $UI/Control/MusicProgress
onready var sfx_slider = $UI/Control/SFXProgress
onready var btn_full = $UI/Control/Button


func _ready() -> void:
	if OS.get_name() == "HTML5":
		btn_full.hide()
	
	master_slider.value = AudioManager.master_volume
	music_slider.value = AudioManager.music_volume
	sfx_slider.value = AudioManager.sound_volume
	
	$"UI/Control/MasterProgress/Slider".grab_focus()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") or \
		Input.is_action_just_pressed("ui_down") or \
		Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_right"):
			SfxPlayer.play("maribelpullswitch", [0.9, 1.2])


func _on_master_Slider_value_changed(new_value) -> void:
	AudioManager.master_volume = new_value
	AudioManager.save()


func _on_music_Slider_value_changed(new_value) -> void:
	AudioManager.music_volume = new_value
	AudioManager.save()


func _on_sfx_Slider_value_changed(new_value) -> void:
	AudioManager.sound_volume = new_value
	AudioManager.save()


func _on_Button_toggled(button_pressed: bool) -> void:
	SfxPlayer.play("confirm")
	btn_full.text = "Fullscreen : ON" if button_pressed else "Fullscreen : OFF"
	OS.window_fullscreen = button_pressed
	AudioManager.save()


func _on_Button2_pressed() -> void:
	SfxPlayer.play("cancel")
	Globals.change_scene("res://title/Title.tscn")
