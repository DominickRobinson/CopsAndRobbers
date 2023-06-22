extends Node2D


@onready var area = $Area2D

var initial_position = position


func find_open_position():
	position = initial_position
	
	
	while colliding_with_vertices():
		position.x += 50
		await get_tree().physics_frame
	
	var new_position = position
	
	position = initial_position
	
	print(1)
	print(new_position)
	
	return new_position


func colliding_with_vertices():
	for p in area.get_overlapping_areas():
		if p.is_in_group("vertex_area"):
			return true
	
	return false
