extends Node


var level_resource = preload("res://level.tscn")

var levels : Array = []
var level_index = 0
var game_resource : Resource


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
	var new_level = level_resource.instantiate()
	new_level.game_resource = game_resource
	new_level.graph_path = levels[level_index]
	if level_index < levels.size() - 1:
		new_level.next_level_path = levels[level_index + 1]
	
	change_scene("res://main.tscn")
	await get_tree().process_frame
	get_tree().current_scene.add_child(new_level)
	
	SoundManager.play_music_file(game_resource.game_theme.music)



func is_last_level():
	return level_index >= levels.size() - 1


func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func get_JSON_paths_from_dir(path:String) -> Array:
	var paths : Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "json":
					print("Level found: " + file_name)
					var str = path + "/" + file_name
					paths.append(str)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	paths.reverse()
	print(paths)
	
	return paths
