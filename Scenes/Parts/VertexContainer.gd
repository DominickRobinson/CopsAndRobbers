class_name VertexContainer
extends GraphComponentContainer


var vertices :
	get:
		return get_children()


func add_vertex(vtx:Vertex):
	add_child(vtx)

func remove_vertex(vtx:Vertex):
	for v in vertices:
		v = v as Vertex
		if v.index > vtx.index:
			v.index -= 1
	
	vtx.remove()


func make_vertices_editable(editable:bool=true):
	for v in vertices:
		v = v as Vertex
		v.editable = editable

func get_vertex_with_index(index:int):
	for v in vertices:
		if v.index == index:
			return v
	return null
