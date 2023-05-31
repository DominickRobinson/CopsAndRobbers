class_name GraphEditor
extends Node2D


@export var graph : Graph

@export var vertex_spawn_position : Node2D

@export_group("Some control nodes")
@export var add_vertex_button : Button
@export var selected_label : Label

enum Modes {VertexMode, EdgeMode}

var mode = Modes.VertexMode 

var hovering_vertex : Vertex = null
var hovering_edge : Edge = null
var selected_vertex : Vertex = null:
	set(value):
		selected_vertex = value

var selected_vertices : Array[Vertex]
var selected_edges : Array[Edge]

var selected_end_vertices : Array[Vertex]

var clicked_on_vertex = false
var clicked_on_edge = false


var click_global_position : Vector2



func _unhandled_input(event):
	if Input.is_action_just_released("select") and mode == Modes.EdgeMode and hovering_vertex != null and selected_vertex != null:
		add_edge()
	
	if Input.is_action_just_released("delete") and mode == Modes.VertexMode and hovering_vertex != null:
		remove_vertex()
	
	if Input.is_action_just_released("delete") and mode == Modes.EdgeMode and hovering_edge != null:
		print(2)
		remove_edge()
	

func _process(delta):
	display_selected_vertex()




func add_vertex():
	var pos = await vertex_spawn_position.find_open_position()
	
	var v = graph.add_vertex(pos, true) as Vertex
	
	
	v.selected.connect(set_selected_vertex.bind(v))
	v.mouse_entered.connect(set_hovering_vertex.bind(v))
	v.mouse_exited.connect(set_hovering_vertex.bind(null))


func remove_vertex():
	graph.remove_vertex(hovering_vertex)


func add_edge():
	var e = graph.add_edge(selected_vertex, hovering_vertex) as Edge
	if is_instance_valid(e):
		e.mouse_entered.connect(set_hovering_edge.bind(e))
		e.mouse_exited.connect(set_hovering_edge.bind(null))

func remove_edge():
	graph.remove_edge(hovering_edge)



func set_vertex_mode():
	clear_selections()
	
	mode = Modes.VertexMode
	
	graph.set_vertex_mode()
	add_vertex_button.disabled = false 

func set_edge_mode():
	clear_selections()
	
	mode = Modes.EdgeMode
	
	graph.set_edge_mode()
	add_vertex_button.disabled = true


func set_hovering_vertex(v:Vertex):
	hovering_vertex = v

func set_hovering_edge(e:Edge):
	hovering_edge = e

func set_selected_vertex(v:Vertex):
	print("Selected: ", v)
	selected_vertex = v



func display_selected_vertex():
	var t = ""
	t += "Selected vertex: "
	if is_instance_valid(selected_vertex):
		t += str(selected_vertex)
	else:
		t += "None"
	
	t += "\nHovering vertex: "
	if is_instance_valid(hovering_vertex):
		t += str(hovering_vertex)
	else:
		t += "None"
	
	t += "\nHovering edge: "
	if is_instance_valid(hovering_edge):
		t += str(hovering_edge)
	else:
		t += "None"
	
	selected_label.text = t



















func _on_add_pressed():
	if mode == Modes.VertexMode:
		add_vertex()
	else:
		add_edges()


func _on_remove_pressed():
	if mode == Modes.VertexMode:
		remove_vertices()
	else:
		remove_edges()


func toggle_vertex_in_selected(vtx:Vertex):
	selected_vertex = vtx
#	print("toggling the following vertex: ", str(vtx))
	
	var array = selected_vertices
	if mode == Modes.VertexMode: array = selected_end_vertices
	
	if not (vtx in selected_vertices):
		array.append(vtx)
	else:
		array.erase(vtx)

func toggle_edge_in_selected(e:Edge):
	
#	print("toggling the following edge: ", str(e))
	
	if not (e in selected_edges):
		selected_edges.append(e)
	else:
		selected_edges.erase(e)

func clear_selections():
	selected_vertices.clear()
	selected_edges.clear()



func remove_vertices():
	for v in selected_vertices:
		v = v as Vertex
		graph.remove_vertex(v)
	clear_selections()

func add_edges():
	for v_start in selected_vertices:
		for v_end in selected_end_vertices:
			var e = graph.add_edge(v_start, v_end) as Edge
			e.selected.connect(toggle_edge_in_selected)
	clear_selections()

func remove_edges():
	for e in selected_edges:
		e = e as Edge
		graph.remove_edge(e)
	clear_selections()
