extends State



func _on_state_entered():
	super._on_state_entered()
	
	assert(is_instance_valid(agent))
	
	if agent.captured:
		go_to_next_state()
		return
	
	var vertices : Array[Vertex]
	
	if not is_instance_valid(agent.current_vertex):
		vertices = graph.get_vertices()
	else:
		vertices = agent.current_vertex.get_neighbors()
	
	
	agent.arrived.connect(go_to_next_state)
	
	
	
	#chooses random neighbor to move to
	var drunk_move : Vertex = vertices.pick_random()
	while not drunk_move.has_cop():
		drunk_move = vertices.pick_random()
		
	agent.move_to(drunk_move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
