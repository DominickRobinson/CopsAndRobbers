extends Node



func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("pause"):
		PauseManager.toggle_pause()
