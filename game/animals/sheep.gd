extends Node2D

signal spawn_illusion

export(float) var chance:float = 0.125

onready var sprite = $sheep


func try_spawn_illusion() -> void:
	if Globals.sus_level > 1:
		var _chance = chance * 2 if Globals.sus_level > 2 else chance
		if randf() < _chance: 
			emit_signal("spawn_illusion")
			visible = false
			queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
