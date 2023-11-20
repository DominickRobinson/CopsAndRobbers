class_name DoTheThingButton
extends Button

signal thing_done

@export var how_many_times := 10
@export var auto_start := false

var graph : Graph

var progress : int = 0


func _ready():
	graph = get_tree().get_nodes_in_group("Graphs")[0]
	
	pressed.connect(do_the_thing)
	
	if auto_start:
		pressed.emit()

func do_the_thing():
	disabled = true
	progress = 0
	
	await graph.empty(false)
	
	for i in how_many_times - 1:
		var prob = float(i+1)/float(how_many_times)
		prob = 0.5
		print("prob: ", prob)
		await graph.add_strict_corner(Vector2(0,0), prob, false)
	
	progress = 40
	
	await graph.refresh()
	await get_tree().create_timer(0).timeout
	await graph.set_positions_by_ranking(false)
	await graph.retract_twins(false)
	await graph.refresh()
	graph.create_force_diagram()
	
	progress = 90
	
	await graph.vertices_repositioned
	
	
	await graph.refresh()
	
	var lower_left = graph.vertices[0].global_position
	var upper_right = graph.vertices[0].global_position
		
	var avg = Vector2.ZERO
	for v in graph.vertices:
		var pos = v.global_position
		avg += pos
		
		lower_left.x = min(lower_left.x, pos.x)
		lower_left.y = min(lower_left.y, pos.y)
		upper_right.x = max(upper_right.x, pos.x)
		upper_right.y = max(upper_right.y, pos.y)
		
	avg /= graph.size()
	
	var frame_size = upper_right - lower_left
	frame_size += Vector2.ONE * 200 * log(graph.size())
	
	var vp_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),
							ProjectSettings.get_setting("display/window/size/viewport_height"))
	print(vp_size)
	
	var new_zoom = Vector2(vp_size.x / frame_size.x, 
							vp_size.y / frame_size.y)
	
	
	graph.camera.zoom = Vector2.ONE * min(new_zoom.x, new_zoom.y)
	
	
#	graph.camera.global_position = avg
	graph.camera.global_position = (upper_right + lower_left)/2
	
	
	await graph.refresh()
	await graph.refresh_vertices()
	
	
	graph.changed.emit()
	disabled = false
	thing_done.emit()
