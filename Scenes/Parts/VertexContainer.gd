class_name VertexContainer
extends GraphComponentContainer



var vertices :
	get:
		return get_children()


func add_vertex(vtx:Vertex):
	add_child(vtx)

func add_new_vertex(vtx_resource: Resource, pos:Vector2):
	var new_vtx = vtx_resource.instantiate()
	new_vtx.index = vertices.size()
	new_vtx.position = pos
	add_vertex(new_vtx)
	return new_vtx

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

func get_vertex_from_index(index:int):
	for v in vertices:
		if v.index == index:
			return v
	return null
