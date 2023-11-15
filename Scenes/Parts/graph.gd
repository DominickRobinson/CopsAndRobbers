#@tool
class_name Graph
extends Node2D

signal changed
signal refreshed

signal created

signal vertex_selected(vtx:Vertex)
signal vertex_moved()

#graph data
@export_group("data structures")
@export var graph_data : GraphData
@export_file("*.json") var graph_filepath
#	set(value):
#		graph_filepath = value
#		load_graph(graph_filepath)
#var positions : Array


#sets of vertices and edges
@export_group("Nodes")
@export var vertex_container : VertexContainer
@export var edge_container : EdgeContainer
@export var camera : LevelCamera

#resources
@export_group("Resources")
@export var vertex_resource : Resource
@export var edge_resource : Resource
@export var vertex_style_resource : VertexStyle :
	set(value):
		vertex_style_resource = value
		if is_node_ready():
			vertex_container.vertex_style_resource = vertex_style_resource
@export var edge_style_resource : EdgeStyle:
	set(value):
		edge_style_resource = value
		if is_node_ready():
			edge_container.edge_style_resource = edge_style_resource


@export_group("Debug")
@export var graph_data_display_label : Label

var capture_time = -1

var vertices : Array :
	get:
		return vertex_container.vertices

var edges : Array :
	get:
		return edge_container.edges

var mappings


var title : String = ""
var author : String = ""
var description : String = ""
var citation : String = ""

var strict_corner_ranking : Array

func _ready():
	graph_data.changed.connect(_on_graph_data_changed)
	
	changed.connect(refresh)
	
	if graph_filepath != null:
		await load_graph(graph_filepath)
	
	refresh()
	await refreshed
	created.emit()
	
func _physics_process(delta):
#	set_graph_data_display_label()
	pass


func _on_graph_data_changed(old,new):
	set_graph_data_display_label()
#	changed.emit()
#	refresh()
	pass

func get_vertices():
	return vertex_container.vertices

func get_vertex_from_index(index:int):
	return get_vertices()[index]

func get_edges():
	return edge_container.edges


func set_graph_data_display_label():
	if is_instance_valid(graph_data_display_label):
		var show_matrix = graph_data.size() < 10
		var show_rankings = graph_data.size() < 20
		graph_data_display_label.text = graph_data.display(show_matrix, show_rankings)

func size():
	return graph_data.size()

func get_neighbors_from_vertex(vtx:Vertex) -> Array:
	var nbors = []
	var i = vtx.index
	for j in graph_data.size():
		
		if i < graph_data.size() and graph_data.graph[i][j]:
			var nbor = vertex_container.get_vertex_from_index(j)
			nbors.append(nbor)
	return nbors


func get_neighbors_from_index(index:int) -> Array:
	var nbors = []
	for j in graph_data.size():
		if graph_data.graph[index][j]: nbors.append(j)
	return nbors





func add_vertex(pos, emit_change = true):
#	var new_vtx = vertex_container.add_new_vertex(vertex_resource, pos)
	var new_vtx = vertex_resource.instantiate() as Vertex
	new_vtx.index = vertices.size()
	new_vtx.position = pos
#	new_vtx.position = positions[i]
#	new_vtx.moved.connect(update_positions.bind(new_vtx))
	new_vtx.selected.connect(emit_signal.bind("vertex_selected", new_vtx))
	new_vtx.moved.connect(emit_signal.bind("vertex_moved"))
	
	vertex_container.add_vertex(new_vtx)
	
#	positions.append(pos)
	graph_data.add_vertex()
	
	if emit_change:
		changed.emit()
	
	return new_vtx

func add_corner(pos:Vector2=Vector2(0,0), probability:float=0.5):
	if vertices.size() == 0:
		add_vertex(pos)
		await changed
		make_reflexive()
		return
	
	if vertices.size() == 1:
		add_vertex(pos)
		await changed
		fill()
		return
	
	add_vertex(pos)
	await changed
	make_reflexive()
	await changed
	var old_vtx = vertices[randi_range(0, vertices.size() - 2)] as Vertex
	var new_vtx = vertices[-1]
	
	#add edges
	add_edge(old_vtx, new_vtx, true)
	add_edge(new_vtx, new_vtx)
	
	var rng = RandomNumberGenerator.new()
	for nbor in old_vtx.get_neighbors():
		var my_random_number = rng.randf_range(0.0, 1.0)
		if my_random_number <= probability:
			add_edge(new_vtx, nbor, true)
	
	await changed
	await set_positions_by_ranking()
	
	changed.emit()
	return

