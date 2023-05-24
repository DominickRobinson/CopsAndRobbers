class_name GraphData
extends Node

@export var initial_size : int = 1

var graph : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_size = clamp(initial_size, 1, 99)
	
	for i in initial_size:
		graph.append([])
		for j in initial_size:
			graph[i].append(false)


func display():
	var output = "Number of vertices = " + str(graph.size()) + "\n"
	#for each row
	for i in graph.size():
		output += "[ "
		#for each column
		for j in graph.size():
			output += str(int(graph[i][j])) + " "
		output += "]\n"
	
#	print(output)
	return output

func size():
	return graph.size()

func add_vertex():
	#make other vertices not adjacent to new vertex
	for i in graph.size():
		graph[i].append(false)
	#make new vertex not adjacent to new vertex
	graph.append([])
	#add last row
	for i in graph.size():
		graph[graph.size()-1].append(false)


func remove_vertex(v : int):
	#check for validity of vertex
	if not is_valid_vertex(v) or graph.size() == 1: return
	#remove column
	for i in graph.size():
		graph[i].remove_at(v)
	#remove row
	graph.remove_at(v)


func add_edge(v1:int, v2:int):
	if not is_valid_edge(v1, v2): return
	graph[v1][v2] = true

func remove_edge(v1:int, v2:int):
	if not is_valid_edge(v1, v2): return
	graph[v1][v2] = false


func edge_exists(v1:int, v2:int):
	return graph[v1][v2]


func is_valid_graph(g : Array = graph):
	for i in g.size():
		if g[i].size() != g.size():
			return false
	return true

func is_valid_vertex(v : int):
	return v in range(0, graph.size())

func is_valid_edge(v1 : int, v2 : int):
	return is_valid_vertex(v1) and is_valid_vertex(v2)


func fill():
	for i in graph.size():
		for j in graph.size():
			graph[i][j] = true

func clear():
	for i in graph.size():
		for j in graph.size():
			graph[i][j] = false

func invert():
	for i in graph.size():
		for j in graph.size():
			graph[i][j] = not graph[i][j]

func make_reflexive():
	for i in graph.size():
		graph[i][i] = true

func make_undirected():
	for i in graph.size():
		for j in graph.size():
			graph[i][j] = graph[i][j] or graph[j][i]


func strictly_corners(v1 : int, v2 : int):
	#checks if a neighbors of v1 does not neighbor v2 
	print("Does ", v1, " strictly corner ", v2, "?")
	for i in graph.size():
		if not graph[v1][i] and graph[v2][i]: 
			print("No")
			return false
	#checks if v1 and v2 have exact same neighbors
	if graph[v1] == graph[v2]: 
		print("No")
		return false
	#v1 must strictly corner v2
	print("yes")
	return true

func are_twins(v1 : int, v2 : int):
	return graph[v1] == graph[v2]

#checks if v1 is cornered by v2
func corners(v1 : int, v2 : int):
	#definition of cornering
	return strictly_corners(v1, v2) or are_twins(v1, v2) and v1 != v2

func get_corners(v : int):
	var c : Array = []
	#checks if v corners each vertex in graph
	for i in graph.size():
		c[i] = corners(v, i)
	#ta-da
	return c

func get_strict_corners(v : int):
	var strict_corners : Array = []
	#checks if v strictly corners each vertex in graph
	for i in graph.size():
		strict_corners[i] = strictly_corners(v, i)
	#ta-da
	return strict_corners


func retract_vertex(v : int):
	print(v)
	#remove vertex without changing graph dimensions
	for i in graph.size():
		graph[i][v] = false
		graph[v][i] = false
#	return g

func retract_strict_corners():
	print(1)
	var old_graph : GraphData = dup()
	print(graph)
	print(old_graph)
	#check each vertex for corners
	for i in old_graph.size():
		for j in old_graph.size():
			#if i is strictly cornered by j
			if old_graph.strictly_corners(j, i): 
				print(2)
				retract_vertex(i)

func retract_corners():
	var old_graph : GraphData = dup()
	#check each vertex for corners
	for i in old_graph.size():
		for j in old_graph.size():
			#if i is strictly cornered by j
			if old_graph.corners(j, i): 
				retract_vertex(i)


func bool_to_int(bool_graph : Array = graph):
	var int_graph : Array = []
	for i in graph.size():
		int_graph.append([])
		for j in graph.size():
			int_graph[i].append(int(bool_graph[i][j]))
	return int_graph

func int_to_bool(int_graph : Array):
	var bool_graph : Array = []
	for i in graph.size():
		int_graph.append([])
		for j in graph.size():
			int_graph[i].append(bool(bool_graph[i][j]))
	return int_graph

func dup():
	var new_graph_data = GraphData.new()
	new_graph_data.graph = graph.duplicate(true)
	return new_graph_data
