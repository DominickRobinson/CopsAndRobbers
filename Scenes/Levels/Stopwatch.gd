class_name Stopwatch
extends Label

var time_elapsed := 0.0

var stopped = false

func _process(delta: float) -> void:
	if stopped:
		return
	
	time_elapsed += delta
	
	text = "Time elapsed: " + get_time_string()

func stop():
	stopped = true

func get_time_string():
	var str = str(round(time_elapsed/60)) + ":"
	if round(fmod(time_elapsed,60)) < 10:
		str += "0"
	str += str(round(fmod(time_elapsed, 60)))
	return str
