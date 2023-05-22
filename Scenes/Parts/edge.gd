class_name Edge
extends GraphComponent

#start vertex of directed edge
@export var start_vertex : Vertex
		

#end vertex of directed edge
@export var end_vertex : Vertex 


@onready var line = $Line2D
@onready var path = $Path2D

@onready var area = $Area2D/CollisionShape2D

func _ready():
	#anchor edge at origin for consistency
	global_position = Vector2(0,0)
	
	#draws only if both vertices are present
	draw(vertices_exist())


func draw(show=true):
	if show:
	#draw line
		line.clear_points()
		line.add_point(start_vertex.global_position)
		line.add_point(end_vertex.global_position)
		
		#draw area
		area.shape.a = start_vertex.global_position
		area.shape.b = end_vertex.global_position
	else:
		#hide line
		line.clear_points()
		#hide area
		area.shape.a = Vector2.ZERO
		area.shape.b = Vector2.ZERO


func vertices_exist():
	return (start_vertex != null) and (end_vertex != null)

func contains_vertex(vertex : Vertex):
	return start_vertex == vertex or end_vertex == vertex

func remove():
	queue_free()
