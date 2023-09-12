extends Node


@export var sound_count : int = 10


@export_group("Nodes")
@export var sound_queue : Node
@export var ui_sound_queue : Node
@export var music_player : AudioStreamPlayer

@export var audio_pool : Node






func play_sound(audio_name:String, vol:float=0.0, loop:bool=false, pitch:float=1.0) -> AudioStreamPlayer:
	var audio = audio_pool.get_audio(audio_name)
	
	#type is audiostream
	if is_instance_of(audio, AudioStream):
		return sound_queue.play_audio(audio, vol, loop, pitch)
	#type is array
	elif typeof(audio) == 28:
		return sound_queue.play_random_audio(audio, vol, loop, pitch)
	
	return null


func play_ui_sound(audio_name:String, vol:float=0.0, loop:bool=false, pitch:float=1.0) -> AudioStreamPlayer:
	var audio = audio_pool.get_audio(audio_name)
	return ui_sound_queue.play_audio(audio, vol, loop, pitch)

func play_music(audio_name:String, fade:float=1.0, vol:float=0.0, loop:bool=true, pitch:float=1.0) -> AudioStreamPlayer:
	var audio = audio_pool.get_audio(audio_name)
	music_player.stream = audio
	if loop:
		music_player.finished.connect(music_player.play)
	else:
		music_player.finished.disconnect(music_player.play)
	music_player.pitch_scale = pitch
	
	var tween = create_tween()
	music_player.volume_db = -99
	tween.tween_property(music_player, "volume_db", vol, fade).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.play()
	
	music_player.play()
	
	return music_player

func play_music_file(audio:AudioStream, fade:float=1.0, vol:float=0.0, loop:bool=true, pitch:float=1.0) -> AudioStreamPlayer:
	music_player.stream = audio
	if loop:
		music_player.finished.connect(music_player.play)
	else:
		music_player.finished.disconnect(music_player.play)
	music_player.pitch_scale = pitch
	
	var tween = create_tween()
	music_player.volume_db = -99
	tween.tween_property(music_player, "volume_db", vol, fade).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.play()
	
	music_player.play()
	
	return music_player

func stop_music(fade:float=1.0) -> AudioStreamPlayer:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -99, fade).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.play()
	
	return music_player


func change_volume_sound(new_value):
	var sound_bus = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_volume_db(sound_bus, linear_to_db(new_value))

func change_volume_music(new_value):
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(new_value))

func change_volume(bus, new_value):
	pass
