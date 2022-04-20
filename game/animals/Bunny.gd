extends Node2D

signal spawn_illusion

export(float) var chance:float = 0.25

onready var sprite = $Sprite


func try_spawn_illusion() -> void:
	if randf() < chance and Globals.sus_level > 0:
		emit_signal("spawn_illusion")
		visible = false
		queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()


func play_audio(audio_name:String) -> void:
	if Globals.is_dreaming:
		SfxPlayer.play(audio_name, [1.2, 1.5])
