class_name GraphDataEditor
extends Node


@export var graph_data : GraphData

@export var graph_text_display : Label

@export var vertex_index : SpinBox

@export var edge_start_index : SpinBox
@export var edge_end_index : SpinBox

@export var save_file_dialog : FileDialog
@export var load_file_dialog : FileDialog

var edits : Array


func _ready():
	display_graph()
	edits = [graph_data.graph.duplicate(true)]
	
	save_file_dialog.file_selected.connect(graph_data.save_graph)
	load_file_dialog.file_selected.connect(load_graph)


func display_graph():
	graph_text_display.text = graph_data.display()

func make_reflexive():
	graph_data.make_reflexive()
	display_graph()
	edit_graph()

func make_undirected():
	graph_data.make_undirected()
	display_graph()
	edit_graph()

func add_vertex():
	graph_data.add_vertex()
	display_graph()
	edit_graph()
	
	vertex_index.max_value = graph_data.size() - 1

func remove_vertex(vtx = vertex_index.value):
	graph_data.remove_vertex(vtx)
	display_graph()
	edit_graph()
	
	vertex_index.max_value = graph_data.size() - 1


func retract_vertex(vtx = vertex_index.value):
	graph_data.retract_vertex(vtx)
	display_graph()
	edit_graph()

func add_edge(start_vtx : int = edge_start_index.value, end_vtx : int = edge_end_index.value):
	graph_data.add_edge(start_vtx, end_vtx)
	display_graph()
	edit_graph()


func remove_edge(start_vtx : int = edge_start_index.value, end_vtx : int = edge_end_index.value):
	graph_data.remove_edge(start_vtx, end_vtx)
	display_graph()
	edit_graph()

func fill_graph():
	graph_data.fill()
	display_graph()
	edit_graph()

func clear_graph():
	graph_data.clear()
	display_graph()
	edit_graph()

func invert_graph():
	graph_data.invert()
	display_graph()
	edit_graph()

func square_graph():
	graph_data.square()
	display_graph()
	edit_graph()


func retract_strict_corners():
	graph_data.retract_strict_corners()
	display_graph()
	edit_graph()

func retract_corners():
	graph_data.retract_corners()
	display_graph()
	edit_graph()


func save_graph_button():
	save_file_dialog.visible = true

func load_graph_button():
	load_file_dialog.visible = true






func edit_graph():
	set_spinbox_max()
	var new_edit : Array = graph_data.graph.duplicate(true)
	
	#if first edit or if this edit is not same as last edit
	if edits.size() == 1:
		edits.push_back(new_edit)
		return
	
	if not graphs_equal(new_edit, edits[-1]):
		edits.push_back(new_edit)
		return
	

func print_edits():
	print("Edits: ", edits.size())
	for i in edits.size():
		print(i)
		print(edits[i])

func undo():
	if edits.size() > 1:
		edits.pop_back()
		graph_data.graph = edits[-1].duplicate(true)
	elif edits.size() == 1:
		graph_data.graph = edits[0].duplicate(true)
#		print(4)
	
	display_graph()




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


func set_spinbox_max(new_max : int = graph_data.size() - 1):
	var spinboxes = [vertex_index, edge_start_index, edge_end_index]
	
	for s in spinboxes:
		s = s as SpinBox
		s.min_value = 0
		s.max_value = new_max


func load_graph(path : String):
	graph_data.load_graph(path)
	edit_graph()
	display_graph()













#func saveArrayToCSV(arrayData: Array, filePath: String):
#	var csvString := ""
#
#	# Convert array of arrays of booleans to CSV string
#	for row in arrayData:
#		var rowString := ""
#		for value in row:
#			rowString += str(value) + ","
#		rowString = rowString.substr(0, rowString.length() - 1) # Remove trailing comma
#		csvString += rowString + "\n"
#
#	# Save CSV string to file
#	var file := File.new()
#	file.open(filePath, File.WRITE)
#	file.store_string(csvString)
#	file.close()
#
#
#func loadCSVToArray(filePath: String) -> Array:
#	var arrayData := []
#
#	# Read the .csv file
#	var file := File.new()
#	if file.open(filePath, File.READ) == OK:
#		var fileContents := file.get_as_text()
#		file.close()
#
#		# Split the file contents into rows
#		var rows := fileContents.split("\n")
#
#		# Convert string values to booleans and create the array of arrays
#		for row in rows:
#			var columns := row.split(",")
#
#			var booleanRow := []
#			for column in columns:
#				# Convert string value to boolean
#				var value := column.strip_edges() # Remove leading and trailing whitespaces
#				var booleanValue := value.to_bool()
#
#				booleanRow.append(booleanValue)
#
#			arrayData.append(booleanRow)
#	else:
#		print("Failed to open file:", filePath)
#
#	return arrayData
