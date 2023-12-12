class_name MultiClick
extends Node2D

signal highlighted(vertices:Array[Vertex])

@onready var polygon = $Polygon2D
@onready var collision_polygon = $Area2D/CollisionPolygon2D
@onready var area = $Area2D

var click_global_position : Vector2
var selecting = false

var can_erase = false

var highlighted_vertices : Array[Vertex] = [] :
	set(value):
		highlighted_vertices = value
		for v in highlighted_vertices:
			v.highlight()



func _unhandled_input(_event):
	if Input.is_action_just_pressed("highlight"):
		selecting = true
		click_global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("highlight") and can_erase:
		selecting = false
		await erase()
#		highlighted.emit(selected_vertices)
#		emit_signal.bind("highlighted", selected_vertices)




func _process(_delta):
	
#	print_highlighted_vertices()
	if selecting:
#		print("Selecting... ", area.get_overlapping_areas())
		draw_highlight()
	else:
#		print("Not selecting... ", area.get_overlapping_areas())
		pass


func draw_highlight():
	can_erase = true
	# get array of points in highlight rectangle
	var points = []
	
	var current_mouse_global_position = get_global_mouse_position()
	
	points.append(click_global_position)
	points.append(Vector2(current_mouse_global_position.x, click_global_position.y))
	points.append(current_mouse_global_position)
	points.append(Vector2(click_global_position.x, current_mouse_global_position.y))
	
	polygon.polygon = PackedVector2Array(points)
	collision_polygon.polygon = polygon.polygon


func erase():
	can_erase = false
	print("erase")
	for i in 2:
		await get_tree().process_frame
	
	#get all vertices within the highlight area
	var vertices : Array[Vertex] = []
	for a in area.get_overlapping_areas():
		if a.get_parent() is Vertex:
			vertices.append(a.get_parent())
	
	
	polygon.polygon = PackedVector2Array()
	collision_polygon.polygon = PackedVector2Array()
	
	
	for v in vertices:
		if v in highlighted_vertices:
			unhighlight_vertex(v)
		else:
			highlight_vertex(v)
	
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	print_highlighted_vertices()
	
	
	return true


func print_highlighted_vertices():
	print("highlighted vertices:")
	for v in highlighted_vertices:
		print(" ", v.name)


func unhighlight_all_vertices():
	for v in highlighted_vertices:
		v.unhighlight()
	
	highlighted_vertices.clear()

func has_highlighted_vertices():
	return highlighted_vertices.size() != 0

func highlight_vertex(v:Vertex):
	v.highlight()
	if not (v in highlighted_vertices):
		highlighted_vertices.append(v)

func unhighlight_vertex(v:Vertex):
	v.unhighlight()
	if v in highlighted_vertices:
		highlighted_vertices.erase(v)
