extends Node

signal cop_win


func _process(delta):
	var robbers = get_tree().get_nodes_in_group("Robbers")
	
	if robbers.size() == 0:
		cop_win.emit()
		process_mode = Node.PROCESS_MODE_DISABLED
