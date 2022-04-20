extends Camera2D

export(float) var shake_strength:float = 10
export(float) var shake_decay:float = 20

var shake_dir:Vector2
var curr_strength:float

func _process(delta: float) -> void:
	if curr_strength > 0:
		shake_dir = -shake_dir.rotated(rand_range(-PI*0.5, PI*0.5))
		offset = curr_strength * shake_dir.normalized()
	else:
		offset = Vector2.ZERO
	
	curr_strength = max(0, curr_strength-shake_decay*delta)


func shake() -> void:
	curr_strength = shake_strength
	shake_dir = Vector2(randf(), randf())
