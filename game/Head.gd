extends TextureRect

onready var anim_player = $AnimationPlayer
onready var parent = get_parent()

func _process(delta: float) -> void:
	rect_position.x = range_lerp(parent.value, 0, parent.max_value, 0, 366)
	
	match(Globals.sus_level):
		-1, 0:
			anim_player.play("sus_0")
		1:
			anim_player.play("sus_1")
		2:
			anim_player.play("sus_2")
		_:
			anim_player.play("sus_3")
