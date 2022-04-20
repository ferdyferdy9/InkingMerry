extends CanvasLayer

onready var ink_progress_bar = $Control/InkProgressBar
onready var ink_storage_bar = $Control/InkStorageBar
onready var parent = get_parent()


func _process(delta: float) -> void:
	ink_storage_bar.value = parent.ink
	ink_progress_bar.value = parent.score
