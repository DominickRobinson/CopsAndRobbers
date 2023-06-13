extends Node



func change_scene(scene_path):
	
	PauseManager.unpause()
	
	SoundManager.stop_music()
	
	if scene_path == null:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(scene_path)
