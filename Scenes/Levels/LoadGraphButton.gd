extends Button


@export var graph_path : String = "res://Graphs/1421.json"


func _ready():
	text = graph_path


func get_graph_path():
	return graph_path


func _on_load_file_dialog_file_selected(path):
	graph_path = path
	text = path