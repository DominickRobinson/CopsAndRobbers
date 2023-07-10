class_name NextLevelButton
extends Button


func _ready():
	if SceneManager.is_last_level():
		hide()
	else:
		pressed.connect(_on_pressed)


func _on_pressed():
	SceneManager.load_next_level()
