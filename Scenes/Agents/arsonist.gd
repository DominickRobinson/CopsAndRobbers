extends Agent


@export var graph : Graph


func move_to(new_vertex:Vertex):
	var old_vertex = current_vertex
	
	super.move_to(new_vertex)
	
	await arrived
	
	if is_instance_valid(graph):
		graph.remove_vertex(old_vertex)
