extends Node

onready var resources:ResourcePreloader = $ResourcePreloader

func play(sfx_name:String, pitch:Array=[1,1]) -> void:
	var audio_stream = resources.get_resource(sfx_name)
	
	if audio_stream is AudioStreamOGGVorbis:
		audio_stream.loop = false
	
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = audio_stream
	audio_player.bus = "SFX"
	audio_player.pitch_scale = rand_range(pitch[0], pitch[1])
	audio_player.connect("finished", audio_player, "queue_free")
	add_child(audio_player)
	audio_player.play()
