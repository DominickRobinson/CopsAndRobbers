extends Node


var level_resource = preload("res://Scenes/Levels/level.tscn")

var levels : Array = []
var level_index = 0
var game_resource : Game

var custom_game_resource : Game
var custom_graph_path : String
var is_custom_game : bool = false

func change_scene(scene_path : String = "res://Scenes/Levels/level.tscn"):
	
	PauseManager.unpause()
	
	SoundManager.stop_music()
	
	if scene_path == null:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(scene_path)
	
	return true

func reload_scene():
	get_tree().reload_current_scene()

func reload_level():
	if is_custom_game:
		load_custom_level(custom_game_resource, custom_graph_path)
	else:
		load_level()

func unpack_level_pack(level_pack : Resource):
	game_resource = level_pack.game_resource
	var levels_path = level_pack.levels_path
	level_index = 0
	levels = get_JSON_paths_from_dir(levels_path)

func load_level_pack(level_pack : Resource):
	unpack_level_pack(level_pack)
	load_level()


func load_next_level():
	if not is_last_level():
		level_index +=1 
		load_level()


func load_level():
	is_custom_game = false
	var new_level = level_resource.instantiate()
	new_level.game_resource = game_resource
	new_level.graph_path = levels[level_index]
	if level_index < levels.size() - 1:
		new_level.next_level_path = levels[level_index + 1]
	
	change_scene("res://main.tscn")
	await get_tree().process_frame
	get_tree().current_scene.add_child(new_level)
	
	SoundManager.play_music_file(game_resource.game_theme.music)

func load_custom_level(custom_game_resource:Game, graph_path:String):
	is_custom_game = true
	self.custom_game_resource = custom_game_resource
	self.custom_graph_path = graph_path
	levels = [graph_path]
	var new_level = level_resource.instantiate()
	new_level.game_resource = custom_game_resource
	new_level.graph_path = graph_path
	
	change_scene("res://main.tscn")
	await get_tree().process_frame
	get_tree().current_scene.add_child(new_level)
	
	SoundManager.play_music_file(new_level.game_resource.game_theme.music)


func is_last_level():
	return level_index >= levels.size() - 1


func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			file_name = dir.get_next()


func get_JSON_paths_from_dir(path:String) -> Array:
	var paths : Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "json":
					var str = path + "/" + file_name
					paths.append(str)
			file_name = dir.get_next()
	
	paths.reverse()
	
	return paths
