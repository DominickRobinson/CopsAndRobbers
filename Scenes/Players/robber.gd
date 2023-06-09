class_name Robber
extends Player

signal caught

var captured = false

func _ready():
	super._ready()
	add_to_group("Robbers")

func get_captured():
	captured = true
	await play_last_animation("captured")
	
	await anim.animation_finished
	
	remove_from_group("Robbers")