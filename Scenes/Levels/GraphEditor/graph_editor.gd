extends Node


var selected_vertices : Array[Vertex]
var selected_edges : Array[Edge]

var clicked_on_vertex = false
var clicked_on_edge = false


var click_global_position : Vector2




























#signal mode_changed(mode)
#
#enum Modes {VERTEX_MODE, EDGE_MODE}
#
#var _mode : int = Modes.VERTEX_MODE
#
#
#func _physics_process(_delta):
#	match _mode:
#		Modes.VERTEX_MODE:
#			pass
#
#		Modes.EDGE_MODE:
#			pass
#
#
#func set_mode_to_vertex_mode(_arg):
#	_mode = Modes.VERTEX_MODE
#	emit_signal("mode_changed", _mode)
#
#
#func set_mode_to_edge_mode(_arg):
#	_mode = Modes.EDGE_MODE
#	emit_signal("mode_changed", _mode)
#
#func get_vertex_mode():
#	return _mode == Modes.VERTEX_MODE
#
#func get_edge_mode():
#	return _mode == Modes.EDGE_MODE
