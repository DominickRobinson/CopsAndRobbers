extends Node2D

var follow = false


func _ready():
	await get_tree().create_timer(2).timeout
	follow = true


func _physics_process(delta):
	if follow:
		global_position = get_global_mouse_position()
