class_name GraphData
extends Node


#@export var size : int = 1
var size = 1

#@export var reflexive : bool = true
#@export var directed : bool = false


var graph : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	size = clamp(size, 1, 99)
	
	for i in size:
		graph.append([])
		for j in size:
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
	
	print(output)
	return output


func add_vertex():
	#make other vertices not adjacent to new vertex
	for i in graph.size():
		graph[i].append(false)
	#make new vertex not adjacent to new vertex
	graph.append([])
	#add last row
	for i in graph.size():
		graph[graph.size()-1].append(false)


func remove_vertex(index : int):
	#check for validity of vertex
	if not is_valid_vertex(index) or graph.size() == 1: return
	#remove column
	for i in graph.size():
		graph[i].remove_at(index)
	#remove row
	graph.remove_at(index)


func add_edge(start_index:int, end_index:int):
	if not is_valid_edge(start_index, end_index): return
	graph[start_index][end_index] = true

func remove_edge(start_index:int, end_index:int):
	if not is_valid_edge(start_index, end_index): return
	graph[start_index][end_index] = false


func edge_exists(start_index:int, end_vertex:int):
	return graph[start_index][end_vertex]


func is_valid_graph():
	for i in graph.size():
		if graph[i].size() != graph.size():
			return false
	return true

func is_valid_vertex(index):
	return index in range(0, graph.size())

func is_valid_edge(start_index, end_index):
	return is_valid_vertex(start_index) and is_valid_vertex(end_index)


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



func bool_to_int(bool_graph : Array = graph):
	var int_graph : Array
	for i in graph.size():
		int_graph.append([])
		for j in graph.size():
			int_graph[i].append(int(bool_graph[i][j]))
	return int_graph

func int_to_bool(int_graph : Array):
	var bool_graph : Array
	for i in graph.size():
		int_graph.append([])
		for j in graph.size():
			int_graph[i].append(bool(bool_graph[i][j]))
	return int_graph
