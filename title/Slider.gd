extends TextureRect

signal value_changed(new_value)

const slider_normal = preload("res://assets/graphic/ui/slider_head.png")
const slider_selected = preload("res://assets/graphic/ui/slider_head_selected.png")

onready var parent = get_parent()

var range_x_min:float = 49
var range_x_max:float = 526


var is_pressed:bool

func _init() -> void:
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			is_pressed = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_pressed:
			var mouse_value = parent.get_local_mouse_position().x - 20
			var value = range_lerp(mouse_value, range_x_min, range_x_max, 0, 100)
			value = clamp(value, 0, 100)
			parent.value = value
	elif event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT:
			if is_pressed:
				SfxPlayer.play("confirm")
				is_pressed = false
				emit_signal("value_changed", parent.value)


func _process(delta: float) -> void:
	rect_position.x = range_lerp(parent.value, 0, 100, range_x_min, range_x_max)
	
	if has_focus():
		if Input.is_action_just_pressed("ui_right"):
			parent.value = clamp(parent.value + 10, 0, 100)
			SfxPlayer.play("confirm")
			emit_signal("value_changed", parent.value)
		elif Input.is_action_just_pressed("ui_left"):
			parent.value = clamp(parent.value - 10, 0, 100)
			SfxPlayer.play("confirm")
			emit_signal("value_changed", parent.value)


func _on_focus_entered() -> void:
	texture = slider_selected


func _on_focus_exited() -> void:
	texture = slider_normal
