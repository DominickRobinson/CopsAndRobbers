extends State


var cops : Array :
	get:
		return get_tree().get_nodes_in_group("Cops")

func _ready():
	super._ready()
	
	assert(agent.is_robber())

func _on_state_entered():
	await super._on_state_entered()
	
	assert(is_instance_valid(agent))
	
	if agent.captured:
		go_to_next_state()
		return
	
	var neighbors
	
	if not is_instance_valid(agent.get_vertex()):
		neighbors = graph.get_vertices()
	else:
		neighbors = agent.get_neighbors()
	
	
	agent.arrived.connect(go_to_next_state)
	
	
	#chooses random neighbor to move to
	var move : Vertex = null
	
	
	# only works for 1 cop
	if not is_instance_valid(agent.get_vertex()):
		move = graph.get_farthest_vertex_from_vertex(cops[0].get_vertex())
	else:
		move = graph.get_farthest_neighbor_away_from_vertex(agent.get_vertex(), cops[0].get_vertex())
	
	
	
	
	agent.move_to(move)
	
	var first_placement = not already_entered
	
	await agent.arrived
	if move.is_top or first_placement:
		agent.laugh()


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
