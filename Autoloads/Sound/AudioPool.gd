@tool
extends Node


@export_group("Sound")
@export_subgroup("Title")
@export var cops_and_robbers : Array[AudioStream]
@export_subgroup("Editor")
@export var sound_vertex_add : Array[AudioStream]
@export var sound_vertex_remove : AudioStream
@export var sound_edge_add_start : AudioStream
@export var sound_edge_add : AudioStream
@export var sound_edge_remove : AudioStream
@export_subgroup("Gameplay")
@export var sound_vertex_select : AudioStream
@export var sound_footsteps : AudioStream
@export var sound_laugh : AudioStream

@export_group("UI")
@export var ui_button_select : AudioStream
@export var ui_button_press : AudioStream
@export var ui_pause_press : AudioStream

@export_group("Music")
@export var music_title : AudioStream
@export var music_editor : AudioStream
@export_subgroup("Game modes")
@export var music_cops_and_robbers : AudioStream
@export var music_zombies_and_survivors : AudioStream
@export var music_ghosts_and_ghostbusters : AudioStream
@export var music_cattle_ranching : AudioStream



var audio_dict : Dictionary = {}
var export_variables : Array[String]


# Called when the node enters the scene tree for the first time.
func _ready():
	for p in get_property_list():
		if p.usage == 4102:
			export_variables.append(p.name)
		
	for v in export_variables:
		audio_dict[v] = get(v)


func get_audio(key:String = ""):
	if key in audio_dict.keys():
		return audio_dict[key]
	else:
		return null
