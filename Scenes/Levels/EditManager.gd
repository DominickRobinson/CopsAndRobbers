extends Node


@export var graph : Graph
@export var undo_button : Button
@export var redo_button : Button

# Variables
var edits : Array = []
var undo_edits : Array = []



func _ready():
	graph.changed.connect(add_edit)
	graph.vertex_moved.connect(add_edit)
	add_edit()


func _unhandled_input(event):
	if Input.is_action_just_pressed("undo"):
		if not undo_button.disabled:
			undo_button.pressed.emit()
	
	if Input.is_action_just_pressed("redo"):
		if not redo_button.disabled:
			redo_button.pressed.emit()



# Add a new edit to the array
func add_edit() -> void:
	graph.changed.disconnect(add_edit)
	var edit = graph.get_graph_as_JSON()
	edits.append(edit)
	clear_redo_edits()
	graph.changed.connect(add_edit)
	
	print_edits()
	
	adjust_buttons()


# Undo the last edit
func undo() -> void:
	undo_button.disabled = true
	graph.changed.disconnect(add_edit)
	if edits.size() > 1:
		var last_edit = edits.pop_back()
		undo_edits.append(last_edit)
		
		var new_state = edits[edits.size()-1]
		await graph.make_graph_from_JSON(new_state)
	else:
		pass
#		print("Cannot undo further.")
	
	await graph.refresh()
	graph.changed.connect(add_edit)
	
	
	print_edits()
	undo_button.disabled = false
	
	adjust_buttons()


# Redo the last undone edit
func redo() -> void:
	redo_button.disabled = true
	graph.changed.disconnect(add_edit)
	if undo_edits.size() > 0:
		var edit_to_redo : String = undo_edits.pop_back()
		edits.append(edit_to_redo)
		await graph.make_graph_from_JSON(edit_to_redo)
	else:
#		print("Nothing to redo.")
		pass
	
	await graph.refresh()
	graph.changed.connect(add_edit)
	
	print_edits()
	
	redo_button.disabled = false
	
	adjust_buttons()

# Clear redo history
func clear_redo_edits() -> void:
	undo_edits.clear()


func print_edits():
	return
	
	print("Edits:", edits.size())
	for str in edits:
		var dict = JSON.parse_string(str)
		var a = dict["adjacency_matrix"]
		print("   ", a)
	print("Undo edits: ", undo_edits.size())
	for str in undo_edits:
		var dict = JSON.parse_string(str)
		var a = dict["adjacency_matrix"]
		print("   ", a)
	print("")


func adjust_buttons():
	undo_button.disabled = edits.size() < 2
	redo_button.disabled = undo_edits.size() == 0

