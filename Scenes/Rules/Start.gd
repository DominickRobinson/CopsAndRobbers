extends State

@export var player : Player


func _on_state_entered():
	super._on_state_entered()
	
	for v in graph.get_vertices():
		v = v as Vertex
		v.selected.connect(player.move_to.bind(v))
		v.selectable = true
	
	
	if is_instance_valid(player): player.arrived.connect(go_to_next_state)
	


func _on_state_exited():
	super._on_state_exited()
	
	for v in graph.vertices:
		v = v as Vertex
		v.selected.disconnect(player.move_to)
		v.selectable = false
	
	if is_instance_valid(player): player.arrived.disconnect(go_to_next_state)
