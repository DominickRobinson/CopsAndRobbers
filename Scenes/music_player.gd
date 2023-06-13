extends Node

@export var music_track_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_music(music_track_name, 10)
