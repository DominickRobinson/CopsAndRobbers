extends Button

@export var how_many_times := 10

var graph : Graph

func _ready():
	graph = get_tree().get_nodes_in_group("Graphs")[0]
	
	pressed.connect(do_the_thing)

func do_the_thing():
	for i in how_many_times - 1:
		await graph.recalculate_strict_corner_ranking()
		await graph.add_strict_corner()
	
	await graph.recalculate_strict_corner_ranking()
	
	await graph.set_positions_by_ranking()
