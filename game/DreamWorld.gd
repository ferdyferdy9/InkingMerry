extends Node2D

signal spawn_bunny(pos)
signal spawn_sheep(pos)

const bunny_scene = preload("res://game/animals/Bunny.tscn")
const sheep_scene = preload("res://game/animals/sheep.tscn")

export(float) var bunny_min_time = 3
export(float) var bunny_max_time = 10
export(float) var sheep_min_time = 3
export(float) var sheep_max_time = 6

onready var bunny_timer = $BunnyTimer
onready var sheep_timer = $SheepTimer

onready var bunny_spawn_location = $BunnyPath/PathFollow2D
onready var sheep_spawn_location = $SheepPath/PathFollow2D


func _ready() -> void:
	randomize_bunny_timer()
	randomize_sheep_timer()


func randomize_bunny_timer() -> void:
	bunny_timer.start(rand_range(bunny_min_time, bunny_max_time))


func randomize_sheep_timer() -> void:
	sheep_timer.start(rand_range(sheep_min_time, sheep_max_time))


func _on_BunnyTimer_timeout() -> void:
	var bunny := bunny_scene.instance()
	bunny.connect("spawn_illusion", self, "_on_spawn_bunny_illusion", [bunny])
	bunny_spawn_location.unit_offset = randf()
	bunny.global_position = bunny_spawn_location.global_position
	bunny.z_index = bunny.position.y * 10 - 2000 
	add_child(bunny)
	randomize_bunny_timer()


func _on_SheepTimer_timeout() -> void:
	var sheep := sheep_scene.instance()
	sheep.connect("spawn_illusion", self, "_on_spawn_sheep_illusion", [sheep])
	sheep_spawn_location.unit_offset = randf()
	sheep.global_position = sheep_spawn_location.global_position
	add_child(sheep)
	randomize_sheep_timer()


func _on_spawn_bunny_illusion(bunny:Node2D) -> void:
	emit_signal("spawn_bunny", bunny.sprite.global_position)


func _on_spawn_sheep_illusion(sheep:Node2D) -> void:
	emit_signal("spawn_sheep", sheep.sprite.global_position)