func wait(time=0.0):
	await get_tree().create_timer(time).timeout
	return true

func add_strict_corner(pos:Vector2=Vector2(0,0), probability:float=0.5):
	if vertices.size() == 0:
		await wait()
		await add_vertex(pos, false)
		await wait()
		await make_reflexive()
		return true
	
	if vertices.size() == 1:
		await wait()
		await add_vertex(pos, false)
		await wait()
		await fill()
		return true
	
	
	await wait()
	await add_vertex(pos, false)
	await wait()
	await make_reflexive(false)
	await wait()
	var old_vtx = vertices[randi_range(0, vertices.size() - 2)] as Vertex
	var new_vtx = vertices[vertices.size() - 1]
	
	#add edges
	await add_edge(old_vtx, new_vtx, true, false)
	await wait(0)
	await add_edge(new_vtx, new_vtx, true, false)
	await wait(0)
	
	var rng = RandomNumberGenerator.new()
	for nbor in old_vtx.get_neighbors():
		var my_random_number = rng.randf_range(0.0, 1.0)
		if my_random_number <= probability:
			await add_edge(new_vtx, nbor, true, false)
			await wait(0)
	
	
	if new_vtx.neighbors.size() == old_vtx.neighbors.size():
		var vtxs = new_vtx.neighbors
#		vtxs.erase(old_vtx)
#		vtxs.erase(new_vtx)
		var vtx_to_remove = vtxs[randi() % vtxs.size()]
		while (vtx_to_remove == old_vtx) or (vtx_to_remove == new_vtx):
			vtx_to_remove = vtxs[randi() % vtxs.size()]
		
		await remove_edge_given_vertices(new_vtx, vtx_to_remove, true)
	
	changed.emit()
	return true

func remove_vertex(vtx : Vertex, emit_change = true):
#	positions.remove_at(vtx.index)
	await graph_data.remove_vertex(vtx.index)
#	await wait(0)
	await vertex_container.remove_vertex(vtx)
	await wait(0)
	if emit_change:
		changed.emit()
	return true


func add_edge(start_vtx : Vertex, end_vtx : Vertex, undirected : bool = false, emit_change=true):
	graph_data.add_edge(start_vtx.index, end_vtx.index)
	var new_edge = edge_resource.instantiate() as Edge
	new_edge.start_vertex = start_vtx
	new_edge.end_vertex = end_vtx
	edge_container.add_edge(new_edge)
	if undirected:
		graph_data.add_edge(end_vtx.index, start_vtx.index)
		var new_edge2 = edge_resource.instantiate() as Edge
		new_edge2.start_vertex = end_vtx
		new_edge2.end_vertex = start_vtx
		edge_container.add_edge(new_edge2)
	
	if emit_change:
		changed.emit()
	
	return true


func remove_edge(edge : Edge, reflexive : bool = false, emit_change = true):
	graph_data.remove_edge(edge.start_vertex.index, edge.end_vertex.index)
	if reflexive:
		graph_data.remove_edge(edge.end_vertex.index, edge.start_vertex.index)
	
	if emit_change:
		changed.emit()
	

func remove_edge_given_vertices(v1:Vertex, v2:Vertex, undirected:bool=false):
	graph_data.remove_edge(v1.index, v2.index)
	if undirected:
		graph_data.remove_edge(v2.index, v1.index)
	
	changed.emit()
	

func make_reflexive(emit_change=true):
	graph_data.make_reflexive()
	if emit_change:
		changed.emit()
	return true

func make_undirected(emit_change=true):
	await graph_data.make_undirected()
	if emit_change:
		changed.emit()
	return true

func fill(emit_change=true):
	await graph_data.fill()
	if emit_change:
		changed.emit()
	return true

func clear(emit_change=true):
	await graph_data.clear()
	if emit_change:
		changed.emit()
	return true

