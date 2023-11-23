extends Node

@export var music_track_name : String
@export var activate : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if activate:
		SoundManager.play_music(music_track_name, 0.5)
