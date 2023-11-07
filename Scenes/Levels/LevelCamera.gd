class_name LevelCamera
extends Camera2D


var zoom_scale = 1.0

func _ready():
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	global_position = Vector2(screen_width/2, screen_height/2)



func set_zoom_scale(s : float = 1.0):
	zoom_scale = s
	zoom = Vector2.ONE * s


func get_zoom_scale():
	return zoom_scale
