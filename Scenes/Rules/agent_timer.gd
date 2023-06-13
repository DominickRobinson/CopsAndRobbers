extends Timer

@export var total_time : int = 60
@export var label : Label


func _ready():
	wait_time = total_time

func _process(delta):
	if is_instance_valid(label):
#		label.text = "Time remaining: "
		label.text = name + ": "
		label.text += str(time_left)


func restart():
	start(total_time)
