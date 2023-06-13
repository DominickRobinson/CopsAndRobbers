extends Node

signal cop_win


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	
	await get_parent().game_start
	

	for r in get_parent().robbers:
		r = r as Agent
		r.caught.connect(check_for_cop_win)



func check_for_cop_win():
	
	var robbers = get_tree().get_nodes_in_group("Robbers")
	
	var win = true
	for r in robbers:
		r = r as Agent
		if not r.captured:
			win = false
	
	if win: cop_win.emit()
