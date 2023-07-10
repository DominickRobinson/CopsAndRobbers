class_name ReloadLevelButton
extends Button


func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	SceneManager.load_level()
