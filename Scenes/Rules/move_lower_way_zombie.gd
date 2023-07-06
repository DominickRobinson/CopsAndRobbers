extends State

@export var agent : Agent

@export var target : Agent

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
		neighbors = agent.current_vertex.get_neighbors()
	
	print("Neighbors: ", neighbors)
	
	agent.arrived.connect(go_to_next_state)
	
	
	await get_tree().create_timer(0.5).timeout
	
	
	graph.get_Fk_mappings()

	
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
	
	var mappings = graph.get_Fk_mappings()
	
	#find new target
	if target == null:
		var robbers = get_tree().get_nodes_in_group("Robbers")
		if robbers.size() == 0:
			agent.move_to(neighbors[0])
			return
		else:
			target = robbers[randi() % robbers.size()]
	
	
	#in each mapping, check if robber shadow is found
	for mapping in mappings:
		if move != null:
			break
		for nbor in neighbors:
			if nbor in mapping[target.current_vertex]:
				move = nbor
				break
	
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
	
	agent.move_to(move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
