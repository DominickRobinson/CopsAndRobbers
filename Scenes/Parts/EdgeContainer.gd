class_name EdgeContainer
extends GraphComponentContainer

var edges:
	get:
		return get_children()

func add_edge(e:Edge):
	add_child(e)

func remove_edge(e:Edge):
	e.remove()

func remove_edge_with_indices(start_index:int, end_index:int):
	for e in edges:
		e = e as Edge
		if is_instance_valid(e.start_vertex) and is_instance_valid(e.end_vertex):
			if e.start_vertex.index == start_index and e.end_vertex.index == end_index:
				e.remove()

func remove_edge_with_start_vertex(start_vertex:Vertex):
	for e in edges:
		e = e as Edge
		if is_instance_valid(e.start_vertex):
			if e.start_vertex == start_vertex:
				e.remove()

func remove_edge_with_start_index(start_index:int):
	for e in edges:
		e = e as Edge
		if is_instance_valid(e.start_index):
			if e.start_vertex.index == start_index:
				e.remove()

func remove_edge_with_end_vertex(end_vertex:Vertex):
	for e in edges:
		e = e as Edge
		if is_instance_valid(e.end_vertex):
			if e.end_vertex == end_vertex:
				e.remove()

func remove_edge_with_end_index(end_index:int):
	for e in edges:
		e = e as Edge
		if is_instance_valid(e.end_index):
			if e.end_vertex.index == end_index:
				e.remove()

func remove_edge_with_vertex(vertex:Vertex):
	remove_edge_with_start_vertex(vertex)
	remove_edge_with_end_vertex(vertex)

func remove_edge_with_vertex_index(index:int):
	remove_edge_with_start_index(index)
	remove_edge_with_end_index(index)


func make_edges_editable(editable:bool=true):
	for e in edges:
		e = e as Edge
		e.editable = editable
