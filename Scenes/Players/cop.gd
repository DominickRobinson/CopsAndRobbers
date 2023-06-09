class_name Cop
extends Player



func _ready():
	super._ready()
#	arrived.connect(check_for_robbers)
	add_to_group("Cops")


func capture(robber:Robber):
	print(5)
	robber.get_captured()
	
	print(6)
	anim.play("capture")



func check_for_robbers():
	if not is_instance_valid(current_vertex): return
	
	for o in current_vertex.get_occupents():
		if o is Robber:
			o = o as Robber
			if o.captured:
				capture(o)
