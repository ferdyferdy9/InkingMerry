extends TextureRect

onready var parent = get_parent()


func _process(delta: float) -> void:
	rect_size.x = range_lerp(parent.value, 0, parent.max_value, 5, 340)
