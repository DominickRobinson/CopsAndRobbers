extends Control


@export var graph_data : GraphData

@export var graph_text_display : Label

@export var remove_vertex_index : SpinBox

@export var add_edge_start_index : SpinBox
@export var add_edge_end_index : SpinBox
@export var remove_edge_start_index : SpinBox
@export var remove_edge_end_index : SpinBox

@export var save_file_dialog : FileDialog
@export var load_file_dialog : FileDialog



func _ready():
	display_graph()
	save_file_dialog.file_selected.connect(save_graph)
	load_file_dialog.file_selected.connect(load_graph)


func display_graph():
	graph_text_display.text = graph_data.display()


func make_reflexive():
	graph_data.make_reflexive()
	display_graph()

func make_undirected():
	graph_data.make_undirected()
	display_graph()

func add_vertex():
	graph_data.add_vertex()
	display_graph()

func remove_vertex():
	var vtx = remove_vertex_index.value
	graph_data.remove_vertex(vtx)
	display_graph()

func add_edge():
	var start_vtx = add_edge_start_index.value
	var end_vtx = add_edge_end_index.value
	graph_data.add_edge(start_vtx, end_vtx)
	display_graph()

func remove_edge():
	var start_vtx = add_edge_start_index.value
	var end_vtx = add_edge_end_index.value
	graph_data.remove_edge(start_vtx, end_vtx)
	display_graph()

func fill_graph():
	graph_data.fill()
	display_graph()

func clear_graph():
	graph_data.clear()
	display_graph()

func invert_graph():
	graph_data.invert()
	display_graph()


func save_graph_button():
	save_file_dialog.visible = true

func load_graph_button():
	load_file_dialog.visible = true


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
	
	print("Before")
	print(array)
	array.pop_back()
	print("\nAfter")
	print(array)
	
	graph_data.graph = array
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
