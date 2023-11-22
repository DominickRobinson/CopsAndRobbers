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
@export var corner_spinbox : SpinBox
@export var zoom_spinbox : SpinBox

@export_group("Metadata text edits")
@export var title_text_edit : TextEdit
@export var author_text_edit : TextEdit
@export var description_text_edit : TextEdit
@export var citation_text_edit : TextEdit

@export_group("Save and load nodes")
@export var save_file_dialog : FileDialog
@export var load_file_dialog : FileDialog
@export var add_file_dialog : FileDialog

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

var pan_camera_initial_position : Vector2
var panning_camera = false


func _ready():
#	graph.changed.connect(_on_graph_changed)
#	graph.refreshed.connect(refresh)
	graph.refreshed.connect(refresh)
	
	save_file_dialog.file_selected.connect(graph.save_graph)
	load_file_dialog.file_selected.connect(load_graph)
	add_file_dialog.file_selected.connect(add_graph)
	
	title_text_edit.text_changed.connect(set_title)
	author_text_edit.text_changed.connect(set_author)
	description_text_edit.text_changed.connect(set_description)
	citation_text_edit.text_changed.connect(set_citation)
	
	graph.changed.connect(graph.set_graph_data_display_label)
	graph.changed.connect(set_zoom_label)
	
	for n in Globals.get_all_children(self):
		if n is Button:
			n = n as Button
			n.focus_mode = Control.FOCUS_NONE

func set_zoom_label():
	zoom_spinbox.value = graph.get_zoom_scale()

func load_graph(path):
	graph.load_graph(path)
	
	title_text_edit.text = graph.title
	author_text_edit.text = graph.author
	description_text_edit.text = graph.description
	citation_text_edit.text = graph.citation

func add_graph(path):
	graph.add_graph(path)


func _on_graph_changed():
	graph.refresh()


func set_title(): graph.title = title_text_edit.text
func set_author(): graph.author = author_text_edit.text
func set_description(): graph.description = description_text_edit.text
func set_citation(): graph.citation = citation_text_edit.text


func _unhandled_input(_event):
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_spinbox.value += zoom_spinbox.step
	if Input.is_action_just_pressed("zoom_out"):
		zoom_spinbox.value -= zoom_spinbox.step
	
	
	if Input.is_action_just_pressed("select") and hovering_vertex != null:
		hovering_vertex.selected.emit()
	
	match mode:
		Modes.VertexMode:
			if Input.is_action_just_pressed("select") and hovering_vertex == null:
#				add_vertex()
				pass
			if Input.is_action_just_released("delete") and hovering_vertex != null:
				remove_vertex()
		Modes.EdgeMode:
			
			if Input.is_action_just_pressed("select") and hovering_vertex != null and selected_vertex == null:
				SoundManager.play_sound("sound_edge_add_start")
			
			if Input.is_action_just_released("select") and hovering_vertex != null and selected_vertex != null:
				add_edge()
				SoundManager.play_sound("sound_edge_add")
			
			if Input.is_action_just_released("delete") and hovering_vertex != null:
				remove_edge_given_vertex(hovering_vertex)
				SoundManager.play_sound("sound_edge_remove")
			elif Input.is_action_just_released("delete") and hovering_edge != null:
				remove_edge()
				SoundManager.play_sound("sound_edge_remove")
	
	if Input.is_action_just_released("select"):
		selected_vertex = null
	
	if Input.is_action_just_pressed("pan_camera"):
		print("begin panning camera")
		pan_camera_initial_position = get_global_mouse_position()
		panning_camera = true
	if Input.is_action_just_released("pan_camera"):
		print("end panning camera")
		graph.camera.global_position += graph.camera.offset
		graph.camera.offset *= 0
		panning_camera = false


func _process(_delta):
#	display_selected_vertex()
	
	if mode == Modes.EdgeMode and selected_vertex != null:
		new_edge_line.points = PackedVector2Array([selected_vertex.position, get_global_mouse_position()])
	else:
		new_edge_line.clear_points()
	
	if panning_camera:
		print("panning camera")
		graph.camera.offset = pan_camera_initial_position - get_global_mouse_position()
		



func add_vertex2():
	var pos = await vertex_spawn_position.find_open_position()
	var _v = await graph.add_vertex(pos) as Vertex
	
	SoundManager.play_sound("sound_vertex_add")
	
	set_vertex_mode()
	

func add_vertex():
	var pos = get_global_mouse_position()
	var _v = await graph.add_vertex(pos) as Vertex
	
	SoundManager.play_sound("sound_vertex_add")


func add_corner():
	var pos = await vertex_spawn_position.find_open_position()
	graph.add_corner(pos, corner_spinbox.value)
	
	SoundManager.play_sound("sound_vertex_add")
	
	set_vertex_mode()

func add_strict_corner():
	var pos = await vertex_spawn_position.find_open_position()
	graph.add_strict_corner(pos, corner_spinbox.value)
	
	SoundManager.play_sound("sound_vertex_add")
	
	set_vertex_mode()

func remove_vertex():
	graph.remove_vertex(hovering_vertex)
	
	SoundManager.play_sound("sound_vertex_remove")
	


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

func retract_twin():
	graph.retract_twin()

func retract_twins():
	graph.retract_twins()

func retract_strict_corner():
	graph.retract_strict_corner()

func retract_strict_corners():
	graph.retract_strict_corners()

func retract_corners():
	graph.retract_corners()

func empty_graph():
	graph.empty()

func refresh():
	await Globals.wait(0)
#	await graph.refresh()
	
	for e in graph.edges:
		if not e.is_connected("mouse_entered", set_hovering_edge.bind(e)):
			e.mouse_entered.connect(set_hovering_edge.bind(e))
		if not e.is_connected("mouse_exited", set_hovering_edge.bind(null)):
			e.mouse_exited.connect(set_hovering_edge.bind(null))
	
	for v in graph.vertices:
		if not v.is_connected("selected", set_selected_vertex.bind(v)):
			v.selected.connect(set_selected_vertex.bind(v))
		if not v.is_connected("deselected", set_selected_vertex.bind(null)):
			v.deselected.connect(set_selected_vertex.bind(null))
		if not v.is_connected("mouse_entered", set_hovering_vertex.bind(v)):
			v.mouse_entered.connect(set_hovering_vertex.bind(v))
		if not v.is_connected("mouse_exited", set_hovering_vertex.bind(null)):
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
	
	var array = selected_vertices
	if mode == Modes.VertexMode: array = selected_end_vertices
	
	if not (vtx in selected_vertices):
		array.append(vtx)
	else:
		array.erase(vtx)

func toggle_edge_in_selected(e:Edge):
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


func organize_by_ranking():
	graph.set_positions_by_ranking()

func print_distance_matrix():
	print("Distance matrix:")
	Globals.print_array(graph.recalculate_distance_matrix())
