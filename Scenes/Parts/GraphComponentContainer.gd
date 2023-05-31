class_name GraphComponentContainer
extends Node


func remove(p : GraphComponent):
	p.remove()


func queue_free_all():
	for p in get_children():
		p.queue_free()

func remove_all():
	for p in get_children():
		p = p as GraphComponent
		p.remove()


