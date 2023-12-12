extends Node2D


@onready var area = $Area2D

var initial_position = position

var step_size = 100



#technically inefficient since repeats many coordinates
func find_open_position():
	position = initial_position
	
	var steps = 0
	
	print("start finding")
	while colliding_with_vertices():
		for i in steps+1:
			for j in steps+1:
				print(" i = ", i, "  j = ", j)
				position = initial_position + Vector2(i * step_size, j * step_size)  - (step_size * steps/2)*Vector2(1,1)
				await get_tree().physics_frame

#				await get_tree().create_timer(0.05).timeout
				if not colliding_with_vertices():
					print('end finding')
					print("position: ", position)
					var new_position = position
					position = initial_position
					return new_position
		
		steps += 1
	print('end finding')
	var new_position = position
	position = initial_position
	return new_position



func colliding_with_vertices():
	for p in area.get_overlapping_areas():
		if p.is_in_group("vertex_area"):
			return true
	
	return false
