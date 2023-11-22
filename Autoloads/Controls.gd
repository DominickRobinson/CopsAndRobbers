extends Node



func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
#		get_tree().quit()
		SceneManager.change_scene("res://Scenes/Levels/main_menu.tscn")

	if Input.is_action_just_pressed("pause"):
		PauseManager.toggle_pause()
