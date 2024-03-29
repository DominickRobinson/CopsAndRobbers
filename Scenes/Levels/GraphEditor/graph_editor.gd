class_name GraphEditor
extends Node2D


@export var graph : Graph

@export var vertex_spawn_position : Node2D

@export_group("Some control nodes")
@export var add_vertex_button : Button
@export var selected_label : Label
@export var vertex_mode_button : Button
@export var edge_mode_button : Button
@export var new_edge_line : Line2D

@export_group("Save and load nodes")
@export var save_file_dialog : FileDialog
@export var load_file_dialog : FileDialog

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

var edits : Array


func _ready():
	graph.changed.connect(_on_graph_changed)
	graph.refreshed.connect(refresh)
	
	save_file_dialog.file_selected.connect(graph.save_graph)
	load_file_dialog.file_selected.connect(graph.load_graph)


func _on_graph_changed():
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("select") and hovering_vertex != null:
		hovering_vertex.selected.emit()
	
	match mode:
		Modes.VertexMode:
			if Input.is_action_just_released("delete") and hovering_vertex != null:
				remove_vertex()
		Modes.EdgeMode:
			if Input.is_action_just_released("select") and hovering_vertex != null and selected_vertex != null:
				add_edge()
			
			if Input.is_action_just_released("delete") and hovering_vertex != null:
				remove_edge_given_vertex(hovering_vertex)
			elif Input.is_action_just_released("delete") and hovering_edge != null:
				remove_edge()
	
	if Input.is_action_just_released("select"):
		selected_vertex = null

func _process(delta):
	display_selected_vertex()
	
	if mode == Modes.EdgeMode and selected_vertex != null:
		new_edge_line.points = PackedVector2Array([selected_vertex.position, get_global_mouse_position()])
	else:
		new_edge_line.clear_points()




func add_vertex():
	var pos = await vertex_spawn_position.find_open_position()
	var v = graph.add_vertex(pos) as Vertex
	
	set_vertex_mode()



func remove_vertex():
	graph.remove_vertex(hovering_vertex)
	


func add_edge():
	graph.add_edge(selected_vertex, hovering_vertex)


func remove_edge(edge : Edge = hovering_edge):
	if not edge.directed:
		graph.remove_edge_given_vertices(edge.end_vertex, edge.start_vertex)
	graph.remove_edge(edge)


func remove_edge_given_vertex(vtx:Vertex):
	graph.remove_edge_given_vertices(vtx,vtx)


func make_reflexive():
	graph.make_reflexive()

func make_undirected():
	graph.make_undirected()

func fill():
	graph.fill()

func clear():
	graph.clear()

func invert():
	graph.invert()

func square():
	graph.square()

func retract_strict_corners():
	graph.retract_strict_corners()

func retract_corners():
	graph.retract_corners()


func refresh():
	for e in graph.edges:
		e.mouse_entered.connect(set_hovering_edge.bind(e))
		e.mouse_exited.connect(set_hovering_edge.bind(null))
	
	for v in graph.vertices:
		v.selected.connect(set_selected_vertex.bind(v))
		v.deselected.connect(set_selected_vertex.bind(null))
		v.mouse_entered.connect(set_hovering_vertex.bind(v))
		v.mouse_exited.connect(set_hovering_vertex.bind(null))
	
	if mode == Modes.VertexMode:
		set_vertex_mode()
	elif mode == Modes.EdgeMode:
		set_edge_mode()


func set_vertex_mode():
	clear_selections()
	
	mode = Modes.VertexMode
	
	graph.set_vertex_mode()
	
	vertex_mode_button.button_pressed = true
	

func set_edge_mode():
	clear_selections()
	
	mode = Modes.EdgeMode
	
	graph.set_edge_mode()
	
	edge_mode_button.button_pressed = true



func set_hovering_vertex(v:Vertex):
	hovering_vertex = v

func set_hovering_edge(e:Edge):
	hovering_edge = e

func set_selected_vertex(v:Vertex):
	selected_vertex = v
	if is_instance_valid(v) and mode == Modes.VertexMode: v.draggable = true



func display_selected_vertex():
	var t = ""
	t += "Selected vertex: \n  "
	if is_instance_valid(selected_vertex):
		t += str(selected_vertex)
	else:
		t += "None"
	
	t += "\nHovering vertex: \n  "
	if is_instance_valid(hovering_vertex):
		t += str(hovering_vertex)
	else:
		t += "None"
	
	t += "\nHovering edge: \n  "
	if is_instance_valid(hovering_edge):
		t += str(hovering_edge)
	else:
		t += "None"
	
	selected_label.text = t



func print_mappings():
	graph.graph_data.print_F_k_mappings(graph.graph_data)















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


