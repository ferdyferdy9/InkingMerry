extends CanvasLayer

onready var anim_player = $AnimationPlayer

func start_game_over():
	get_tree().paused = true
	anim_player.play("game_over")
	SfxPlayer.play("renkocaught")
	SfxPlayer.play("badend")
	MusicPlayer.stop()


func start_win_screen():
	get_tree().paused = true
	Globals.change_scene("res://endings/GoodEnd.tscn")


func _on_Button_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.change_scene("res://game/Game.tscn")


func _on_btn_title_pressed() -> void:
	SfxPlayer.play("confirm")
	Globals.change_scene("res://title/Title.tscn")
