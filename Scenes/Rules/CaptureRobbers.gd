extends Node



var cops
var robbers

func _ready():
	cops = get_tree().get_nodes_in_group("Cops")
	robbers = get_tree().get_nodes_in_group("Robbers")
	
	print(cops)
	print(robbers)
	
	for c in cops:
		c = c as Cop
		c.arrived.connect(check_for_robbers)
	for r in robbers:
		r = r as Robber
		r.arrived.connect(check_for_robbers)

func check_for_robbers():
	for c in cops:
		c = c as Cop
		await c.check_for_robbers()
		
