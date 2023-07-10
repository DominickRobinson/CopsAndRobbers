extends State



func _on_state_entered():
	super._on_state_entered()
	
	assert(is_instance_valid(agent))
	
	if agent.captured:
		go_to_next_state()
		return
	
	var vertices
	
	if not is_instance_valid(agent.current_vertex):
		vertices = graph.get_vertices()
	else:
		vertices = agent.current_vertex.get_neighbors()
	
	
	agent.arrived.connect(go_to_next_state)
	
	
	
	#chooses random neighbor to move to
	var drunk_move : Vertex = vertices[randi() % vertices.size()]
	agent.move_to(drunk_move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
