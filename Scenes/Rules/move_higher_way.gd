extends State

@export var agent : Agent

func _ready():
	super._ready()
	
	assert(agent.is_robber())

func _on_state_entered():
	super._on_state_entered()
	
	assert(is_instance_valid(agent))
	
	if agent.captured:
		go_to_next_state()
		return
	
	var vertices
	
	if not is_instance_valid(agent.current_vertex):
		vertices = graph.get_vertices()
	else:
		vertices = agent.current_vertex.get_neighbors()
	
	
	agent.arrived.connect(go_to_next_state)
	
	
	await get_tree().create_timer(0.5).timeout
	
	#chooses random neighbor to move to
	var move : Vertex
	


func _on_state_exited():
	super._on_state_exited()
	
	if is_instance_valid(agent): agent.arrived.disconnect(go_to_next_state)