func empty(emit_change=true):
	await graph_data.empty()
	await vertex_container.remove_all()
	await edge_container.remove_all()
	
#	for v in vertices:
#		await remove_vertex(v, false)
#
#	await refresh_edges()
	
	if emit_change:
		changed.emit()
	return true

func invert(emit_change=true):
	await graph_data.invert()
	if emit_change:
		changed.emit()
	return true

func square(emit_change=true):
	await graph_data.square()
	if emit_change:
		changed.emit()
	return true

func retract_strict_corner(emit_change=true):
	for v in vertices:
		v = v as Vertex
		if v.is_isolated():
			print("Vertex ", v.index, " is isolated...")
			await remove_vertex(v, false)
#			await wait()
			await refresh_vertices()
#			await refresh()
#			await wait()
			return true
	return true


func retract_strict_corners(emit_change=true):
	await graph_data.retract_strict_corners()
	await recalculate_strict_corner_ranking()
	
	while not is_copwin():
		await recalculate_strict_corner_ranking()
		await retract_strict_corner(false)
	
	
	if emit_change:
		changed.emit()
	return true


func retract_corners(emit_change=true):
	await graph_data.retract_corners()
	if emit_change:
		changed.emit()
	return true

func clear_graph(emit_change=true):
	await edge_container.remove_all()
	await vertex_container.remove_all()
	if emit_change:
		changed.emit()
	return true

func get_capture_time():
	capture_time = graph_data.get_capture_time()
	return capture_time

#func get_Fk_mapping(k:int) -> Dictionary:
#	var mapping : Dictionary = {}
#	var graph_data_mapping = graph_data.get_F_k_mapping(k, graph_data)
#
#	for i in graph_data_mapping.keys():
#		mapping[vertex_container.get_vertex_from_index(i)] = []
#		for j in graph_data_mapping[i]:
#			var new_vtx = mapping[vertex_container.get_vertex_from_index(j)]
#			mapping[vertex_container.get_vertex_from_index(i)].append(new_vtx)
#
#	return mapping

#func get_Fk_mappings() -> Array:
#	var mappings : Array = []
#	var graph_data_mappings : Array = graph_data.get_F_k_mappings(graph_data)
#
#	for k in range(1, graph_data_mappings.size()+1):
#		mappings.append(get_Fk_mapping(k))
#
#	return mappings


func get_Fk_mappings() -> Array:
	mappings = []
	var graph_data_mappings : Array = graph_data.get_F_k_mappings(graph_data)
	for m in graph_data_mappings:
		var mapping : Dictionary = {}
		for a in m.keys():
			var vtx_a = vertex_container.get_vertex_from_index(a)
			mapping[vtx_a] = []
			for b in m[a]:
				var vtx_b = vertex_container.get_vertex_from_index(b)
				mapping[vtx_a].append(vtx_b)
		mappings.append(mapping)
	get_capture_time()
	return mappings

func refresh():
	await refresh_vertices()
	await refresh_edges()
	
	await wait(0)
	
	await recalculate_strict_corner_ranking()
#
#	for v in vertices:
#		v = v as Vertex
#		if v.index < scr.size():
#			v.strict_corner_ranking = scr[v.index]
#		v.is_top = (v.strict_corner_ranking == get_max_ranking())
#
#
#	mappings = get_Fk_mappings()
#	capture_time = get_capture_time()
	
	refreshed.emit()
	return true


func refresh_vertices():
	for i in vertices.size():
		var v = vertices[i] as Vertex
		v.index = i
		v.neighbors = get_neighbors_from_vertex(v)
	return true

func refresh_edges():
	edge_container.remove_all()
	
	for i in graph_data.size():
		for j in graph_data.size():
			if graph_data.graph[i][j]:
				var new_edge = edge_resource.instantiate() as Edge
#				new_edge.start_vertex = vertex_container.get_vertex_from_index(i)
				new_edge.start_vertex = vertices[i]
#				new_edge.end_vertex = vertex_container.get_vertex_from_index(j)
				new_edge.end_vertex = vertices[j]
				
				new_edge.directed = not graph_data.graph[j][i]
				
				await edge_container.add_edge(new_edge)
				
	return true

func get_max_ranking():
	return graph_data.get_max_ranking()

