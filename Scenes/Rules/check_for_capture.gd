extends State

var players : 
	get:
		return get_players()

var cops : 
	get: return get_tree().get_nodes_in_group("Cops")

var robbers : 
	get: return get_tree().get_nodes_in_group("Robbers")



func _on_state_entered():
	super._on_state_entered()
	
	for c in cops:
		c = c as Cop
		if not is_instance_valid(c): 
			continue
		if not is_instance_valid(c.current_vertex): 
			continue
		for r in robbers:
			r = r as Robber
			if not is_instance_valid(r): 
				continue
			if not is_instance_valid(r.current_vertex): 
				continue
			if c.current_vertex == r.current_vertex and not r.captured:
				c.capture(r)
	
	
	
	go_to_next_state()

func get_players():
	return get_tree().get_nodes_in_group("Players")
