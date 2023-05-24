class_name GraphData
extends Node

@export var initial_size : int = 1

var graph : Array

func _init(s:int=1):
	initial_size = s
	initial_size = clamp(initial_size, 1, 99)
	
	for i in initial_size:
		graph.append([])
		for j in initial_size:
			graph[i].append(false)


func display():
	var output = "Number of vertices = " + str(graph.size()) + "\n"
	output += "Reflexive: " + str(is_reflexive()) + "\n"
	output += "Undirected: " + str(is_undirected()) + "\n"
	output += "Clique: " + str(is_clique()) + "\n"
	output += "Connected: " + str(is_connected_graph()) + "\n"
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
	var old_graph : GraphData = dup()
	#check each vertex for corners
	for i in old_graph.size():
		for j in old_graph.size():
			#if i is strictly cornered by j
			if old_graph.strictly_corners(j, i): 
				retract_vertex(i)

func retract_corners():
	var old_graph : GraphData = dup()
	#check each vertex for corners
	for i in old_graph.size():
		for j in old_graph.size():
			#if i is cornered by j
			if old_graph.corners(j, i): 
				retract_vertex(i)

func retract_twins():
	var old_graph : GraphData = dup()
	#check each vertex for twins
	for i in old_graph.size():
		for j in i:
			#if i and j are twins
			if old_graph.are_twins(j, i): 
				retract_vertex(i)

func neighborhood(v : int):
	return graph[v]


func is_reflexive():
	for i in graph.size():
		if not graph[i][i]: return false
	return true

func is_undirected():
	for i in graph.size():
		for j in i:
			if graph[j][i] != graph[i][j]: return false
	return true

func is_clique():
	#create empty array for reference
	var empty_neighborhood : Array = []
	for i in graph.size():
		empty_neighborhood.append(false)
	
	#compare all neighborhoods
	for i in graph.size():
		for j in i:
			#only compare non-empty neighborhoods
			if graph[j] != empty_neighborhood and graph[i] != empty_neighborhood:
				#return false if neighborhoods are not equivalent
				if graph[j] != graph[i]: return false
	#all neighborhoods are equivalent
	return true

func is_connected_graph():
	var identity = create_identity(graph.size())
	var sum = add(identity, self)
	#uncertain about definition
#	sum.make_undirected()
	var product = create_identity(size())
	for i in sum.size() - 1:
		product = product.multiply(sum)
	#check each entry
	for i in product.size(): for j in product.size():
#		print(product.graph[i][j])
		if not product.graph[i][j]: return false
	#must be connected
	return true

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
	var new_graph_data = GraphData.new(size())
	new_graph_data.graph = graph.duplicate(true)
	return new_graph_data


func add(g2 : GraphData = self, g1 : GraphData = self):
	assert(g1.size() == g2.size())
	var sum = GraphData.new(g1.size())
	#sum each entry
	for i in g1.size(): for j in g1.size():
		sum.graph[i][j] = bool(int(g1.graph[i][j]) + int(g2.graph[i][j]))
	return sum

func multiply(g2 : GraphData = self, g1 : GraphData = self):
	assert(g1.size() == g2.size())
	var product = GraphData.new(graph.size())
	#multiply and add for each entry
	for i in g1.size(): for j in g1.size():
		var p = 0
		for m in g1.size():
			p += int(g1.graph[i][m]) * int(g2.graph[m][j])
		product.graph[i][j] = bool(p)
	return product

func square():
	return multiply(self, self)

func create_identity(len : int):
	var new_graph_data = GraphData.new(len)
	new_graph_data.make_reflexive()
	return new_graph_data