func update_positions(vtx:Vertex):
#	positions[vtx.index] = vtx.position
	pass

func set_positions_by_ranking():
	var start_pos = Vector2(150,100)
	var row_sep = 100
	var col_sep = 100
	var ranking = 0
	
	for v in vertices:
		v = v as Vertex
		if v.strict_corner_ranking > ranking: ranking = v.strict_corner_ranking
	
	for i in range(-1, ranking+1):
		var vtxs = []
		for v in vertices: 
			if v.strict_corner_ranking == i:
				vtxs.append(v)
		var y_pos_offset : float = (ranking+1-i) * row_sep
		var x_pos_offset : float = 1
		for j in vtxs.size():
			var v = vtxs[j] as Vertex
			x_pos_offset = abs(x_pos_offset) + col_sep
			v.position = start_pos + Vector2(x_pos_offset, y_pos_offset)
	
	changed.emit()

func set_vertex_mode():
	vertex_container.make_vertices_editable(true)
	edge_container.make_edges_editable(false)

func set_edge_mode():
	vertex_container.make_vertices_editable(false)
	edge_container.make_edges_editable(true)


func save_graph(path : String):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = get_graph_as_JSON()
	save_file.store_string(json_string)


func get_graph_as_JSON():
	var array = graph_data.bool_to_int()

	var positions_string_array = []
	for v in vertices:
		var p = v.position
		positions_string_array.append(var_to_str(p))
	var positions_string = var_to_str(positions_string_array)

	var dict : Dictionary = {
		"adjacency_matrix" : array,
		"positions" : positions_string,
#		"corner_ranking" : str(graph_data.strict_corner_ranking)
		"title" : title,
		"author" : author,
		"description" : description,
		"citation" : citation,
		"zoom_scale" : get_zoom_scale()
	}
	var json_string = JSON.stringify(dict)
	return json_string

func remove_vertices(emit_change = false):
	for v in vertices:
		await remove_vertex(v, emit_change)
	return true

func remove_edges(emit_change = false):
	for e in edges:
		await remove_edge(e, true, false)
	return true

func load_graph(path : String):
	
	var load_file = FileAccess.open(path, FileAccess.READ)
	var adjacency_matrix = []
	var positions = []
	
	match path.get_extension():
		"json":
			var json_as_text = FileAccess.get_file_as_string(path)
			await make_graph_from_JSON(json_as_text)
		"csv":
			await clear_graph(false)
			var array = []
			var i = 0
			while !load_file.eof_reached():
				array.append([])
				var row = load_file.get_csv_line(",")
				for j in row.size():
					array[i].append(int(row[j]))
				i += 1
			array.pop_back()
			positions = generate_default_positions(array.size())
			for j in array.size():
				await add_vertex(positions[j])
			graph_data.graph = array
			changed.emit()
			
		"tsv":
			await clear_graph(false)
			var array = []
			var i = 0
			while !load_file.eof_reached():
				array.append([])
				var row = load_file.get_csv_line("\t")
				for j in row.size():
					array[i].append(int(row[j]))
				i += 1
			array.pop_back()
			positions = generate_default_positions(array.size())
			for j in array.size():
				await add_vertex(positions[j])
			graph_data.graph = array
			changed.emit()
			
	
#	await get_tree().create_timer(0.5).timeout
	
	return true
#	if positions == []:
#		positions = generate_default_positions(graph_data.size())


func make_graph_from_JSON(json_as_text:String):
	await empty(false)
	await wait(0)
	var json_as_dict = JSON.parse_string(json_as_text) as Dictionary
	var matrix = json_as_dict["adjacency_matrix"]
#	print("adjacency matrix:", adjacency_matrix)
	var positions_array = str_to_var(json_as_dict["positions"])
	var positions = []
	for p in positions_array:
		positions.append(str_to_var(p))
	
	
	for i in positions.size():
#		await wait()
		await add_vertex(positions[i], false)
#		print(" adding vertex ", i)
	
	graph_data.graph = matrix
	
	for i in graph_data.graph.size():
		var vertex_i = get_vertex_from_index(i)
		for j in graph_data.graph.size():
			var vertex_j = get_vertex_from_index(j)
			if graph_data.edge_exists(i, j):
				await add_edge(vertex_i, vertex_j, false, false)

	
