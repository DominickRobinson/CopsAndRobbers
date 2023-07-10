extends State



func _on_state_entered():
	super._on_state_entered()
	
	if not agent.captured: agent.play_idle()
	
	if agent.captured:
		go_to_next_state()
		return
	
	var vertices
	
	if not is_instance_valid(agent.current_vertex):
		vertices = graph.get_vertices()
	else:
		vertices = agent.current_vertex.get_neighbors()
	
	print("Agent: ", agent.name)
	if is_instance_valid(agent.current_vertex):
		print("Current vtx: ", agent.current_vertex.name)
		print("Current vtx neighbors: ", agent.current_vertex.get_neighbors())
	print("Available moves: ", vertices)
	
	for v in vertices:
		v = v as Vertex
		v.selected.connect(_on_vertex_selected.bind(v))
		v.selectable = true
	
	if is_instance_valid(agent): agent.arrived.connect(go_to_next_state)


func _on_vertex_selected(vtx:Vertex):
	agent.move_to(vtx)
	
	for v in graph.vertices:
		v = v as Vertex
		if v.selected.is_connected(_on_vertex_selected):
			v.selected.disconnect(_on_vertex_selected)
		v.selectable = false
	

func _on_state_exited():
	super._on_state_exited()
	
	if not agent.captured: agent.stop_animation()
	
	for v in graph.vertices:
		v = v as Vertex
		if v.selected.is_connected(_on_vertex_selected):
			v.selected.disconnect(_on_vertex_selected)
		v.selectable = false
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
