extends State

@export var player : Player


func _on_state_entered():
	super._on_state_entered()
	
	if player is Robber:
		if player.captured:
			go_to_next_state()
			return
	
	var vertices
	
	if not is_instance_valid(player.current_vertex):
		vertices = graph.get_vertices()
	else:
		vertices = player.current_vertex.get_neighbors()
	
	for v in vertices:
		v = v as Vertex
		v.selected.connect(_on_vertex_selected.bind(v))
		v.selectable = true
	
	if is_instance_valid(player): player.arrived.connect(go_to_next_state)


func _on_vertex_selected(vtx:Vertex):
	player.move_to(vtx)
	
	for v in graph.vertices:
		v = v as Vertex
		v.selected.disconnect(_on_vertex_selected)
		v.selectable = false
	

func _on_state_exited():
	super._on_state_exited()
	
	for v in graph.vertices:
		v = v as Vertex
		v.selected.disconnect(_on_vertex_selected)
		v.selectable = false
	
	if is_instance_valid(player): player.arrived.disconnect(go_to_next_state)
