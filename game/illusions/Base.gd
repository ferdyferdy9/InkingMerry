extends Node2D

signal touched_maribel

const poof_scene = preload("res://game/effect/Poof.tscn")

export(float) var duration:float = 1

onready var tween:Tween = $Tween

var maribel_head:Position2D

func _ready() -> void:
	var arr = get_tree().get_nodes_in_group("MaribelHead")
	if arr.empty():
		return
	maribel_head = arr[0]
	
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	play_tween()
	SfxPlayer.play("animaljumpoutofdream", [0.9, 1.2])


func play_tween():
	pass


func _on_tween_all_completed() -> void:
	emit_signal("touched_maribel")
	poof()


func poof() -> void:
	var poof := poof_scene.instance()
	poof.global_position = global_position
	get_parent().add_child(poof)
	queue_free()
