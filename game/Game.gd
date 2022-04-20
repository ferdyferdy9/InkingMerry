extends Node

signal walk_complete
signal ink_empty
signal ink_refilled

const sheep_scene = preload("res://game/illusions/Sheep.tscn")
const bunny_scene = preload("res://game/illusions/Bunny.tscn")

export(float) var anim_length = 1.3333
export(float) var score_goal = 300
export(float) var decay_rate = 1.3333
export(float) var max_ink = 100
export(float) var min_dream_time = 5
export(float) var max_dream_time = 20

onready var anim_player = $RealWorld/AnimationPlayer
onready var dream = $Dream
onready var real_world = $RealWorld
onready var room = $Background/Room
onready var renko_step = $RealWorld/RenkoStep
onready var renko_doodle = $RealWorld/RenkoDoodle
onready var renko_doodling = $RealWorld/RenkoDoodle/Doodling
onready var renko_bed = $RealWorld/RenkoBed
onready var maribel = $RealWorld/MaribelBed
onready var dream_timer = $DreamTimer
onready var fakeout_timer = $FakeoutTimer
onready var obj_ink = $RealWorld/Ink
onready var ink_timer = $InkTimer

var _is_maribel_sleeping:bool = true
var score:float = 0
var ink:float = 100
var first_dream:bool = true
var _rem_t:float = 0
var _rem_anim:String = ""
var _just_refill:bool
var _last_refill:bool
var has_win:bool = false
var has_lost:bool = false

func _ready() -> void:
	if Globals.difficulty == Globals.EASY:
		score_goal *= 0.6
		decay_rate *= 0.25
		max_ink *= 0.6
	
	MusicPlayer.stop()
	SfxPlayer.play("gamestart")
	
	$UI/Control/InkStorageBar.max_value = max_ink
	$UI/Control/InkProgressBar.max_value = score_goal
	randomize()
	anim_player.play("doodle_off")
	anim_player.seek(anim_length, true)
	room.set_light(room.DARK_GLOW)
	real_world.set_light(room.DARK_GLOW)
	randomize_dream_timer()
	get_tree().paused = true
	yield($StartGameTimer, "game_start")
	MusicPlayer.play_gameplay_music()
	get_tree().paused = false
	if Input.is_action_just_pressed("walk"):
		anim_player.play("doodle_on")
		anim_player.seek(0, true)
	
	$UI/Control/StartupAnimaton.play("approach")
	yield(self, "walk_complete")
	$UI/Control/StartupAnimaton.play("paint")
	yield(self, "ink_empty")
	$UI/Control/StartupAnimaton.play("refill")
	yield(self, "ink_refilled")
	yield(get_tree().create_timer(1), "timeout")
	$UI/Control/StartupAnimaton.play("goal")
	yield(get_tree().create_timer(5), "timeout")
	$UI/Control/StartupAnimaton.play("hide")


func _process(delta: float) -> void:
	Globals.is_dreaming = _is_maribel_sleeping
	
	if Input.is_action_just_pressed("walk") and anim_player.assigned_animation == "doodle_off":
		var t:float = anim_player.current_animation_position
		var new_t:float = max(anim_length-t, 0)
		anim_player.play("doodle_on")
		anim_player.seek(new_t, true)
		anim_player.playback_speed = 1.0
		renko_step.anim_player.play("loop")
	
	if Input.is_action_just_released("walk") and anim_player.assigned_animation == "doodle_on":
		var t:float = anim_player.current_animation_position
		var new_t:float = max(anim_length-t, 0)
		anim_player.play("doodle_off")
		anim_player.seek(new_t, true)
		anim_player.playback_speed = 1.25
		renko_step.anim_player.play("loop")
	
	if room.is_light_on():
		if !renko_bed.is_asleep:
			if !has_lost and !has_win:
				$GameOver.start_game_over()
				has_lost = true
	
	if _is_maribel_sleeping:
		score = max(0, (score - delta*decay_rate))
	else:
		score = max(0, (score - delta*decay_rate*0.125))
	
	if score < score_goal*0.0625:
		Globals.sus_level = -1
	elif score < score_goal*0.25:
		Globals.sus_level = 0
	elif score < score_goal*0.5:
		Globals.sus_level = 1
	elif score < score_goal*0.75:
		Globals.sus_level = 2
	else:
		Globals.sus_level = 3
	
	if score > score_goal:
		get_tree().paused = true
		if !has_win:
			$GameOver.start_win_screen()
			has_win = true
	
	_just_refill = Input.is_action_pressed("refill") and \
		obj_ink.global_position.distance_to(renko_step.global_position) < 50
	if _just_refill:
		refill(delta)
		if _last_refill != _just_refill and _just_refill:
			_rem_t = anim_player.current_animation_position
			_rem_anim = anim_player.assigned_animation
			SfxPlayer.play("inkrefill")
			ink_timer.start()
		anim_player.play("wait")
		renko_step.anim_player.stop()
	elif _last_refill != _just_refill and !_just_refill:
		_just_refill = false
		if Input.is_action_pressed("walk"):
			anim_player.play("doodle_on")
			anim_player.seek(_rem_t if _rem_anim == "doodle_on" else (anim_length-_rem_t))
			renko_step.anim_player.play("loop")
		else:
			anim_player.play("doodle_off")
			anim_player.seek(_rem_t if _rem_anim == "doodle_off" else (anim_length-_rem_t))
			renko_step.anim_player.play("loop")
	
	if ink == 0:
		emit_signal("ink_empty")
	elif ink > 20:
		emit_signal("ink_refilled")
	
	_last_refill = _just_refill


