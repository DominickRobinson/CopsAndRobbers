class_name SceneButton
extends Button


@export_file("*.tscn") var scene_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	if scene_path == null:
		get_tree().reload_current_scene()
		PauseManager.unpause()
	else:
		PauseManager.unpause()
		get_tree().change_scene_to_file(scene_path)
