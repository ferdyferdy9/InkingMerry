extends "res://game/illusions/Base.gd"



func play_tween():
	tween.interpolate_property(
		self, "global_position:x",
		global_position.x, maribel_head.global_position.x, duration,
		Tween.TRANS_LINEAR
	)
	tween.interpolate_property(
		self, "global_position:y",
		global_position.y, global_position.y - 75, duration * 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		self, "global_position:y",
		global_position.y - 75, maribel_head.global_position.y, duration * 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN, duration * 0.5
	)
	tween.start()
