extends Node2D

signal on_doodle

onready var anim_player = $AnimationPlayer

var total_time:float = 0

func _ready() -> void:
	anim_player.play("idle")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("brush_up"):
		anim_player.play("up")
	elif Input.is_action_just_pressed("brush_right"):
		anim_player.play("right")
	elif Input.is_action_just_pressed("brush_left"):
		anim_player.play("left")
	elif Input.is_action_just_pressed("brush_down"):
		anim_player.play("down")
	
	total_time += delta
	if total_time > 1.0/30.0:
		anim_player.advance(total_time)
		total_time = 0


func doodled() -> void:
	emit_signal("on_doodle")
	play_brush_stroke()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_player.play("idle")


func play_brush_stroke() -> void:
	if is_visible_in_tree():
		SfxPlayer.play("renkodraw", [0.9, 1.2])
