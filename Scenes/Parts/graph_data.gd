#@tool
class_name GraphData
extends Node

signal changed(old_graph:Array, new_graph:Array)

@export var initial_size : int = 0

var graph : Array = []

var strict_corner_ranking : Array
var corner_ranking : Array


var old:Array = graph.duplicate(true)
var new:Array

func _init(s:int=initial_size):
	initial_size = s
	initial_size = clamp(initial_size, 0, 99)
	
	for i in initial_size:
		graph.append([])
		for j in initial_size:
			graph[i].append(false)


func _process(_delta):
	#checks if graph data has changed
	
	
	if old != graph:
#		strict_corner_ranking = get_strict_corner_ranking(self)
		new = graph.duplicate(true)
		changed.emit(old, new)
		old = new.duplicate(true)


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
	
	output += "SCR: " + str(get_strict_corner_ranking())
	
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
	if not is_valid_vertex(v) or graph.size() == 0: return
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
	for i in graph.size():
		if not graph[v1][i] and graph[v2][i]: 
			return false
	#checks if v1 and v2 have exact same neighbors
	if graph[v1] == graph[v2]: 
		return false
	#vertex v1 must go to vertex v2
	if not graph[v1][v2]:
		return false
	#v1 must strictly corner v2
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
	var new_graph_data = GraphData.new()
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

func create_identity(s : int):
	var new_graph_data = GraphData.new(s)
	new_graph_data.make_reflexive()
	return new_graph_data

func get_max_ranking(G:GraphData=self):
	#strict corner ranking
	var scr = G.get_strict_corner_ranking()
	
	#number of graphs in our result
	var max_ranking = scr.max()
	#add one more graph if it is robber win
	if scr.has(-1):
		max_ranking += 1
	
	return max_ranking

func get_strict_corner_ranking() -> Array:
	#initialize array
	var ranking_array : Array = []
	
	for i in graph.size():
		ranking_array.append(0)
	
	
#	if not is_connected_graph() or not is_reflexive() or not is_undirected():
#		ranking_array = set_zeroes_in_array_to_val(ranking_array, -1)
#		return ranking_array
	
	var current_ranking = 1
		
	var old_g : GraphData = dup()
	var new_g  : GraphData = dup()
	
	for i in old_g.size():
		if is_isolated_vertex(old_g.graph, i):
			ranking_array[i] = -1
	
	while array_contains_zero(ranking_array):
		old_g = new_g.dup()
		new_g.retract_strict_corners()
		
		#checks if left with clique
		if old_g.is_clique():
			ranking_array = set_zeroes_in_array_to_val(ranking_array, current_ranking)
			break
		
		#checks if no more strict corners
		if graphs_equal(old_g.graph, new_g.graph): 
			ranking_array = set_zeroes_in_array_to_val(ranking_array, -1)
			break
		

		
		#checks if a vertex was just retracted
		for i in old_g.size():
			if not is_isolated_vertex(old_g.graph, i) and is_isolated_vertex(new_g.graph, i):
				ranking_array[i] = current_ranking
		
		current_ranking += 1
	
	return ranking_array

func get_strict_corner_retractions() -> Array:
	#output, beginning with the identity
	var Gk_s = []
	
	#start at first graph
	var current_k = 1
	
	#get max corner ranking
	var max_ranking = get_max_ranking()
	
	var g = dup()
	
	while current_k < max_ranking:
		Gk_s.append(g.dup())
		g.retract_strict_corners()
		current_k += 1
	
	return Gk_s


func get_G_k(k:int, G: GraphData = self):
	if k == 1:
		return G
	else:
		assert(k>1)
		return get_G_k(k-1, G.retract_strict_corners())

func array_to_set(array:Array)->Array:
	var result = []
	for a in array:
		if not result.has(a): result.append(a)
	result.sort()
	return result

func f_k(vtxs:Array, G_k:GraphData=self) -> Array:
	var result = []
	
	for v in vtxs:
		for i in G_k.size():
			if G_k.strictly_corners(i, v):
				result.append(i)
	
	if result.size() == 0:
		return vtxs
	
	return result
	

func F_k(k:int, vtxs:Array, G:GraphData = self) -> Array:
	#base case: k = 1
	if k == 1:
		return array_to_set(vtxs)
	else:
		var G_retracted = G.dup()
		G_retracted.retract_strict_corners()
		var output = G_retracted.F_k(k-1, f_k(vtxs, G))
		return array_to_set(output)

func get_F_k_mapping(k:int, G:GraphData=self) -> Dictionary:
	var result = {}
	for i in G.size():
		result[i] = G.F_k(k, [i])
	return result

func get_F_k_mappings(G:GraphData=self) -> Array:
	if G.size() == 0:
		return []
	var result = []
	var max_ranking = get_max_ranking()
	for k in range(1, max_ranking+1):
		var mapping = G.get_F_k_mapping(k)
		result.append(mapping)
	return result

func print_F_k_mappings(G:GraphData=self):
	
	if G.size() == 0:
		return
	
	var mappings = get_F_k_mappings(G)
	for i in mappings.size():
		print("F(", i+1, "): ", mappings[i])





func is_cop_win():
	var scr = get_strict_corner_ranking()
	for i in scr.size():
		if scr[i] == -1:
			return false
	return true


func array_contains_zero(array:Array)->bool:
	for a in array:
		if a == 0:
			return true
	return false

func set_zeroes_in_array_to_val(array:Array, val:int)->Array:
	for i in array.size():
		if array[i] == 0: array[i] = val
	return array

func is_isolated_vertex(array:Array = graph, vtx:int=0)->bool:
	for i in array.size():
		if array[vtx][i]: return false
		if array[i][vtx]: return false
	return true

func save_graph(path : String):
#	print("saving ", path.get_extension())
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var array = self.bool_to_int()
#	var array = graph_data.graph
	
	for i in array.size():
		var row = PackedStringArray(array[i])
		match path.get_extension():
			"csv":
				save_file.store_csv_line(row, ",")
			"tsv":
				save_file.store_csv_line(row, "\t")



func load_graph(path : String):
	var load_file = FileAccess.open(path, FileAccess.READ)
	
	var array = []
	var i = 0
	
	while !load_file.eof_reached():
		array.append([])
		var row
		match path.get_extension():
			"csv":
				row = load_file.get_csv_line(",")
			"tsv":
				row = load_file.get_csv_line("\t")
#		print(row)
		for j in row.size():
#			print(str(int(row[j])))
			array[i].append(int(row[j]))
		i += 1
	
	array.pop_back()
	
	graph = array




func graphs_equal(g1 : Array, g2 : Array):
	#must have same number of columns
	if g1.size() != g2.size(): return false
	
	for i in g1.size():
		#each row must have same size
#		print("Row i: ", g1[i], " vs. ", g2[i])
		if g1[i] != g2[i]: return false
#		if g1[i].size() != g2[i].size(): return false
#		for j in g1.size():
#			#must have same value within each cell
#			if g1[i][j] != g2[i][j]: return false
	
#	print("graphs equal")
	return true
