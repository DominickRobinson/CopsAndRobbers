class_name Cop
extends Agent



#func _ready():
#	super._ready()
##	arrived.connect(check_for_robbers)
#	add_to_group("Cops")
#
#
#func capture(robber:Robber):
#	play_final_animation("capture")
#
##	await anim.animation_finished
#
#	robber.get_captured()
#
##	await robber.caught
#
#
#
#
#func check_for_robbers():
#	if not is_instance_valid(current_vertex): return
#
#	for o in current_vertex.get_occupents():
#		if o is Robber:
#			o = o as Robber
#			if not o.captured:
#				capture(o)
