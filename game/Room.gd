extends Control

enum {
	LIGHT,
	DARK_GLOW,
	DARK,
}

onready var anim_player = $AnimationPlayer

func set_light(idx:int) -> void:
	match(idx):
		LIGHT:
			anim_player.play("light")
			anim_player.advance(0)
		DARK_GLOW:
			anim_player.play("dark-glow")
			anim_player.advance(0)
		DARK:
			anim_player.play("dark")
			anim_player.advance(0)


func is_light_on() -> bool:
	return anim_player.assigned_animation == "light"
