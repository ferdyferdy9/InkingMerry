extends Node2D

signal animation_changed(old_anim, new_anim)
signal light_turned_on
signal light_turned_off

onready var anim_player:AnimationPlayer = $AnimationPlayer
onready var anim_tree:AnimationTree = $AnimationTree
onready var timer:Timer = $Timer
onready var awake_timer:Timer = $AwakeTimer

var isSleeping:bool
var isAwake:bool
var isHoldLight:bool
var isToggleLight:bool
var isRollRight:bool
var isRollLeft:bool
var isYawn:bool

var _curr_anim:String
var _last_anim:String
var _renko
var _is_timer_active:bool


func _ready() -> void:
	isSleeping = true
	update_animation_flags()
	anim_tree.active = true
	var arr = get_tree().get_nodes_in_group("RenkoStep")
	if arr.empty():
		return
	_renko = arr[0]


func _process(delta: float) -> void:
	update_animation_flags()
	
	var state_machine:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
	_curr_anim = state_machine.get_current_node()
	if _last_anim != _curr_anim:
		emit_signal("animation_changed", _last_anim, _curr_anim)
		if _last_anim == "sleeping":
			awake_timer.start()
			_is_timer_active = true
		elif _curr_anim == "sleeping":
			_is_timer_active = false
	_last_anim = _curr_anim


func turn_on_lights() -> void:
	anim_tree["parameters/playback"].travel("toggle_light")


func turn_on_lights_slowly() -> void:
	var dist:float = global_position.distance_to(_renko.global_position)
	anim_player.get_animation("wait").length = 1.0 - range_lerp(dist, 80, 425, 0, 1)
	anim_tree["parameters/playback"].travel("toggle_light2")


func wake_up() -> void:
	anim_player.get_animation("wait").length = 2
	anim_tree["parameters/playback"].travel("wait 2")


func play_audio(audio_name:String) -> void:
	SfxPlayer.play(audio_name)


func _on_Timer_timeout() -> void:
	if !isSleeping:
		isSleeping = rand_flag()
	
	isRollRight = rand_flag()
	isRollLeft = rand_flag()
	
	match(Globals.sus_level):
		-1, 0:
			isYawn = rand_flag()
			isAwake = false
			isHoldLight = false
			isToggleLight = false
		1:
			isYawn = rand_flag()
			var flag:bool = rand_flag()
			isAwake = flag
			isHoldLight = flag
			isToggleLight = flag
		2:
			var flag:bool = rand_flag()
			isYawn = rand_flag()
			isAwake = rand_flag()
			isHoldLight = flag
			isToggleLight = flag
		3:
			isYawn = false
			isAwake = rand_flag()
			isHoldLight = rand_flag()
			isToggleLight = rand_flag()
	timer.start()


func update_animation_flags() -> void:
	anim_tree["parameters/conditions/Sleeping"] = isSleeping
	anim_tree["parameters/conditions/NotSleeping"] = !isSleeping
	anim_tree["parameters/conditions/Awake"] = isAwake
	anim_tree["parameters/conditions/Yawn"] = isYawn
	anim_tree["parameters/conditions/NotYawn"] = !isYawn
	anim_tree["parameters/conditions/HoldLight"] = isHoldLight
	anim_tree["parameters/conditions/NotHoldLight"] = !isHoldLight
	anim_tree["parameters/conditions/ToggleLight"] = isToggleLight
	anim_tree["parameters/conditions/NotToggleLight"] = !isToggleLight
	anim_tree["parameters/sleeping/conditions/is_roll_left"] = isRollLeft
	anim_tree["parameters/sleeping/conditions/is_roll_right"] = isRollRight


func rand_flag() -> bool:
	return (randi() % 2 == 0)


func _on_AwakeTimer_timeout() -> void:
	if _is_timer_active:
		anim_tree["parameters/playback"].travel("sleeping")
		isSleeping = true
		_is_timer_active = false
