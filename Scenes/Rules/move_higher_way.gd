extends State

@export var agent : Agent
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
	
	
#	await get_tree().create_timer(0.5).timeout
	
	#chooses random neighbor to move to
	var move : Vertex = null
	
	#gets all retraction mappings
	var mappings = graph.get_mappings()
	
	
	
	#debug print statements
	var output = "r = "
	if is_instance_valid(agent.get_vertex()):
		output += str(agent.get_vertex().index)
	else:
		output += "-1"
	output += "\nc = "
	for c in cops:
		if is_instance_valid(c.get_vertex()):
			output += str(c.get_vertex().index) + ","
		else: 
			output += "-1,"
	output = output.left(-1)
	output += "\n"
	
	for i in mappings.size():
		var k = mappings.size()-i
		var mapping = mappings[k - 1]
		if move == null:
			#check if each neighbor...
			for nbor in neighbors:
				nbor = nbor as Vertex
				var k_proj_safe = false
				#check if nbor is in projection of cop 
				for c in cops:
					c = c as Agent
					for c_prime in mapping[c.get_vertex()]:
						c_prime = c_prime as Vertex
						if not (nbor in c_prime.get_neighbors()):
							k_proj_safe = true
							
				if k_proj_safe and nbor.strict_corner_ranking >= k and move == null:
					move = nbor
					break
	
	if move == null:
		move = neighbors[randi() % neighbors.size()]
		var cop_vertices = []
		for c in cops:
			cop_vertices.append(c.get_vertex())
		while move in cop_vertices:
			move = neighbors[randi() % neighbors.size()]
	
#	await get_tree().create_timer(0.5).timeout
	
	agent.move_to(move)


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
