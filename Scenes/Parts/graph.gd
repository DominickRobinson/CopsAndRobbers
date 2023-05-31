class_name Graph
extends Node2D


#graph data
@export_group("data structures")
@export var graph_data : GraphData
@export var positions : Array


#sets of vertices and edges
@export_group("Container Nodes")
@export var vertex_container : VertexContainer
@export var edge_container : EdgeContainer

#resources
@export_group("Resources")
@export var vertex_resource : Resource
@export var edge_resource : Resource


@export_group("Debug")
@export var graph_data_display_label : Label



func _process(delta):
	if is_instance_valid(graph_data_display_label):
		graph_data_display_label.text = graph_data.display()



func add_vertex(pos, editable=false):
	graph_data.add_vertex()
	
	var new_vtx = vertex_resource.instantiate() as Vertex
	new_vtx.position = pos
	new_vtx.editable = editable
	new_vtx.index = vertex_container.vertices.size()
	new_vtx.editable = true
	
	vertex_container.add_child(new_vtx)
	
	return new_vtx


func remove_vertex(vtx : Vertex):
	graph_data.remove_vertex(vtx.index)
	
	vertex_container.remove_vertex(vtx)




func add_edge(start_vtx : Vertex, end_vtx : Vertex):
	if graph_data.graph[start_vtx.index][end_vtx.index]: 
		print("Edge already exists...")
		return
	
	graph_data.add_edge(start_vtx.index, end_vtx.index)
	
	var new_edge = edge_resource.instantiate()
	edge_container.add_child(new_edge)
	
	new_edge.start_vertex = start_vtx
	new_edge.end_vertex = end_vtx
	
	return new_edge

func remove_edge(edge : Edge):
	graph_data.remove_edge(edge.start_vertex.index, edge.end_vertex.index)
	
	edge_container.remove_edge(edge)


func clear_graph():
	edge_container.remove_all()
	vertex_container.remove_all()

func refresh_edges():
	edge_container.remove_all()
	
	for i in graph_data.size():
		for j in graph_data.size():
			if graph_data.graph[i][j]: 
				var new_edge = edge_resource.instantiate()
				edge_container.add_edge(new_edge)
				new_edge.start_vertex = vertex_container.get_vertex_with_index(i)
				new_edge.end_vertex = vertex_container.get_vertex_with_index(j)


func set_vertex_mode():
	vertex_container.make_vertices_editable(true)
	edge_container.make_edges_editable(false)

func set_edge_mode():
	vertex_container.make_vertices_editable(false)
	edge_container.make_edges_editable(true)


func save_graph(path : String):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var array = graph_data.bool_to_int()
#	var array = graph_data.graph
	
	for i in graph_data.graph.size():
		var row = PackedStringArray(array[i])
		match path.get_extension():
			"csv":
				print("saving .csv")
				save_file.store_csv_line(row, ",")
			"tsv":
				print("saving .tsv")
				save_file.store_csv_line(row, "\t")



func load_graph(path : String):
	var load_file = FileAccess.open(path, FileAccess.READ)
	
	var adjacency_matrix = []
	var positions = []
	
	match path.get_extension():
		"JSON":
			var json_as_text = FileAccess.get_file_as_string(path)
			var json_as_dict = JSON.parse_string(json_as_text)
			if json_as_dict:
				print(json_as_dict)
				
			adjacency_matrix = json_as_dict["adjacency_matrix"]
			positions = json_as_dict["positions"]
		"csv":
			while !load_file.eof_reached():
				adjacency_matrix.append([])
				var row
				row = load_file.get_csv_line(",")
				
		"tsv":
			while !load_file.eof_reached():
				adjacency_matrix.append([])
				var row
				row = load_file.get_csv_line("\t")
	
	if positions == []:
		pass
	
	for i in graph_data.graph.size():
		pass
	
	
	
	graph_data.graph = adjacency_matrix
	




func generate_default_positions() -> Array:
	positions = []
	var center = get_viewport_rect().size / 2
	var radius = min(get_viewport_rect().size.x, get_viewport_rect().size.y) / 3
	for i in vertex_container.vertices.size():
		var radians = 2 * PI * i / vertex_container.vertices.size()
		var pos = Vector2(cos(radians), sin(radians)) * radius + center
		positions.append(pos)
	return positions


func get_positions() -> Array:
	positions = []
	for v in vertex_container.vertices:
		positions.append(v.position)
	return positions

func set_positions():
	assert(positions.size() == vertex_container.vertices.size())
	for i in vertex_container.vertices.size():
		vertex_container.vertices[i].position = positions[i]
