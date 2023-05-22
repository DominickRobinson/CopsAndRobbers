extends Control


@export var graph_data : GraphData

@export var graph_text_display : Label

@export var remove_vertex_index : SpinBox

@export var add_edge_start_index : SpinBox
@export var add_edge_end_index : SpinBox
@export var remove_edge_start_index : SpinBox
@export var remove_edge_end_index : SpinBox



func _ready():
	display_graph()


func display_graph():
	graph_text_display.text = graph_data.display()


func make_reflexive():
	graph_data.make_reflexive()
	display_graph()

func make_undirected():
	graph_data.make_undirected()
	display_graph()

func add_vertex():
	graph_data.add_vertex()
	display_graph()

func remove_vertex():
	var vtx = remove_vertex_index.value
	graph_data.remove_vertex(vtx)
	display_graph()

func add_edge():
	var start_vtx = add_edge_start_index.value
	var end_vtx = add_edge_end_index.value
	graph_data.add_edge(start_vtx, end_vtx)
	display_graph()

func remove_edge():
	var start_vtx = add_edge_start_index.value
	var end_vtx = add_edge_end_index.value
	graph_data.remove_edge(start_vtx, end_vtx)
	display_graph()

func fill_graph():
	graph_data.fill()
	display_graph()

func clear_graph():
	graph_data.clear()
	display_graph()

func invert_graph():
	graph_data.invert()
	display_graph()
