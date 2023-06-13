@tool
class_name Graph
extends Node2D

signal changed
signal refreshed

signal created

signal vertex_selected(vtx:Vertex)


#graph data
@export_group("data structures")
@export var graph_data : GraphData
@export_file("*.json") var graph_filepath
#	set(value):
#		graph_filepath = value
#		load_graph(graph_filepath)
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


var vertices : Array :
	get:
		return vertex_container.vertices

var edges : Array :
	get:
		return edge_container.edges

func _ready():
	graph_data.changed.connect(_on_graph_data_changed)
	
	if graph_filepath != null:
		load_graph(graph_filepath)
	
	await refreshed
	created.emit()
	


func _on_graph_data_changed(old,new):
	changed.emit()
	refresh()

func get_vertices():
	return vertex_container.vertices

func get_edges():
	return edge_container.edges


func _process(delta):
	if is_instance_valid(graph_data_display_label):
		graph_data_display_label.text = graph_data.display()



func get_neighbors_from_vertex(vtx:Vertex) -> Array:
	var nbors = []
	var i = vtx.index
	for j in graph_data.size():
		if graph_data.graph[i][j]:
			var nbor = vertex_container.get_vertex_from_index(j)
			nbors.append(nbor)
	return nbors


func get_neighbors_from_index(index:int) -> Array:
	var nbors = []
	for j in graph_data.size():
		if graph_data.graph[index][j]: nbors.append(j)
	return nbors





func add_vertex(pos):
#	var new_vtx = vertex_container.add_new_vertex(vertex_resource, pos)
	positions.append(pos)
	graph_data.add_vertex()
#	return new_vtx

func remove_vertex(vtx : Vertex):
#	vertex_container.remove_vertex(vtx)
	positions.remove_at(vtx.index)
	graph_data.remove_vertex(vtx.index)



func add_edge(start_vtx : Vertex, end_vtx : Vertex):
	graph_data.add_edge(start_vtx.index, end_vtx.index)


func remove_edge(edge : Edge):
	graph_data.remove_edge(edge.start_vertex.index, edge.end_vertex.index)

func remove_edge_given_vertices(v1:Vertex, v2:Vertex):
	graph_data.remove_edge(v1.index, v2.index)

func make_reflexive():
	graph_data.make_reflexive()

func make_undirected():
	graph_data.make_undirected()

func fill():
	graph_data.fill()

func clear():
	graph_data.clear()

func invert():
	graph_data.invert()

func square():
	graph_data.square()

func retract_strict_corners():
	graph_data.retract_strict_corners()

func retract_corners():
	graph_data.retract_corners()

func clear_graph():
	edge_container.remove_all()
	vertex_container.remove_all()


func get_Fk_mapping(k:int) -> Dictionary:
	var mapping : Dictionary = {}
	var graph_data_mapping = graph_data.get_F_k_mapping(k, graph_data)
	
	for i in graph_data_mapping.keys():
		mapping[vertex_container.get_vertex_from_index(i)] = []
		for j in graph_data_mapping[i]:
			var new_vtx = mapping[vertex_container.get_vertex_from_index(j)]
			mapping[vertex_container.get_vertex_from_index(i)].append(new_vtx)
	
	return mapping


func refresh():
	refresh_vertices()
	await get_tree().process_frame
	refresh_edges()
	
	var scr = graph_data.get_strict_corner_ranking()
	
	for v in vertex_container.vertices:
		v = v as Vertex
		v.strict_corner_ranking = scr[v.index]
	
	refreshed.emit()

func refresh_vertices():
	
	vertex_container.remove_all()
	
	for i in graph_data.size():
		var new_vtx = vertex_resource.instantiate() as Vertex
		new_vtx.index = i
		new_vtx.position = positions[i]
		new_vtx.moved.connect(update_positions.bind(new_vtx))
		new_vtx.selected.connect(emit_signal.bind("vertex_selected", new_vtx))
		
		vertex_container.add_vertex(new_vtx)
	
	for v in vertices:
		v = v as Vertex
		v.neighbors = get_neighbors_from_vertex(v)

func refresh_edges():
	edge_container.remove_all()
	
	for i in graph_data.size():
		for j in graph_data.size():
			if graph_data.graph[i][j]:
				var new_edge = edge_resource.instantiate() as Edge
				new_edge.start_vertex = vertex_container.get_vertex_from_index(i)
				new_edge.end_vertex = vertex_container.get_vertex_from_index(j)
				
				new_edge.directed = not graph_data.graph[j][i]
				
				edge_container.add_edge(new_edge)


func update_positions(vtx:Vertex):
	positions[vtx.index] = vtx.position


func set_vertex_mode():
	vertex_container.make_vertices_editable(true)
	edge_container.make_edges_editable(false)

func set_edge_mode():
	vertex_container.make_vertices_editable(false)
	edge_container.make_edges_editable(true)


func save_graph(path : String):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var array = graph_data.bool_to_int()

	var positions_string_array = []
	for p in positions:
		positions_string_array.append(var_to_str(p))
	var positions_string = var_to_str(positions_string_array)

	var dict : Dictionary = {
		"adjacency_matrix" : array,
		"positions" : positions_string
	}
	var json_string = JSON.stringify(dict)
	save_file.store_string(json_string)


func load_graph(path : String):
#	print("loading ", path.get_extension())
	var load_file = FileAccess.open(path, FileAccess.READ)
	
	var adjacency_matrix = []
	positions = []
	
	match path.get_extension():
		"json":
			var json_as_text = FileAccess.get_file_as_string(path)
#			print("json_as_text: ", json_as_text)
			var json_as_dict = JSON.parse_string(json_as_text)
#			print("json_as_dict: ", json_as_dict)
			adjacency_matrix = json_as_dict["adjacency_matrix"]
#			print(str_to_var(json_as_dict["positions"]))
			var positions_array = str_to_var(json_as_dict["positions"])
			for p in positions_array:
				positions.append(str_to_var(p))
			
#			print(graph_data)
			graph_data.graph = adjacency_matrix
		"csv":
			graph_data.load_graph(path)
			
		"tsv":
			graph_data.load_graph(path)
			
	
	if positions == []:
		positions = generate_default_positions(graph_data.size())
	



func generate_default_positions(num:int) -> Array:
	var array = []
	var center = get_viewport_rect().size / 2
	var radius = min(get_viewport_rect().size.x, get_viewport_rect().size.y) / 3
	for i in num:
		var radians = 2 * PI * i / num
		var pos = Vector2(cos(radians), sin(radians)) * radius + center
		array.append(pos)
	
	return array


func get_positions() -> Array:
	var array = []
	for v in vertex_container.vertices:
		array.append(v.position)
	return array

func set_positions(array:Array):
	assert(array.size() == vertex_container.vertices.size())
	for i in vertex_container.vertices.size():
		vertex_container.vertices[i].position = array[i]