#	graph_data.graph = adjacency_matrix
#	await recalculate_strict_corner_ranking()
	
	var keys = json_as_dict.keys()
	if "title" in keys: title = json_as_dict["title"]
	else: title = ""
	
	if "author" in keys: author = json_as_dict["author"]
	else: author = ""
	
	if "description" in keys: description = json_as_dict["description"]
	else: description = ""
	
	if "citation" in keys: citation = json_as_dict["citation"]
	else: citation = ""
	
	if "zoom_scale" in keys: set_zoom_scale(json_as_dict["zoom_scale"])
	else: set_zoom_scale()
	
	changed.emit()



func set_title(str:String): title = str
func set_author(str:String): author = str
func set_description(str:String): description = str
func set_citation(str:String): citation = str


func set_positions_in_circle():
	var positions = generate_default_positions(graph_data.size())
	for i in vertices.size():
		vertices[i].position = positions[i]

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


func is_copwin():
	for v in vertices:
		v = v as Vertex
		if v.strict_corner_ranking < 1:
			return false
	
	return true


func get_mappings():
	return mappings

func show_strict_corner_rankings(show:bool=true):
	for v in vertices:
		v.show_strict_corner_ranking(show)




func get_best_cop_move(agent:Agent) -> Vertex:
	var neighbors : Array
	
	if not is_instance_valid(agent.current_vertex):
		neighbors = get_vertices()
	else:
		neighbors = agent.get_vertex().get_neighbors()
	
#	get_Fk_mappings()
	
	#chooses random neighbor to move to
	var move : Vertex = null
	
	#first move
	if not is_instance_valid(agent.current_vertex):
		move = neighbors[0]
		for v in neighbors:
			v = v as Vertex
			if v.strict_corner_ranking > move.strict_corner_ranking:
				move = v
		return move
	
	#not copwin graph
	if not is_copwin():
		return neighbors[0]
	
	mappings = get_mappings()
	
	var target = agent.get_target()
	
	#find new target
	if target == null:
		var robbers = get_tree().get_nodes_in_group("Robbers")
		if robbers.size() == 0:
			return neighbors[0]
		else:
			target = robbers[randi() % robbers.size()]
	
	var moves = []
	#in each mapping, check if robber shadow is found
#	print("Mappings: ", mappings)
	for mapping in mappings:
		for nbor in neighbors:
			if nbor in mapping[target.get_vertex()]:
				moves.append(nbor)
#				break
	
	
#	print("\n\n\nMoves first found: ")
	#gets minimum scr in possible moves
	var minimum_scr = size()
	for m in moves:
		m = m as Vertex
#		print(" ", m.index)
		if m.strict_corner_ranking < minimum_scr:
			minimum_scr = m.strict_corner_ranking
	
#	print("Minimum scr option: ", minimum_scr)
	
	#removes vertices with non-minimum scr
	var new_moves = []
	for m in moves:
		m = m as Vertex
#		print(" vertex: ", m.index, " - scr: ", m.strict_corner_ranking)
		if m.strict_corner_ranking == minimum_scr:
#			moves.erase(m)
			new_moves.append(m)
	
	moves = new_moves
#	print("Moves: ", moves)
	
#	print("Moves after removing non-minima:")
#	for m in moves:
#		print(" ", m.index)
	
	move = moves.pick_random()
#	print("Move selected: ", move.index)
	
	#if not found in any, then go to highest ranking neighbor
	if move == null:
		print("No move found...")
		move = neighbors[0]
		for nbor in neighbors:
			nbor = nbor as Vertex
			if nbor.strict_corner_ranking > move.strict_corner_ranking:
				move = nbor
	
	return move


func get_zoom_scale():
	if is_instance_valid(camera):
		return camera.get_zoom_scale()
	return 1

func set_zoom_scale(s : float = 1.0):
	if is_instance_valid(camera):
		camera.set_zoom_scale(s)


func recalculate_strict_corner_ranking():
	strict_corner_ranking = await graph_data.get_strict_corner_ranking()
	
	for i in vertices.size():
		vertices[i].strict_corner_ranking = strict_corner_ranking[i]
	
	return graph_data.strict_corner_ranking
