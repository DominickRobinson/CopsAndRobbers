extends Button

@export var text_edit : TextEdit

func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	if not is_instance_valid(text_edit):
		return
	if text_edit.text == "":
		return
	
	var graph = Globals.get_graph()
	
	for c in Globals.get_all_children(graph):
		c = c as Node
		c.set_owner(graph)
	
	var path = "res://Scenes/Graphs/" + text_edit.text + ".tscn"
	Globals.save_node_as_packed_scene(graph, path)
