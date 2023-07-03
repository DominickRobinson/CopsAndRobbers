class_name Edge
extends GraphComponent


#start vertex of directed edge
var start_vertex : Vertex

#end vertex of directed edge
var end_vertex : Vertex 

@export_group("Properties")
var reflexive : bool = false
@export var directed : bool = true
@export var collision_thickness_px : int = 10

@export_group("Nodes")
@export var line : Line2D
@export var loop_sprite : Sprite2D
@export var loop_line : Line2D
#@export var path :Path2D
var area_shape 

@export_group("Textures")
@export var directed_edge_texture : Texture
@export var undirected_edge_texture : Texture
@export var reflexive_edge_texture : Texture



func _ready():
	area_shape = area.get_children()[0]
	
	reflexive = start_vertex == end_vertex
	
	if reflexive:
		loop_sprite.texture = reflexive_edge_texture
#		loop_line.hide()
		line.hide()
#		path.hide()
		loop_sprite.show()
	else:
		loop_sprite.hide()
#		loop_line.hide()
		line.show()
#		path.show()
		if directed:
			line.texture = directed_edge_texture
		else: 
			line.texture = undirected_edge_texture
	
	super._ready()
	
	#anchor edge at origin for consistency
	position = Vector2(0,0)
	
#	if is_instance_valid(start_vertex):
#		start_vertex.moved.connect(draw)
#	if is_instance_valid(end_vertex):
#		end_vertex.moved.connect(draw)

func _process(delta):
	if can_draw():
		draw()
	else:
		erase()
	


func draw():
	
	
	if start_vertex != end_vertex:
		position = Vector2.ZERO

		
		line.clear_points()
		#draw line
		line.add_point(start_vertex.position)
		line.add_point(end_vertex.position)
		
		area_shape.shape.points = get_rectangle_points(line.points)
#		print(self, " - ", area_shape.shape.points)
		
#		path.curve.clear_points()
#		for p in line.points:
#			path.curve.add_point(p)
		
		
	else:
		position = start_vertex.position



func erase():
	line.clear_points()
#	path.curve.clear_points()



func vertices_exist():
	var result =  (start_vertex != null) and (end_vertex != null)
#	print("Vertices exist: ", result)
	return result

func contains_vertex(vertex : Vertex):
	return start_vertex == vertex or end_vertex == vertex

func can_draw():
	return is_instance_valid(start_vertex) and is_instance_valid(end_vertex)



func get_rectangle_points(points:PackedVector2Array):
	assert(points.size() == 2)
	
	var a = points[0]
	var b = points[1]
	
	var angle = (points[1] - points[0]).angle()
	
	var offset = Vector2.RIGHT.rotated(angle + PI/2) * collision_thickness_px/2
	
	var p1 = a - offset
	var p2 = a + offset
	var p3 = b + offset
	var p4 = b - offset
	
	var result = PackedVector2Array([p1,p2,p3,p4])
#	print(self, " - ", result)
	return result
