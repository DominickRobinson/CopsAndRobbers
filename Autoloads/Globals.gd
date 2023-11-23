extends Node


func _unhandled_input(_event):
	if Input.is_action_just_pressed("screenshot"):
		take_screenshot()

func get_all_children(node, arr:=[]):
	arr.push_back(node)
	for child in node.get_children():
		arr = get_all_children(child, arr)
	return arr

func wait(time=0.0):
	await get_tree().create_timer(time).timeout
	return true

func print_array(arr:Array):
	var output = ""
	for i in arr.size():
		output += "[ "
		#for each column
		for j in arr.size():
			output += str(int(arr[i][j])) + " "
		output += "]\n"
	print(output)
	return output


func take_screenshot():
	var capture = get_viewport().get_texture().get_image()
	var filename = "res://Screenshots/{0}.png".format({"0":get_tree().current_scene.name})
	capture.save_png(filename) 	
	await wait(0)
	
	var prompt = load("res://Screenshots/screenshot_taken_prompt.tscn").instantiate()
	get_tree().current_scene.add_child(prompt)


func save_node_as_packed_scene(node:Node, path:String=""):
	if path == "":
		return
	
	var scene = PackedScene.new()
	scene.pack(node)
	ResourceSaver.save(scene, path)

func get_graph():
	return get_tree().get_first_node_in_group("Graphs")
