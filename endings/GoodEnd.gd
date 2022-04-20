extends Node


func _ready() -> void:
	get_tree().paused = false
	MusicPlayer.stop()
	SfxPlayer.play("goodend")



func _on_Button_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.change_scene("res://title/Title.tscn")
