extends Node

onready var title_music = $TitleMusic
onready var gameplay_music = $GameplayMusic
onready var anim_player = $AnimationPlayer


func play_title_music() -> void:
	gameplay_music.stop()
	if !title_music.playing:
		title_music.play()


func play_gameplay_music() -> void:
	title_music.stop()
	gameplay_music.play()


func stop() -> void:
	gameplay_music.stop()
	title_music.stop()
	gameplay_music.volume_db = 0
	gameplay_music.stream_paused = false


func pause_music() -> void:
	gameplay_music.volume_db = -80
	gameplay_music.stream_paused = true


func unpause_music() -> void:
	anim_player.play("fade_in")
	gameplay_music.volume_db = -80
	gameplay_music.stream_paused = false
