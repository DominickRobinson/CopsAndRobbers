extends State


func _ready():
	super._ready()
	
	assert(agent.is_cop())


func _on_state_entered():
	super._on_state_entered()
	
	assert(is_instance_valid(agent))
	
	if agent.captured:
		go_to_next_state()
		return
	
	var neighbors : Array
	
	if not is_instance_valid(agent.current_vertex):
		neighbors = graph.get_vertices()
	else:
		neighbors = agent.get_vertex().get_neighbors()
	
	
	
	agent.arrived.connect(go_to_next_state)
	
	#updates mappings?
#	graph.get_Fk_mappings()
	
	#chooses random neighbor to move to
	var move : Vertex = null
	
	#first move
	if not is_instance_valid(agent.current_vertex):
		move = neighbors[0]
		for v in neighbors:
			v = v as Vertex
			if v.strict_corner_ranking > move.strict_corner_ranking:
				move = v
		agent.move_to(move)
		return
	
	#not copwin graph
	if not graph.is_copwin():
		agent.move_to(neighbors[0])
		return
	
	var mappings = graph.get_mappings()
	
	#find new target
	if target == null:
		var robbers = get_tree().get_nodes_in_group("Robbers")
		if robbers.size() == 0:
			agent.move_to(neighbors[0])
			return
		else:
			target = robbers[randi() % robbers.size()]
	
	agent.target = target
	
	var moves = []
	#in each mapping, check if robber shadow is found
#	print("Mappings: ", mappings)
	for mapping in mappings:
		for nbor in neighbors:
			if nbor in mapping[target.get_vertex()]:
				moves.append(nbor)
#				break
	
	
#	print("\n\n\nMoves first found: ")
	#gets minimum scr in possible moves
	var minimum_scr = graph.size()
	for m in moves:
		m = m as Vertex
#		print(" ", m.index)
		if m.strict_corner_ranking < minimum_scr:
			minimum_scr = m.strict_corner_ranking
	
#	print("Minimum scr option: ", minimum_scr)
	
	#removes vertices with non-minimum scr
	var new_moves = []
	for m in moves:
		m = m as Vertex
#		print(" vertex: ", m.index, " - scr: ", m.strict_corner_ranking)
		if m.strict_corner_ranking == minimum_scr:
#			moves.erase(m)
			new_moves.append(m)
	
	moves = new_moves
#	print("Moves: ", moves)
	
#	print("Moves after removing non-minima:")
#	for m in moves:
#		print(" ", m.index)
	
	move = moves.pick_random()
#	print("Move selected: ", move.index)
	
	#if not found in any, then go to highest ranking neighbor
	if move == null:
		move = neighbors[0]
		for nbor in neighbors:
			nbor = nbor as Vertex
			if nbor.strict_corner_ranking > move.strict_corner_ranking:
				move = nbor
	
	#once capture target
	if target in move.get_occupents():
		target = null
	
#	await get_tree().create_timer(0.5).timeout
	
	agent.move_to(move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
