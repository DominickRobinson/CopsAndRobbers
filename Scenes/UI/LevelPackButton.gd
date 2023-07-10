class_name LevelPackButton
extends Button

@export var level_pack : Resource

func _ready():
	pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if level_pack: 
		SceneManager.load_level_pack(level_pack)