func _on_MaribelBed_light_turned_off() -> void:
	SfxPlayer.play("maribelpullswitch")
	if randf() < 0.2:
		room.set_light(room.DARK)
		real_world.set_light(room.DARK)
	else:
		room.set_light(room.DARK_GLOW)
		real_world.set_light(room.DARK_GLOW)


func _on_MaribelBed_light_turned_on() -> void:
	SfxPlayer.play("maribelpullswitch")
	room.set_light(room.LIGHT)
	real_world.set_light(room.LIGHT)


func _on_MaribelBed_animation_changed(old_anim:String, new_anim:String) -> void:
	if new_anim == "sleeping":
		renko_doodle.set_frame(1)
		dream.anim_player.play("fade_in")
		randomize_dream_timer()
		_is_maribel_sleeping = true
		MusicPlayer.unpause_music()
	else:
		renko_doodle.set_frame(0)
		dream.anim_player.play("fade_out")
		_is_maribel_sleeping = false
		MusicPlayer.pause_music()


func randomize_dream_timer() -> void:
	if is_fake_out():
		dream_timer.start(rand_range(0.8, 1.2))
		if !dream_timer.is_connected("timeout", self, "_on_fake_out"):
			dream_timer.connect("timeout", self, "_on_fake_out", [], CONNECT_ONESHOT)
	else:
		match(Globals.sus_level):
			-1:
				dream_timer.start(rand_range(min_dream_time*3, max_dream_time*1.5))
			0:
				dream_timer.start(rand_range(min_dream_time*2, max_dream_time*1.25))
			1:
				dream_timer.start(rand_range(min_dream_time*1.75, max_dream_time))
			2:
				dream_timer.start(rand_range(min_dream_time*1.5, max_dream_time))
			3:
				dream_timer.start(rand_range(min_dream_time, max_dream_time*0.75))


func wake_up() -> void:
	dream_timer.stop()


func force_wake_up() -> void:
	maribel.isSleeping = false
	wake_up()	
	_on_fake_out()


func is_fake_out() -> bool:
	return not first_dream and Globals.sus_level > 1 and randi() % 4 == 0


func _on_Timer_timeout() -> void:
	if Globals.sus_level == -1:
		randomize_dream_timer()
		return
	elif Globals.sus_level == 0:
		maribel.wake_up()
		maribel.isSleeping = false
	else:
		maribel.turn_on_lights_slowly()
		maribel.isSleeping = false
	var illusions:Array = get_tree().get_nodes_in_group("Illusion")
	for i in illusions:
		i.poof()
	var animals:Array = get_tree().get_nodes_in_group("animal")
	for a in animals:
		if randi() % 2 == 0:
			a.queue_free()


func _on_fake_out() -> void:
	var illusions:Array = get_tree().get_nodes_in_group("Illusion")
	for i in illusions:
		i.poof()
	maribel.turn_on_lights()
	fakeout_timer.start()
	yield(fakeout_timer, "timeout")
	maribel.timer.paused = false
	maribel.timer.start()


func _on_DreamWorld_spawn_sheep(pos) -> void:
	if _is_maribel_sleeping:
		var sheep = sheep_scene.instance()
		sheep.global_position = pos - Vector2(-300*0.5, 100*0.5)
		sheep.connect("touched_maribel", self, "_on_maribel_touched_by_illusion")
		add_child(sheep)


func _on_DreamWorld_spawn_bunny(pos) -> void:
	if _is_maribel_sleeping:
		var bunny = bunny_scene.instance()
		bunny.global_position = pos - Vector2(-300*0.5, 100*0.5)
		bunny.connect("touched_maribel", self, "_on_maribel_touched_by_illusion")
		add_child(bunny)


func _on_maribel_touched_by_illusion() -> void:
	force_wake_up()
	if randf() < 0.2:
		SfxPlayer.play("alternate_animal_hit_maribel_sfx")
	else:
		SfxPlayer.play("animal_land_on_maribel")
	SfxPlayer.play("splode_original_creation", [0.9, 1.2])
	$Camera2D.shake()


func _on_Doodling_on_doodle() -> void:
	if ink > 0 and renko_doodling.is_visible_in_tree():
		ink -= 5
		score += 1


func refill(delta) -> void:
	ink += max_ink * delta
	ink = min(ink, max_ink)


func _on_FirstTimer_timeout() -> void:
	first_dream = false


func _on_InkTimer_timeout() -> void:
	SfxPlayer.play("inkrefill", [0.9, 1.1])
	if _just_refill:
		ink_timer.start()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "doodle_on":
		emit_signal("walk_complete")
