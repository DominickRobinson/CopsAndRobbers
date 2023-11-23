extends State

var best_first_move = false

func _ready():
	super._ready()
	
	assert(agent.is_cop())


func _on_state_entered():
	super._on_state_entered()
	
	
	if agent.captured:
		go_to_next_state()
		return
	
	var neighbors : Array
	
	if not is_instance_valid(agent.current_vertex):
		neighbors = graph.get_vertices()
	else:
		neighbors = agent.current_vertex.get_neighbors()
	
	
	agent.arrived.connect(go_to_next_state)
	
	
	#find new target
	if target == null:
		var robbers = get_tree().get_nodes_in_group("Robbers")
		if robbers.size() == 0:
			agent.move_to(neighbors[0])
			return
		else:
			target = robbers[randi() % robbers.size()]
	

	
	#chooses random neighbor to move to
	var move : Vertex = null
	
	# first move
	if not is_instance_valid(agent.current_vertex):
		# choose "best" first move
		if best_first_move:
			move = neighbors[0]
			for v in neighbors:
				v = v as Vertex
				if v.strict_corner_ranking > move.strict_corner_ranking:
					move = v
			agent.move_to(move)
			return
			
		# random first move
		else:
			move = neighbors.pick_random()
			agent.move_to(move)
			return
	
	
	# if target not on vertex yet
	if target.current_vertex == null:
		move = agent.current_vertex.neighbors.pick_random()
		agent.move_to(move)
		return
	
	move = graph.get_closest_neighbor_to_vertex(agent.current_vertex, target.current_vertex)
	
	
	#once capture target
	if target in move.get_occupents():
		target = null
	
	agent.move_to(move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
