extends Button

@export var levels : Array[Resource]
@onready var level_scene = preload("res://Scenes/Levels/level.tscn")


func _ready():
	SceneManager.change_scene()
