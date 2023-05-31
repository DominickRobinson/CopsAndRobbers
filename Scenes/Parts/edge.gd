class_name Edge
extends GraphComponent


#start vertex of directed edge
var start_vertex : Vertex

#end vertex of directed edge
var end_vertex : Vertex 


@export var line : Line2D
@export var path :Path2D
@export var path_follow : PathFollow2D

@export var label2D : Node2D
@export var label : Label



func _ready():
	super._ready()
	#anchor edge at origin for consistency
	global_position = Vector2(0,0)





func _process(delta):
	label2D.global_rotation = 0
	path_follow.progress_ratio = 0.75
	
	if can_draw():
		draw()
	else:
		erase()
	


func draw():
	line.clear_points()
	#draw line
	line.add_point(start_vertex.global_position)
	line.add_point(end_vertex.global_position)
	
	path.show()
	path.curve.clear_points()
	for p in line.points:
		path.curve.add_point(p)
	
	label.text = str(start_vertex.index) + " -> " + str(end_vertex.index)




func erase():
	line.clear_points()
	path.curve.clear_points()
	path.hide()
	label.text = ""



func vertices_exist():
	var result =  (start_vertex != null) and (end_vertex != null)
	print("Vertices exist: ", result)
	return result

func contains_vertex(vertex : Vertex):
	return start_vertex == vertex or end_vertex == vertex

func can_draw():
	return is_instance_valid(start_vertex) and is_instance_valid(end_vertex)
