extends Button

@export var how_many_times := 5

var graph : Graph

func _ready():
	graph = get_tree().get_nodes_in_group("Graphs")[0]
	
	pressed.connect(do_the_thing)

func do_the_thing():
	for i in how_many_times - 1:
		await graph.add_strict_corner(Vector2(0,0), 0.5, false)
	
	await graph.refresh_vertices()
	await get_tree().create_timer(0).timeout
	await graph.set_positions_by_ranking(false)
	
	graph.changed.emit()
	
