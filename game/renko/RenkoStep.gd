extends Node2D

onready var anim_player:AnimationPlayer = $AnimationPlayer

func play_walk_sfx() -> void:
	if is_visible_in_tree():
		SfxPlayer.play("renkowalk", [0.9, 1.2])
