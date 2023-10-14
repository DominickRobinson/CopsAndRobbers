extends Control

@onready var anim = $AnimationPlayer
"res://Resources/level_packs/packs/pack4.tres"
@export_file var next_scene 

func _ready():
	anim.play("fade")
	
	await anim.animation_finished
	
	SceneManager.change_scene(next_scene)

func _process(delta):
	if Input.is_action_just_pressed("select") or Input.is_action_just_pressed("delete"):
		anim.advance(3.0)
