class_name Graph
extends Node2D


#graph data
@export var graph_data : GraphData

#data of graph as json file
@export var data_json : JSON = null

#sets of vertices and edges
@export_group("Container Nodes")
@export var vertex_container : Node2D
@export var edge_container : Node2D

#resources
@export_group("Resources")
@export var vertex_resource : Resource
@export var edge_resource : Resource


#arrays
var vertex_array : Array[Vertex]
var edge_array : Array[Edge]



func add_vertex(pos, editable=false):
	var new_vtx = vertex_resource.instantiate()
	new_vtx.position = pos
	new_vtx.editable = editable
	new_vtx.index = vertex_container.get_children().size()
	new_vtx.editable = true
	vertex_array.append(new_vtx)
	vertex_container.add_child(new_vtx)

func remove_vertex(vertex : Vertex):
	for edge in edge_array:
		if edge.contains_vertex(vertex):
			edge_array.erase(edge)
			edge.remove()
	vertex_array.erase(vertex)
	vertex.remove()


func add_edge(start_vtx, end_vtx):
	var new_edge = edge_resource.instantiate()
	new_edge.start_vtx = start_vtx
	new_edge.end_vtx = end_vtx
	edge_container.add_child(new_edge)
	edge_array.append(new_edge)

func remove_edge(edge : Edge):
	edge_array.erase(edge)
	edge.remove()


func clear_graph():
	for e in edge_array:
		remove_edge(e)
	
	for v in vertex_array:
		remove_vertex(v)


func add_vertex_in_editor():
	var pos = get_viewport_rect().size / 2
	add_vertex(pos, true)


func vertex_mode():
	for vtx in vertex_array:
		vtx.editable = true
	
	for edge in edge_array:
		edge.editable = false

func edge_mode():
	for vtx in vertex_array:
		vtx.editable = false
	
	for edge in edge_array:
		edge.editable = true
