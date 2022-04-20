extends Node2D

enum {
	LIGHT,
	DARK_GLOW,
	DARK,
}

func set_light(idx:int) -> void:
	match(idx):
		LIGHT:
			modulate = Color.white
		DARK_GLOW:
			modulate = Color("737eb9").lightened(0.1)
		DARK:
			modulate = Color("0f1725").lightened(0.1)
