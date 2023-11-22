extends Node


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
