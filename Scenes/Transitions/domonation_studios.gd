extends Control

@onready var anim = $AnimationPlayer

@export_file var next_scene 

func _ready():
	anim.play("fade")
	
	await anim.animation_finished
	
	SceneManager.change_scene(next_scene)
