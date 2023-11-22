extends Node

@export var count : int = 10

var audio_stream_players : 
	get:
		var players = []
		for c in get_children():
			if c is AudioStreamPlayer:
				players.append(c)
		return players

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in count:
		var a = AudioStreamPlayer.new()
		a.bus = "Sound"
#		a.bus = AudioServer.get_bus_index("Sound")
		add_child(a)
		


func get_open_audio_stream_player()->AudioStreamPlayer:
	for a in audio_stream_players:
		if not a.playing:
			return a
	return null


func play_audio(audio:AudioStream, vol:float=0.0, loop:bool=false, pitch:float=1.0) -> AudioStreamPlayer:
	#find open audio player and set parameters
	var a = get_open_audio_stream_player()
	a.stream = audio
	a.volume_db = vol
	a.pitch_scale = pitch
	#loop if necessary
	if loop:
		if not a.finished.is_connected(a.play):
			a.finished.connect(a.play)
	else:
		if a.finished.is_connected(a.play):
			a.finished.disconnect(a.play)
	#voila
	a.play()
	
	return a

func play_random_audio(audio_list:Array[AudioStream], vol:float=0.0, loop:bool=false, pitch:float=1.0) -> AudioStreamPlayer:
	#gets random audio from list
	if audio_list.size() == 0:
		return null
	var audio = audio_list[randi() % audio_list.size()]
	#play audio like normal
	return play_audio(audio, vol, loop, pitch)


#to be finished+

func play_random_audio_with_probability(_audio_list:Array[AudioStream], _probabilities:Array[float]):
	pass


func stop_all():
	for a in audio_stream_players:
		a = a as AudioStreamPlayer
		a.stop()
