extends Node2D

onready var anim_player = $AnimationPlayer


func set_frame(frame:int) -> void:
	match(frame):
		0:
			anim_player.play("wait")
		1:
			anim_player.play("doodling")
