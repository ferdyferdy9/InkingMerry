extends Node

enum {
	EASY,
	NORMAL,
}

const mouse_shape = preload("res://assets/graphic/cursorbrush.png")

var sus_level:int = 0
var difficulty:int = NORMAL
var is_dreaming:bool = false


func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_shape, Input.CURSOR_ARROW, Vector2(5, 3))


func change_scene(scene_path:String) -> void:
	Transition.fade_out_with_pause()
	yield(Transition, "fade_out_finished")
	get_tree().change_scene(scene_path)
